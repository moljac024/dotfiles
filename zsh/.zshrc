# vim: filetype=zsh

################################################################################
### Source common shell setup
################################################################################

if [[ -f $DOTFILES/shell/common.sh ]]; then
  source $DOTFILES/shell/common.sh
fi

################################################################################
### Source interactive zsh setup
################################################################################

if [[ -f $HOME/.zsh.mine ]]; then
  source $HOME/.zsh.mine
fi
