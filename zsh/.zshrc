if [[ -f $HOME/.shell/util.sh ]]; then
  source $HOME/.shell/util.sh

  if is_command fish; then
    exec fish -l
  fi
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

if [[ -f $HOME/.shell/common.sh ]]; then
  source $HOME/.shell/common.sh
fi

# Antidote
export ANTIDOTE_DIR=$HOME/.antidote
if [ ! -e $ANTIDOTE_DIR ]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

source $ANTIDOTE_DIR/antidote.zsh
antidote load
