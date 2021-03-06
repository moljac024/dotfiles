#!/usr/bin/env bash

################################################################################
### Baseline
################################################################################

link () {
    original=$1
    path=$2
    original_fullpath="$(cd "$(dirname "$original")"; pwd)/$(basename "$original")"

    if [ -L "$path" ]; then
        rm "$path"
    fi

    if [ -e "$path" ]; then
        mv "$path" "$path.old"
    fi

    ln -s "$original_fullpath" "$path"
}


git_clone () {
    repo=$1
    location=$2
    location_fullpath="$(cd "$(dirname "$location")"; pwd)/$(basename "$location")"

    if [ ! -d "$location_fullpath" ]; then
        git clone "$repo" "$location_fullpath"
    fi
}

if [[ ! -e $HOME/.config ]] ; then
    mkdir -p $HOME/.config
fi

################################################################################


################################################################################
### Scripts
################################################################################

if [[ "$OSTYPE" == "darwin"* ]]; then
    link src/scripts/osx $HOME/bin
else
    link src/scripts/linux $HOME/bin
fi

################################################################################


################################################################################
### Dircolors
################################################################################

link src/dircolors/solarized-ansi-light $HOME/.dir_colors

################################################################################


################################################################################
### Bash
################################################################################

link src/bash/.bash_profile $HOME/.bash_profile
link src/bash/.bashrc $HOME/.bashrc
link src/bash/.inputrc $HOME/.inputrc

git_clone https://github.com/Bash-it/bash-it.git $HOME/.bash_it

################################################################################


################################################################################
### Fish
################################################################################

mkdir -p $HOME/.config/fish/functions
link src/fish/config.fish $HOME/.config/fish/config.fish
link src/fish/fishfile $HOME/.config/fish/fishfile
curl https://git.io/fisher --create-dirs -sLo $HOME/.config/fish/functions/fisher.fish && fish -c fisher

################################################################################


################################################################################
### Git
################################################################################

link src/git/.gitconfig $HOME/.gitconfig
link src/git/.gitignore_global $HOME/.gitignore_global

################################################################################


################################################################################
### Vim
################################################################################

mkdir -p $HOME/.vim/autoload
link src/vim/autoload/plug.vim $HOME/.vim/autoload/plug.vim
link src/vim/vimrc $HOME/.vim/vimrc

################################################################################


################################################################################
### Ripgrep
################################################################################

link src/ripgrep/.ripgreprc $HOME/.ripgreprc

################################################################################


################################################################################
### Tmux
################################################################################

link src/tmux/.tmux.conf $HOME/.tmux.conf

################################################################################


################################################################################
### Tmuxinator bash completions
################################################################################

mkdir -p $HOME/.bash_completions
link src/tmux/tmuxinator-completion.bash $HOME/.bash_completions/tmuxinator

################################################################################


################################################################################
### Asdf version manager
################################################################################

git_clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.8

################################################################################

################################################################################
### Volta nodejs version manager
################################################################################

curl https://get.volta.sh | bash -s -- --skip-setup

################################################################################

