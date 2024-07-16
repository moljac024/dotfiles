# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

if [[ -f $HOME/.zsh.mine ]]; then
  . $HOME/.zsh.mine
fi
