#!/usr/bin/env bash

################################################################################
### Baseline
################################################################################

link () {
    local original=$1
    local path=$2
    local original_fullpath="$(cd "$(dirname "$original")"; pwd)/$(basename "$original")"

    if [ -L "$path" ]; then
        rm "$path"
    fi

    if [ -e "$path" ]; then
        mv "$path" "$path.old"
    fi

    ln -s "$original_fullpath" "$path"
}

git_clone () {
    local repo=$1
    local location=$2
    local location_fullpath="$(cd "$(dirname "$location")"; pwd)/$(basename "$location")"

    if [ ! -d "$location_fullpath" ]; then
        git clone "$repo" "$location_fullpath"
    fi
}

if [[ ! -e $HOME/.config ]] ; then
    mkdir -p $HOME/.config
fi

################################################################################


################################################################################
### Starship shell prompt
################################################################################

link src/starship/starship.toml $HOME/.config/starship.toml

################################################################################
### Scripts
################################################################################

if [[ "$OSTYPE" == "darwin"* ]]; then
    link src/scripts/osx $HOME/bin
else
    link src/scripts/linux $HOME/bin
fi

################################################################################
### Terminals
################################################################################

link src/kitty $HOME/.config/kitty
link src/wezterm $HOME/.config/wezterm

################################################################################
### Shells
################################################################################

link src/bash/.bash.mine $HOME/.bash.mine
link src/bash/.bash_profile $HOME/.bash_profile
link src/bash/.bashrc $HOME/.bashrc
link src/bash/.inputrc $HOME/.inputrc
link src/bash/.complete_alias $HOME/.bash_complete_alias

link src/dircolors/solarized-ansi-light $HOME/.dir_colors

################################################################################
### Git
################################################################################

link src/git/.gitconfig $HOME/.gitconfig
link src/git/.gitignore_global $HOME/.gitignore_global

################################################################################
### Vim
################################################################################

mkdir -p $HOME/.vim/autoload
link src/vim/autoload/plug.vim $HOME/.vim/autoload/plug.vim
link src/vim/vimrc $HOME/.vim/vimrc
# Neovim
link src/nvim $HOME/.config/nvim

################################################################################
### Tools
################################################################################

link src/ripgrep/.ripgreprc $HOME/.ripgreprc
link src/tmux/.tmux.conf $HOME/.tmux.conf
link src/k9s $HOME/.config/k9s

################################################################################
### Version managers
################################################################################

# Asdf
if [ ! -d "$HOME/.asdf" ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
fi

# Volta nodejs version manager
if [ ! -d "$HOME/.volta" ]; then
    curl https://get.volta.sh | bash -s -- --skip-setup
fi
