#!/bin/bash

# Raise inotify limit - This is safe as these dotfiles are meant to be used on
# a personal ubuntu install. I wouldn't do this on a server that is publically
# available
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
