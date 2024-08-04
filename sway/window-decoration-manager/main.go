package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"strings"
	"time"

	"github.com/joshuarubin/go-sway"
)

type decorationHandler struct {
	sway.EventHandler
	client sway.Client
	log    *log.Logger
}

func (dh *decorationHandler) Window(ctx context.Context, e sway.WindowEvent) {
	dh.log.Printf("Received window event: Change=%s, Container.ID=%d", e.Change, e.Container.ID)

	// Handle more event types
	if e.Change == "new" || e.Change == "move" || e.Change == "floating" || e.Change == "tiling" || e.Change == "focus" {
		// Add a small delay to allow for window state to stabilize
		time.Sleep(100 * time.Millisecond)

		go dh.handleWindowChange(ctx, e.Container.ID)
	}
}

func (dh *decorationHandler) handleWindowChange(ctx context.Context, id int64) {
	for i := 0; i < 3; i++ { // Retry up to 3 times
		tree, err := dh.client.GetTree(ctx)
		if err != nil {
			dh.log.Printf("Error getting tree: %v", err)
			time.Sleep(100 * time.Millisecond)
			continue
		}

		node := dh.findNode(tree, id)
		if node == nil {
			dh.log.Printf("Node not found: %d", id)
			time.Sleep(100 * time.Millisecond)
			continue
		}

		if dh.updateWindowDecoration(ctx, node) {
			return // Successfully updated
		}

		time.Sleep(100 * time.Millisecond)
	}
	dh.log.Printf("Failed to update window decoration after 3 attempts for ID: %d", id)
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
	dh.log.Printf("Updating window: ID=%d, Type=%s, Layout=%s, AppID=%v", node.ID, node.Type, node.Layout, node.AppID)

	var borderCmd string
	if node.Type == "floating_con" {
		if dh.hasCSD(node) {
			borderCmd = fmt.Sprintf("[con_id=%d] border none", node.ID)
			dh.log.Println("Setting border none for floating window with CSD")
		} else {
			borderCmd = fmt.Sprintf("[con_id=%d] border normal", node.ID)
			dh.log.Println("Setting border normal for floating window without CSD")
		}
	} else { // tiled, tabbed, or stacked
		borderCmd = fmt.Sprintf("[con_id=%d] border pixel 2", node.ID)
		dh.log.Println("Setting border pixel 2 for tiled/tabbed/stacked window")
	}

	_, err := dh.client.RunCommand(ctx, borderCmd)
	if err != nil {
		dh.log.Printf("Error setting border: %s", err)
		return false
	}

	// Verify the border setting
	tree, err := dh.client.GetTree(ctx)
	if err != nil {
		dh.log.Printf("Error getting tree: %v", err)
		return false
	}
	updatedNode := dh.findNode(tree, node.ID)
	if updatedNode == nil {
		dh.log.Printf("Updated node not found: %d", node.ID)
		return false
	}

	dh.log.Printf("Updated border for window ID=%d: %s", updatedNode.ID, updatedNode.Border)

	// Check if the update was successful
	if (node.Type == "floating_con" && !dh.hasCSD(node) && updatedNode.Border != "normal") ||
	   (node.Type == "floating_con" && dh.hasCSD(node) && updatedNode.Border != "none") ||
	   (node.Type != "floating_con" && updatedNode.Border != "pixel") {
		dh.log.Printf("Border update unsuccessful for window ID=%d", node.ID)
		return false
	}

	return true
}

func (dh *decorationHandler) hasCSD(node *sway.Node) bool {
	csdApps := []string{"firefox", "chromium", "google-chrome", "electron", "nautilus", "org.gnome"}

	if node.AppID != nil {
		appID := strings.ToLower(*node.AppID)
		for _, app := range csdApps {
			if strings.Contains(appID, app) {
				dh.log.Printf("Detected CSD for AppID: %s", *node.AppID)
				return true
			}
		}
	}

	if node.Shell != nil && strings.Contains(strings.ToLower(*node.Shell), "client_side_decorations") {
		dh.log.Printf("Detected CSD from Shell: %s", *node.Shell)
		return true
	}

	if node.WindowProperties != nil && node.WindowProperties.Class != "" {
		class := strings.ToLower(node.WindowProperties.Class)
		if strings.Contains(class, "gtk") {
			dh.log.Printf("Detected CSD for GTK app: %s", node.WindowProperties.Class)
			return true
		}
	}

	dh.log.Printf("No CSD detected for window ID=%d", node.ID)
	return false
}

func main() {
	logger := log.New(os.Stdout, "window-decorator: ", log.LstdFlags)
	logger.Println("Window decoration manager started")

	ctx := context.Background()

	client, err := sway.New(ctx)
	if err != nil {
		logger.Fatalf("Failed to create Sway client: %v", err)
	}

	handler := &decorationHandler{
		client: client,
		log:    logger,
	}

	err = sway.Subscribe(ctx, handler, sway.EventTypeWindow)
	if err != nil {
		logger.Fatalf("Failed to subscribe to events: %v", err)
	}

	// Keep the program running
	select {}
}
