set -gx DOTFILES $HOME/dotfiles

if test -f $DOTFILES/shell/common.fish
  source $DOTFILES/shell/common.fish
end

if test -f $DOTFILES/shell/prompt.fish
  source $DOTFILES/shell/prompt.fish
end
