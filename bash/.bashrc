# vim: filetype=bash

export DOTFILES=$HOME/dotfiles
source $DOTFILES/shell/lib.sh

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
### Source common shell setup
################################################################################

if [[ -f $DOTFILES/shell/common.sh ]]; then
  source $DOTFILES/shell/common.sh
fi

################################################################################
### Prompt
################################################################################

if [[ -f $DOTFILES/shell/prompt.sh ]]; then
  source $DOTFILES/shell/prompt.sh
fi

################################################################################
### Other
################################################################################

# Complete aliases, need to run this after all setup
if [[ -f "$DOTFILES/bash/bash_complete_alias" ]]; then
  source "$DOTFILES/bash/bash_complete_alias"
  # Complete all aliases
  complete -F _complete_alias "${!BASH_ALIASES[@]}"
fi
