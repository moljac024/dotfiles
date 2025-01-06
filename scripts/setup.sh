#!/usr/bin/env bash
set -euo pipefail # Shell strict mode

################################################################################
### Baseline
################################################################################

THIS=$(readlink -f "${BASH_SOURCE[0]:-${(%):-%x}}" 2>/dev/null||echo $0) # Full path of the current script
DIR=$(dirname "${THIS}") # The directory where current script resides
ROOT_DIR=$(dirname "${DIR}../")

source $ROOT_DIR/shell/util.sh

if [[ ! -e $HOME/.config ]] ; then
    mkdir -p $HOME/.config
fi

################################################################################
### Scripts
################################################################################

if [[ "$OSTYPE" == "darwin"* ]]; then
    ensure_symlink $ROOT_DIR/bin/osx $HOME/bin
else
    ensure_symlink $ROOT_DIR/bin/linux $HOME/bin
fi

################################################################################
### Terminals
################################################################################

# Foot
ensure_symlink $ROOT_DIR/foot $HOME/.config/foot

# Kitty
ensure_symlink $ROOT_DIR/kitty $HOME/.config/kitty

# Wezterm
ensure_symlink $ROOT_DIR/wezterm $HOME/.config/wezterm

# Konsole
mkdir -p $HOME/.local/share
ensure_symlink $ROOT_DIR/konsole/konsolerc $HOME/.config/konsolerc
ensure_symlink $ROOT_DIR/konsole/local $HOME/.local/share/konsole

################################################################################
### Shells
################################################################################

# Starship shell prompt
ensure_symlink $ROOT_DIR/starship/starship.toml $HOME/.config/starship.toml

# Common shell scripts, utilities and config
ensure_symlink $ROOT_DIR/shell $HOME/.shell

# Bash shell
ensure_symlink $ROOT_DIR/bash/.bash.mine $HOME/.bash.mine
ensure_symlink $ROOT_DIR/bash/.bash_profile $HOME/.bash_profile
ensure_symlink $ROOT_DIR/bash/.bashrc $HOME/.bashrc
ensure_symlink $ROOT_DIR/bash/.bash_complete_alias $HOME/.bash_complete_alias

# Zsh shell
ensure_symlink $ROOT_DIR/zsh/.zshrc $HOME/.zshrc
ensure_symlink $ROOT_DIR/zsh/.zsh_plugins.txt $HOME/.zsh_plugins.txt

# Fish shell
ensure_symlink $ROOT_DIR/fish $HOME/.config/fish

# Other shell related configs
ensure_symlink $ROOT_DIR/shell/.inputrc $HOME/.inputrc

################################################################################
### Dev
################################################################################

# Git
ensure_symlink $ROOT_DIR/git/.gitconfig $HOME/.gitconfig
ensure_symlink $ROOT_DIR/git/.gitignore_global $HOME/.gitignore_global

# SSH
ensure_symlink $ROOT_DIR/ssh $HOME/.ssh

# K8s
ensure_symlink $ROOT_DIR/kube $HOME/.kube

# Vim
mkdir -p $HOME/.vim/autoload
ensure_symlink $ROOT_DIR/vim/autoload/plug.vim $HOME/.vim/autoload/plug.vim
ensure_symlink $ROOT_DIR/vim/vimrc $HOME/.vim/vimrc

# Neovim
ensure_symlink $ROOT_DIR/nvim $HOME/.config/nvim

# Helix
ensure_symlink $ROOT_DIR/helix $HOME/.config/helix

# Volta nodejs version manager
if [ ! -d "$HOME/.volta" ]; then
    curl https://get.volta.sh | bash -s -- --skip-setup
fi

# Mise dev tool manager
if ! is_command mise; then
  curl https://mise.run | sh
fi
ensure_symlink $ROOT_DIR/mise $HOME/.config/mise

################################################################################
### CLI Tools
################################################################################

# Ripgrep
ensure_symlink $ROOT_DIR/ripgrep/.ripgreprc $HOME/.ripgreprc

# Tmux
mkdir -p $HOME/.tmux/plugins
git_clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
ensure_symlink $ROOT_DIR/tmux/.tmux.conf $HOME/.tmux.conf

# Zellij
ensure_symlink $ROOT_DIR/zellij $HOME/.config/zellij

# K9s
ensure_symlink $ROOT_DIR/k9s $HOME/.config/k9s

# Midnight commander
mkdir -p $HOME/.local/share/mc
ensure_symlink $ROOT_DIR/mc $HOME/.config/mc
ensure_symlink $ROOT_DIR/mc/skins $HOME/.local/share/mc/skins

################################################################################
### Desktop apps
################################################################################

# Mpv
ensure_symlink $ROOT_DIR/mpv $HOME/.config/mpv

# Kando
mkdir -p $HOME/.config/kando
ensure_symlink $ROOT_DIR/kando/config.json $HOME/.config/kando/config.json
ensure_symlink $ROOT_DIR/kando/menus.json $HOME/.config/kando/menus.json

mkdir -p $HOME/.var/app/menu.kando.Kando/config/kando/
ensure_symlink $ROOT_DIR/kando/config.json $HOME/.var/app/menu.kando.Kando/config/kando/config.json
ensure_symlink $ROOT_DIR/kando/menus.json $HOME/.var/app/menu.kando.Kando/config/kando/menus.json

################################################################################
### DEs and WMs
################################################################################

# Fuzzel
ensure_symlink $ROOT_DIR/fuzzel $HOME/.config/fuzzel

# Rofi
mkdir -p $HOME/.local/share/rofi
ensure_symlink $ROOT_DIR/rofi/themes $HOME/.local/share/rofi/themes
ensure_symlink $ROOT_DIR/rofi $HOME/.config/rofi

# Wofi
ensure_symlink $ROOT_DIR/wofi $HOME/.config/wofi

# Mako
ensure_symlink $ROOT_DIR/mako $HOME/.config/mako

# Dunst
ensure_symlink $ROOT_DIR/dunst $HOME/.config/dunst

# Wlogout
ensure_symlink $ROOT_DIR/wlogout $HOME/.config/wlogout

# Waybar
ensure_symlink $ROOT_DIR/waybar $HOME/.config/waybar

# Sway
ensure_symlink $ROOT_DIR/swaylock $HOME/.config/swaylock
ensure_symlink $ROOT_DIR/sway $HOME/.config/sway

# Hyprland
ensure_symlink $ROOT_DIR/hypr $HOME/.config/hypr

################################################################################
### Applications (.desktop files)
################################################################################

mkdir -p $HOME/.local/share/applications &&\
cp -r $ROOT_DIR/applications/*.desktop $HOME/.local/share/applications

################################################################################
### Other
################################################################################

mkdir -p $HOME/.local/share/nautilus/
ensure_symlink $ROOT_DIR/nautilus/scripts $HOME/.local/share/nautilus/scripts
ensure_symlink $ROOT_DIR/nautilus/actions $HOME/.local/share/nautilus/actions
