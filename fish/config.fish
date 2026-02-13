set -gx DOTFILES $HOME/dotfiles

# Surpress fish greeting
set -U fish_greeting

if test -f $DOTFILES/shell/common.fish
  source $DOTFILES/shell/common.fish
end

if test -f $DOTFILES/shell/prompt.fish
  source $DOTFILES/shell/prompt.fish
end
