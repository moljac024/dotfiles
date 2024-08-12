# Swayscape

Swayscape is a wallpaper management utility for the Sway window manager. It automatically changes wallpapers at specified intervals and watches the wallpaper directory for changes.

## Features

- Automatic wallpaper rotation at specified intervals
- Support for recursive directory scanning
- Dynamic updating of wallpaper list when files are added or removed
- Configurable wallpaper changing command
- Manual trigger for changing wallpapers
- Alphabetical or random wallpaper ordering

## Installation

1. Ensure you have Go 1.16 or later installed on your system.
2. Clone the repository:
   ```
   git clone https://github.com/yourusername/swayscape.git
   ```
3. Change to the project directory:
   ```
   cd swayscape
   ```
4. Build the project:
   ```
   go build -o swayscape cmd/swayscape/main.go
   ```

## Usage

1. Edit the `config.yaml` file to set your preferred options.
2. Run Swayscape:
   ```
   ./swayscape
   ```
## Configuration

Edit the `config.yaml` file to set default options:

- `directory`: Path to your wallpaper directory
- `recursive`: Whether to scan the directory recursively (true/false)
- `interval`: Time between wallpaper changes (e.g., "5m" for 5 minutes)
- `order`: Wallpaper ordering ("alphabetical" or "random")
- `command`: Command to change wallpaper (use {{img}} as a placeholder for the wallpaper path)

## Configuration

Edit the `config.yaml` file to set default options:

- `directory`: Path to your wallpaper directory
- `recursive`: Whether to scan the directory recursively (true/false)
- `interval`: Time between wallpaper changes (e.g., "30s" for 30 seconds, "5m" for 5 minutes, "1h" for 1 hour)
- `order`: Wallpaper ordering ("alphabetical" or "random")
- `command`: Command to change wallpaper (use {{img}} as a placeholder for the wallpaper path)

### Command-line Options

- `-config`: Path to configuration file (default: "config.yaml")
- `-dir`: Directory containing wallpapers (overrides config file)
- `-recursive`: Scan directory recursively (overrides config file)
- `-interval`: Interval between wallpaper changes (overrides config file, e.g., 30s, 5m, 1h)
- `-order`: Wallpaper order, "alphabetical" or "random" (overrides config file)
- `-command`: Command to change wallpaper (overrides config file)

Example:
```
./swayscape -dir ~/Wallpapers -interval 10m -order alphabetical -command "swww img {{img}} --transition-fps 60"
```

## Manual Trigger

To manually trigger a wallpaper change, send the SIGUSR1 signal to the Swayscape process:
```
killall -SIGUSR1 swayscape
```

## License

[MIT License](https://opensource.org/licenses/MIT)
