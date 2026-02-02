# Antidote
export ANTIDOTE_DIR=$HOME/.antidote
if [ ! -e $ANTIDOTE_DIR ]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

source $ANTIDOTE_DIR/antidote.zsh
antidote load

if [[ -f $HOME/.zsh.mine ]]; then
  source $HOME/.zsh.mine
fi
