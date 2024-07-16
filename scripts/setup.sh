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

link starship/starship.toml $HOME/.config/starship.toml

################################################################################
### Scripts
################################################################################

if [[ "$OSTYPE" == "darwin"* ]]; then
    link bin/osx $HOME/bin
else
    link bin/linux $HOME/bin
fi

################################################################################
### Terminals
################################################################################

link kitty $HOME/.config/kitty
link wezterm $HOME/.config/wezterm

################################################################################
### Shells
################################################################################

mkdir -p $HOME/.shell
link shell/common $HOME/.shell/common

link bash/.bash.mine $HOME/.bash.mine
link bash/.bash_profile $HOME/.bash_profile
link bash/.bashrc $HOME/.bashrc
link bash/.complete_alias $HOME/.bash_complete_alias

link zsh/.zshrc $HOME/.zshrc
link zsh/.zsh.mine $HOME/.zsh.mine

link shell/.inputrc $HOME/.inputrc

################################################################################
### Git
################################################################################

link git/.gitconfig $HOME/.gitconfig
link git/.gitignore_global $HOME/.gitignore_global

################################################################################
### Vim
################################################################################

mkdir -p $HOME/.vim/autoload
link vim/autoload/plug.vim $HOME/.vim/autoload/plug.vim
link vim/vimrc $HOME/.vim/vimrc
# Neovim
link nvim $HOME/.config/nvim

################################################################################
### Tools
################################################################################

link ripgrep/.ripgreprc $HOME/.ripgreprc

mkdir -p $HOME/.tmux/plugins
git_clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
link tmux/.tmux.conf $HOME/.tmux.conf

link k9s $HOME/.config/k9s

################################################################################
### Other apps
################################################################################

################################################################################
### Version managers
################################################################################

# Asdf
if [ ! -d "$HOME/.asdf" ]; then
    git_clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.14.0
fi

# Volta nodejs version manager
if [ ! -d "$HOME/.volta" ]; then
    curl https://get.volta.sh | bash -s -- --skip-setup
fi

################################################################################
### Applications (.desktop files)
################################################################################
mkdir -p $HOME/.local/share/applications &&\
cp -r applications/*.desktop $HOME/.local/share/applications
