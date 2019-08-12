################################################################################
### Environment
################################################################################

set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR vim

set -x PATH $HOME/bin $PATH

if test -d /home/linuxbrew/.linuxbrew/bin
    set -x PATH $PATH /home/linuxbrew/.linuxbrew/bin
end

if test -d $HOME/.cargo/bin
    set -x PATH $PATH $HOME/.cargo/bin
end

################################################################################
### Aliases
################################################################################

alias back='cd $dirprev[-1]'
alias gta='gitk --all'

################################################################################
### Other
################################################################################

# FZF
if test -d $HOME/.fzf
    set -x PATH $HOME/.fzf/bin $PATH
end

if type -q fzf
    set -gx FZF_DEFAULT_COMMAND rg --files
    set -gx FZF_FIND_FILE_COMMAND rg --files
    set -gx FZF_OPEN_COMMAND rg --files
end

# FZF git goodies
if type -q fizzygit
    fizzygit
end
