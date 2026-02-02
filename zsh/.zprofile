# vim: filetype=zsh

export DOTFILES=$HOME/dotfiles

################################################################################
### Source common shell setup
################################################################################

if [[ -f $DOTFILES/shell/common.sh ]]; then
  source $DOTFILES/shell/common.sh
fi
