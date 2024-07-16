# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/var/home/bojan/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

if [[ -f $HOME/.zsh.mine ]]; then
  . $HOME/.zsh.mine
fi
