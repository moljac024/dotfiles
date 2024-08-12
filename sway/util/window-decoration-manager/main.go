package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"

	"github.com/BurntSushi/toml"
	"github.com/joshuarubin/go-sway"
)

type Config struct {
	CSDPatterns []string `toml:"csd_patterns"`
	BorderWidth int      `toml:"border_width"`
	CSDBorder   bool     `toml:"csd_border"`
}

type decorationHandler struct {
	sway.EventHandler
	client  sway.Client
	log     *log.Logger
	mutex   sync.Mutex
	config  Config
	verbose bool
}

func (dh *decorationHandler) logf(format string, v ...interface{}) {
	if dh.verbose {
		dh.log.Printf(format, v...)
	}
}

func (dh *decorationHandler) Window(ctx context.Context, e sway.WindowEvent) {
	dh.logf("Received window event: Change=%s, Container.ID=%d", e.Change, e.Container.ID)

	go dh.handleWindowChange(ctx, e.Container.ID)
}

func (dh *decorationHandler) handleWindowChange(ctx context.Context, id int64) {
	dh.mutex.Lock()
	defer dh.mutex.Unlock()

	for i := 0; i < 5; i++ { // Retry up to 5 times
		time.Sleep(200 * time.Millisecond)

		tree, err := dh.client.GetTree(ctx)
		if err != nil {
			dh.logf("Error getting tree: %v", err)
			continue
		}

		node := dh.findNode(tree, id)
		if node == nil {
			dh.logf("Node not found: %d", id)
			continue
		}

		if dh.updateWindowDecoration(ctx, node) {
			return // Successfully updated
		}
	}
	dh.logf("Failed to update window decoration after 5 attempts for ID: %d", id)
}

func (dh *decorationHandler) findNode(node *sway.Node, id int64) *sway.Node {
	if node.ID == id {
		return node
	}
	for _, child := range append(node.Nodes, node.FloatingNodes...) {
		if found := dh.findNode(child, id); found != nil {
			return found
		}
	}
	return nil
}

func (dh *decorationHandler) updateWindowDecoration(ctx context.Context, node *sway.Node) bool {
	dh.logf("Updating window: ID=%d, Type=%s, Layout=%s, AppID=%v, Current Border=%s", node.ID, node.Type, node.Layout, node.AppID, node.Border)

	// If Sway has already set the border to "csd", respect that decision
	if node.Border == "csd" && !dh.config.CSDBorder {
		dh.logf("Sway has set border to 'csd' for window ID=%d, respecting this setting", node.ID)
		return true
	}

	var desiredBorder sway.Border = "pixel"

	if node.Type == "floating_con" {
		if dh.hasCSD(node) {
			desiredBorder = "none"

			if dh.config.CSDBorder {
				desiredBorder = "pixel"
			}

		} else {
			desiredBorder = "pixel"
		}
	} else { // tiled, tabbed, or stacked
		desiredBorder = "pixel"
	}

	// Only update if the current border is different from the desired border
	if node.Border != desiredBorder {
		borderCmd := fmt.Sprintf("[con_id=%d] border %s", node.ID, desiredBorder)
		if desiredBorder == "pixel" {
			borderCmd += fmt.Sprintf(" %d", dh.config.BorderWidth)
		}

		dh.logf("Setting border to %s for window ID=%d", desiredBorder, node.ID)
		_, err := dh.client.RunCommand(ctx, borderCmd)
		if err != nil {
			dh.logf("Error setting border: %s", err)
			return false
		}

		// Verify the border setting
		tree, err := dh.client.GetTree(ctx)
		if err != nil {
			dh.logf("Error getting tree: %v", err)
			return false
		}
		updatedNode := dh.findNode(tree, node.ID)
		if updatedNode == nil {
			dh.logf("Updated node not found: %d", node.ID)
			return false
		}

		dh.logf("Updated border for window ID=%d: %s", updatedNode.ID, updatedNode.Border)

		// Check if the update was successful
		if updatedNode.Border != desiredBorder && updatedNode.Border != "csd" {
			dh.logf("Border update unsuccessful for window ID=%d", node.ID)
			return false
		}
	} else {
		dh.logf("Border already set to %s for window ID=%d, no update needed", desiredBorder, node.ID)
	}

	return true
}

func (dh *decorationHandler) hasCSD(node *sway.Node) bool {
	var appID, class string
	if node.AppID != nil {
		appID = *node.AppID
	}
	if node.WindowProperties != nil {
		class = node.WindowProperties.Class
	}

	dh.logf("Checking CSD for window ID=%d, AppID=%s, Class=%s", node.ID, appID, class)

	for _, pattern := range dh.config.CSDPatterns {
		parts := strings.SplitN(pattern, "~", 2)
		if len(parts) != 2 {
			parts = strings.SplitN(pattern, "=", 2)
		}
		if len(parts) != 2 {
			dh.logf("Invalid pattern format: %s", pattern)
			continue
		}

		patternType, value := parts[0], parts[1]
		isPartial := strings.Contains(pattern, "~")

		switch patternType {
		case "name":
			if (isPartial && strings.Contains(strings.ToLower(node.Name), strings.ToLower(value))) ||
				(!isPartial && strings.EqualFold(node.Name, value)) {
				dh.logf("Detected CSD: name match %s", pattern)
				return true
			}
		case "class":
			if (isPartial && strings.Contains(strings.ToLower(class), strings.ToLower(value))) ||
				(!isPartial && strings.EqualFold(class, value)) {
				dh.logf("Detected CSD: class match %s", pattern)
				return true
			}
		case "app":
			if (isPartial && strings.Contains(strings.ToLower(appID), strings.ToLower(value))) ||
				(!isPartial && strings.EqualFold(appID, value)) {
				dh.logf("Detected CSD: AppID match %s", pattern)
				return true
			}
		default:
			dh.logf("Unknown pattern type: %s", patternType)
		}
	}

	if node.Shell != nil && strings.Contains(strings.ToLower(*node.Shell), "client_side_decorations") {
		dh.logf("Detected CSD from Shell: %s", *node.Shell)
		return true
	}

	// Check if Sway has identified this as a CSD window
	if node.Border == "csd" {
		dh.logf("Detected CSD: Sway reports Border as 'csd' for window ID=%d", node.ID)
		return true
	}

	dh.logf("No CSD detected for window ID=%d", node.ID)
	return false
}

