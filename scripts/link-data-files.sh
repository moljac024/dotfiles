#!/bin/bash

cd $HOME
mkdir -p $HOME/.config
mkdir -p $HOME/.local
DATA_DIR=/mnt/data

LinkDataDir () {
  if [[ -d $1 && ! -L $1 ]]; then
    rmdir $1
    ln -s $DATA_DIR/$1 $1
    return 0
  fi

  if [[ ! -e $1 ]]; then
    ln -s $DATA_DIR/$1 $1
    return 0
  fi

  return 1
}

Link () {
  if [[ -e $1 && ! -e $2 ]]; then
      ln -s $1 $2
      return 0
  fi

  return 1
}

Link $DATA_DIR data
Link $DATA_DIR/Local/ssh .ssh
Link $DATA_DIR/Local/bin .local/bin

LinkDataDir Downloads
LinkDataDir Documents
LinkDataDir "My Documents"
LinkDataDir Music
LinkDataDir Pictures
LinkDataDir Projects
