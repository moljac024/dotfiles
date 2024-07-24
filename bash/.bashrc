#!/usr/bin/env bash

if [[ -f $HOME/.shell/util.sh ]]; then
  source $HOME/.shell/util.sh

  if is_command fish; then
    exec fish -l
  fi
fi

if [[ -f $HOME/.bash.mine ]]; then
    source $HOME/.bash.mine
fi
