set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR vim

if test -e $HOME/.fzf
  set -x PATH $PATH $HOME/.fzf/bin
  set -gx FZF_DEFAULT_COMMAND rg --files
  set -gx FZF_FIND_FILE_COMMAND rg --files
end
