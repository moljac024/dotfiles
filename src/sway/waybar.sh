#!/usr/bin/env sh

# Terminate already running bar instances
killall -q waybar

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do sleep 1; done

# Launch main
exec waybar -c ~/.config/sway/waybar.json -s ~/.config/sway/waybar.css
