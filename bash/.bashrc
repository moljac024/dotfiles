# vim: filetype=bash

export DOTFILES=$HOME/dotfiles

################################################################################
### Source common shell setup
################################################################################

if [ -f $DOTFILES/shell/common.sh ]; then
  source $DOTFILES/shell/common.sh
fi

################################################################################
### Source interactive bash setup
################################################################################

if [[ -f $HOME/.bash.mine ]]; then
    source $HOME/.bash.mine
fi
