# Ensure file is sourced only once
set -q __fish_env_loaded; and return; set -g __fish_env_loaded

set -gx DOTFILES $HOME/dotfiles

source $DOTFILES/shell/fish/lib
source $DOTFILES/shell/fish/common
source $DOTFILES/shell/fish/prompt

# Set sourced to true
