# Set up env
set -l here (path dirname (status --current-filename))
source $here/env.fish

# Surpress fish greeting
set -U fish_greeting

# Local shell overrides, this should be last
source_dir "$DOTFILES/shell/fish/local"
