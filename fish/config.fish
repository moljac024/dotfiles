set -gx DOTFILES $HOME/dotfiles

# Surpress fish greeting
set -U fish_greeting

source $DOTFILES/shell/fish/lib
source $DOTFILES/shell/fish/common
source $DOTFILES/shell/fish/prompt

if not test -f "$DOTFILES/shell/fish/local/kubectl-completions"
  kubectl completion fish > "$DOTFILES/shell/fish/local/kubectl-completions"
end

# Local shell overrides, this should be last
source_dir "$DOTFILES/shell/fish/local"
