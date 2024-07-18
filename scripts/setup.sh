#!/usr/bin/env bash

################################################################################
### Baseline
################################################################################

# Full path of the current script
THIS=$(readlink -f "${BASH_SOURCE[0]:-${(%):-%x}}" 2>/dev/null||echo $0)
# The directory where current script resides
DIR=$(dirname "${THIS}")
ROOT_DIR=$(dirname "${DIR}../")

source $ROOT_DIR/shell/util.sh

if [[ ! -e $HOME/.config ]] ; then
    mkdir -p $HOME/.config
fi

################################################################################

################################################################################
### Starship shell prompt
################################################################################

ensure_symlink $ROOT_DIR/starship/starship.toml $HOME/.config/starship.toml

################################################################################
### Scripts
################################################################################

if [[ "$OSTYPE" == "darwin"* ]]; then
    ensure_symlink $ROOT_DIR/bin/osx $HOME/bin
else
    ensure_symlink $ROOT_DIR/bin/linux $HOME/bin
fi

################################################################################
### Terminals
################################################################################

ensure_symlink $ROOT_DIR/kitty $HOME/.config/kitty
ensure_symlink $ROOT_DIR/wezterm $HOME/.config/wezterm

################################################################################
### Shells
################################################################################

ensure_symlink $ROOT_DIR/shell $HOME/.shell

ensure_symlink $ROOT_DIR/bash/.bash.mine $HOME/.bash.mine
ensure_symlink $ROOT_DIR/bash/.bash_profile $HOME/.bash_profile
ensure_symlink $ROOT_DIR/bash/.bashrc $HOME/.bashrc
ensure_symlink $ROOT_DIR/bash/.bash_complete_alias $HOME/.bash_complete_alias

ensure_symlink $ROOT_DIR/zsh/.zshrc $HOME/.zshrc
ensure_symlink $ROOT_DIR/zsh/.zsh.mine $HOME/.zsh.mine

ensure_symlink $ROOT_DIR/shell/.inputrc $HOME/.inputrc

################################################################################
### Git
################################################################################

ensure_symlink $ROOT_DIR/git/.gitconfig $HOME/.gitconfig
ensure_symlink $ROOT_DIR/git/.gitignore_global $HOME/.gitignore_global

################################################################################
### Vim
################################################################################

mkdir -p $HOME/.vim/autoload
ensure_symlink $ROOT_DIR/vim/autoload/plug.vim $HOME/.vim/autoload/plug.vim
ensure_symlink $ROOT_DIR/vim/vimrc $HOME/.vim/vimrc
# Neovim
ensure_symlink $ROOT_DIR/nvim $HOME/.config/nvim

################################################################################
### Tools
################################################################################

ensure_symlink $ROOT_DIR/ripgrep/.ripgreprc $HOME/.ripgreprc

mkdir -p $HOME/.tmux/plugins
git_clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
ensure_symlink $ROOT_DIR/tmux/.tmux.conf $HOME/.tmux.conf

ensure_symlink $ROOT_DIR/k9s $HOME/.config/k9s

################################################################################
### Other apps
################################################################################

################################################################################
### Version managers
################################################################################

# Volta nodejs version manager
if [ ! -d "$HOME/.volta" ]; then
    curl https://get.volta.sh | bash -s -- --skip-setup
fi

if ! is_command mise; then
  # Mise dev tool manager
  curl https://mise.run | sh
fi

################################################################################
### Applications (.desktop files)
################################################################################
mkdir -p $HOME/.local/share/applications &&\
cp -r $ROOT_DIR/applications/*.desktop $HOME/.local/share/applications
