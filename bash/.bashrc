# vim: filetype=bash

export DOTFILES=$HOME/dotfiles

################################################################################
### Source common shell setup
################################################################################

if [[ -f $DOTFILES/shell/common.sh ]]; then
  source $DOTFILES/shell/common.sh
fi

################################################################################
### If not running interactively, stop here
################################################################################

[[ $- != *i* ]] && return

################################################################################
### Prompt
################################################################################

if [[ -f $DOTFILES/shell/prompt.sh ]]; then
  source $DOTFILES/shell/prompt.sh
fi

################################################################################
### Other
################################################################################

# Bash completions
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
    if [ -d $HOME/.bash_completions ]; then
        for f in $HOME/.bash_completions/*; do
            if [ -f $f ]; then
                source $f
            fi
        done
        unset f
    fi

    if [ -d /opt/homebrew/etc/bash_completion.d ]; then
        for f in /opt/homebrew/etc/bash_completion.d/*; do
            if [ -f $f ]; then
                source $f
            fi
        done
        unset f
    fi

    if [[ -f "$DOTFILES/bash/bash_complete_alias" ]]; then
        source "$DOTFILES/bash/bash_complete_alias"
        # Complete all aliases
        complete -F _complete_alias "${!BASH_ALIASES[@]}"
    fi
fi

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -e "$HOME/.fzf-extras/fzf-extras.sh" ] \
  && source "$HOME/.fzf-extras/fzf-extras.sh"

if is_command kubectl; then
    source <(kubectl completion bash)
    complete -o default -F __start_kubectl k
fi

# Direnv
if is_command direnv; then
    eval "$(direnv hook bash)"
fi
