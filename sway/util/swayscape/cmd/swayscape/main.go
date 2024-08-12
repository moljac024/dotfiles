package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"strings"
	"syscall"
	"time"

	"github.com/fsnotify/fsnotify"
	"github.com/mitchellh/go-homedir"
	"github.com/moljac024/swayscape/internal/wallpaper"
	"gopkg.in/yaml.v2"
)

type Config struct {
	Directory string        `yaml:"directory"`
	Recursive bool          `yaml:"recursive"`
	Interval  time.Duration `yaml:"interval"`
	Order     string        `yaml:"order"`
	Command   string        `yaml:"command"`
}

func main() {
	config := loadConfig()

	wallpapers, err := scanDirectory(config.Directory, config.Recursive)
	if err != nil {
		log.Fatalf("Error scanning directory: %v", err)
	}

	if len(wallpapers) == 0 {
		log.Fatalf("No wallpapers found in the specified directory")
	}

	manager := wallpaper.NewWallpaperManager(wallpapers, config.Order)

	// Setup signal handling for manual trigger
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGUSR1)

	// Setup directory watcher
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		log.Fatalf("Error creating watcher: %v", err)
	}
	defer watcher.Close()

	// Start watching the directory
	go watchDirectory(watcher, config.Directory, config.Recursive, manager)

	ticker := time.NewTicker(config.Interval)
	defer ticker.Stop()

	log.Printf("Swayscape started. Monitoring %d wallpapers in %s", len(wallpapers), config.Directory)
	log.Printf("Changing wallpaper every %v", config.Interval)

	for {
		select {
		case <-ticker.C:
			if err := changeWallpaper(manager, config.Command); err != nil {
				log.Printf("Error changing wallpaper: %v", err)
			}
		case <-sigChan:
			log.Println("Manual trigger received")
			if err := changeWallpaper(manager, config.Command); err != nil {
				log.Printf("Error changing wallpaper: %v", err)
			}
		}
	}
}

func loadConfig() Config {
	configPath := flag.String("config", "config.yaml", "Path to configuration file")
	flag.Parse()

	config := Config{
		Directory: "",
		Recursive: false,
		Interval:  5 * time.Minute,
		Order:     "random",
		Command:   "swww img {{img}}",
	}

	// Load configuration from file
	data, err := os.ReadFile(*configPath)
	if err == nil {
		err = yaml.Unmarshal(data, &config)
		if err != nil {
			log.Printf("Error parsing configuration file: %v", err)
		}
	} else {
		log.Printf("Error reading configuration file: %v", err)
	}

	// Override with command-line flags
	flag.StringVar(&config.Directory, "dir", config.Directory, "Directory containing wallpapers")
	flag.BoolVar(&config.Recursive, "recursive", config.Recursive, "Scan directory recursively")
	flag.DurationVar(&config.Interval, "interval", config.Interval, "Interval between wallpaper changes (e.g., 30s, 5m, 1h)")
	flag.StringVar(&config.Order, "order", config.Order, "Wallpaper order (alphabetical or random)")
	flag.StringVar(&config.Command, "command", config.Command, "Command to change wallpaper. Use {{img}} as a placeholder for the wallpaper path.")

	flag.Parse()

	if config.Directory == "" {
		log.Fatal("Directory must be specified either in config file or as a command-line argument")
	}

	if config.Order != "alphabetical" && config.Order != "random" {
		log.Fatalf("Invalid order specified: %s. Must be either 'alphabetical' or 'random'", config.Order)
	}

	// Expand tilde in directory path
	expandedDir, err := homedir.Expand(config.Directory)
	if err != nil {
		log.Fatalf("Error expanding directory path: %v", err)
	}
	config.Directory = expandedDir

	return config
}

func scanDirectory(dir string, recursive bool) ([]string, error) {
	expandedDir, err := homedir.Expand(dir)
	if err != nil {
		return nil, fmt.Errorf("error expanding path: %v", err)
	}

	var wallpapers []string
	err = filepath.Walk(expandedDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() && isImageFile(path) {
			wallpapers = append(wallpapers, path)
		}
		if !recursive && path != expandedDir {
			return filepath.SkipDir
		}
		return nil
	})
	return wallpapers, err
}

func isImageFile(path string) bool {
	ext := filepath.Ext(path)
	switch ext {
	case ".jpg", ".jpeg", ".png", ".gif", ".bmp":
		return true
	}
	return false
}

func changeWallpaper(manager *wallpaper.WallpaperManager, commandTemplate string) error {
	wallpaper := manager.NextWallpaper()

	// Replace the {{img}} placeholder with the actual wallpaper path
	command := strings.ReplaceAll(commandTemplate, "{{img}}", wallpaper)

	cmd := exec.Command("sh", "-c", command)
	output, err := cmd.CombinedOutput()
	if err != nil {
		return fmt.Errorf("failed to change wallpaper: %v, output: %s", err, string(output))
	}
	log.Printf("Changed wallpaper to: %s", wallpaper)
	log.Printf("Executed command: %s", command)
	return nil
}

func watchDirectory(watcher *fsnotify.Watcher, dir string, recursive bool, manager *wallpaper.WallpaperManager) {
	expandedDir, err := homedir.Expand(dir)
	if err != nil {
		log.Printf("Error expanding directory path: %v", err)
		return
	}

	if recursive {
		err := filepath.Walk(expandedDir, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if info.IsDir() {
				return watcher.Add(path)
			}
			return nil
		})
		if err != nil {
			log.Printf("Error walking directory: %v", err)
		}
	} else {
		err := watcher.Add(expandedDir)
		if err != nil {
			log.Printf("Error adding directory to watcher: %v", err)
		}
	}

	for {
		select {
		case event, ok := <-watcher.Events:
			if !ok {
				return
			}
			handleFileEvent(event, manager)
		case err, ok := <-watcher.Errors:
			if !ok {
				return
			}
			log.Printf("Watcher error: %v", err)
		}
	}
}

func handleFileEvent(event fsnotify.Event, manager *wallpaper.WallpaperManager) {
	switch {
	case event.Op&fsnotify.Create == fsnotify.Create:
		if isImageFile(event.Name) {
			log.Printf("New wallpaper added: %s", event.Name)
			manager.AddWallpaper(event.Name)
		}
	case event.Op&fsnotify.Remove == fsnotify.Remove:
		if isImageFile(event.Name) {
			log.Printf("Wallpaper removed: %s", event.Name)
			manager.RemoveWallpaper(event.Name)
		}
	case event.Op&fsnotify.Rename == fsnotify.Rename:
		if isImageFile(event.Name) {
			log.Printf("Wallpaper renamed: %s", event.Name)
			manager.RemoveWallpaper(event.Name)
		}
	}
}
