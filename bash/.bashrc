# vim: filetype=bash

################################################################################
### Base
################################################################################

# Source global definitions
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

export DOTFILES="$HOME/dotfiles"
source "$DOTFILES/shell/sh/lib"
source "$DOTFILES/shell/sh/common"
source "$DOTFILES/shell/sh/prompt"

################################################################################
### Completions
################################################################################

# Bash completions
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

if [ -d $HOME/.bash_completions ]; then
  source_dir $HOME/.bash_completions
fi

if [ -d /opt/homebrew/etc/bash_completion.d ]; then
  source_dir /opt/homebrew/etc/bash_completion.d
fi

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -e "$HOME/.fzf-extras/fzf-extras.sh" ] \
  && source "$HOME/.fzf-extras/fzf-extras.sh"

################################################################################
### Other
################################################################################

if [[ ! -f "$DOTFILES/bash/local/kubectl-completions" ]]; then
  kubectl completion bash > "$DOTFILES/bash/local/kubectl-completions"
fi

################################################################################
### Local
################################################################################

source_dir "$DOTFILES/bash/local"
source_dir "$DOTFILES/shell/sh/local"
