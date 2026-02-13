# vim: filetype=zsh

################################################################################
### Base
################################################################################

# Important that this comes first
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

export DOTFILES="$HOME/dotfiles"
source "$DOTFILES/shell/sh/lib"
source "$DOTFILES/shell/sh/common"
source "$DOTFILES/shell/sh/prompt"

################################################################################
### Plugins
################################################################################

export ANTIDOTE_DIR=$HOME/.antidote
if [ ! -e $ANTIDOTE_DIR ]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

source $ANTIDOTE_DIR/antidote.zsh
antidote load

################################################################################
#### Zsh config
################################################################################

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e

# Completion
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# This makes Tab and ShiftTab move the selection in the menu right and left, respectively, instead of exiting the menu:
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]"         reverse-menu-complete

# This makes Tab and ShiftTab, when pressed on the command line, enter the menu instead of inserting a completion:
bindkey              '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select

# This makes ← and → always move the cursor on the command line, even when you are in the menu:
# bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
# bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char

# This makes Enter always submit the command line, even when you are in the menu:
# bindkey -M menuselect '^M' .accept-line

# To suppress autocompletion until a minimum number of characters have been typed:
zstyle ':autocomplete:*' min-input 3

################################################################################
### Other
################################################################################

if [[ ! -f "$DOTFILES/zsh/local/kubectl-completions" ]]; then
  kubectl completion zsh > "$DOTFILES/zsh/local/kubectl-completions"
fi

################################################################################
### Local
################################################################################

source_dir "$DOTFILES/zsh/local"
source_dir "$DOTFILES/shell/sh/local"
