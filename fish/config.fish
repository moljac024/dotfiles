set -gx DOTFILES $HOME/dotfiles

# Surpress fish greeting
set -U fish_greeting

source $DOTFILES/shell/fish/lib
source $DOTFILES/shell/fish/common
source $DOTFILES/shell/fish/prompt

# NOTE: This tends to slow down shell startup on systems where kubectl is slow
# to run. Also fish comes with kubectl completions already so this is not
# needed.

# if not test -f "$DOTFILES/shell/fish/local/kubectl-completions"
#   kubectl completion fish > "$DOTFILES/shell/fish/local/kubectl-completions"
# end

# Local shell overrides, this should be last
source_dir "$DOTFILES/shell/fish/local"
