set -gx DOTFILES $HOME/dotfiles

source $DOTFILES/shell/fish/lib
source $DOTFILES/shell/fish/common
source $DOTFILES/shell/fish/prompt

# Local shell overrides, this should be last
source_dir "$DOTFILES/shell/fish/local"