func (dh *decorationHandler) periodicCheck(ctx context.Context) {
	ticker := time.NewTicker(5 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			dh.checkAllWindows(ctx)
		}
	}
}

func (dh *decorationHandler) checkAllWindows(ctx context.Context) {
	dh.mutex.Lock()
	defer dh.mutex.Unlock()

	tree, err := dh.client.GetTree(ctx)
	if err != nil {
		dh.logf("Error getting tree: %v", err)
		return
	}

	dh.checkNodeAndChildren(ctx, tree)
}

func (dh *decorationHandler) checkNodeAndChildren(ctx context.Context, node *sway.Node) {
	if node.Type == "con" || node.Type == "floating_con" {
		dh.updateWindowDecoration(ctx, node)
	}

	for _, child := range append(node.Nodes, node.FloatingNodes...) {
		dh.checkNodeAndChildren(ctx, child)
	}
}

func (dh *decorationHandler) printWindowInfo(ctx context.Context) {
	tree, err := dh.client.GetTree(ctx)
	if err != nil {
		dh.logf("Error getting tree: %v", err)
		return
	}

	dh.printNodeInfo(tree, 0)
}

func (dh *decorationHandler) printNodeInfo(node *sway.Node, depth int) {
	if node.Type == "con" || node.Type == "floating_con" {
		indent := strings.Repeat("  ", depth)
		appID := "N/A"
		if node.AppID != nil {
			appID = *node.AppID
		}
		class := "N/A"
		if node.WindowProperties != nil {
			class = node.WindowProperties.Class
		}
		fmt.Printf("%sWindow ID: %d\n", indent, node.ID)
		fmt.Printf("%s  Name: %s\n", indent, node.Name)
		fmt.Printf("%s  AppID: %s\n", indent, appID)
		fmt.Printf("%s  Class: %s\n", indent, class)
		fmt.Printf("%s  Type: %s\n", indent, node.Type)
		fmt.Printf("%s  Border: %s\n", indent, node.Border)
		fmt.Println()
	}

	for _, child := range append(node.Nodes, node.FloatingNodes...) {
		dh.printNodeInfo(child, depth+1)
	}
}

func loadConfig(path string) (Config, error) {
	var config Config
	_, err := toml.DecodeFile(path, &config)
	return config, err
}

func main() {
	dumpInfo := flag.Bool("dump", false, "Dump window information and exit")
	configFile := flag.String("config", "", "Path to the configuration file")
	borderWidth := flag.Int("border", 0, "Set the border width (overrides config file)")
	verbose := flag.Bool("v", false, "Enable verbose logging")
	flag.Parse()

	logger := log.New(os.Stdout, "window-decorator: ", log.LstdFlags)

	if *verbose {
		logger.Println("Window decoration manager started")
	}

	// Determine config file path
	var configPath string
	if *configFile != "" {
		configPath = *configFile
	} else {
		configPath = filepath.Join(os.Getenv("HOME"), ".config", "wdm", "config.toml")
	}

	// Load configuration
	config, err := loadConfig(configPath)
	if err != nil {
		if os.IsNotExist(err) {
			if *verbose {
				logger.Printf("Config file not found at %s, using default configuration", configPath)
			}
			config = Config{
				CSDPatterns: []string{},
				BorderWidth: 2, // Default border width
				CSDBorder:   false,
			}
		} else {
			logger.Fatalf("Error loading config from %s: %v", configPath, err)
		}
	} else if *verbose {
		logger.Printf("Loaded configuration from %s", configPath)
	}

	// Override border width if specified in command line
	if *borderWidth != 0 {
		config.BorderWidth = *borderWidth
		if *verbose {
			logger.Printf("Border width set to %d from command line", config.BorderWidth)
		}
	} else if config.BorderWidth == 0 {
		config.BorderWidth = 2 // Default if not set in config file
		if *verbose {
			logger.Printf("Using default border width of %d", config.BorderWidth)
		}
	} else if *verbose {
		logger.Printf("Using border width of %d from config file", config.BorderWidth)
	}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	client, err := sway.New(ctx)
	if err != nil {
		logger.Fatalf("Failed to create Sway client: %v", err)
	}

	handler := &decorationHandler{
		client:  client,
		log:     logger,
		config:  config,
		verbose: *verbose,
	}

	if *dumpInfo {
		handler.printWindowInfo(ctx)
		return
	}

	go handler.periodicCheck(ctx)

	err = sway.Subscribe(ctx, handler, sway.EventTypeWindow)
	if err != nil {
		logger.Fatalf("Failed to subscribe to events: %v", err)
	}

	// Keep the program running
	select {
	case <-ctx.Done():
		if *verbose {
			logger.Println("Context cancelled, shutting down")
		}
	}
}
