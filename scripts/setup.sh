#!/usr/bin/env bash

################################################################################
### Baseline
################################################################################

is_command() {
  command -v "$1" >/dev/null 2>&1
}

ensure_symlink () {
  local original=$1

  if [ ! -e "$original" ]; then
    return
  fi

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

ensure_symlink starship/starship.toml $HOME/.config/starship.toml

################################################################################
### Scripts
################################################################################

if [[ "$OSTYPE" == "darwin"* ]]; then
    ensure_symlink bin/osx $HOME/bin
else
    ensure_symlink bin/linux $HOME/bin
fi

################################################################################
### Terminals
################################################################################

ensure_symlink kitty $HOME/.config/kitty
ensure_symlink wezterm $HOME/.config/wezterm

################################################################################
### Shells
################################################################################

mkdir -p $HOME/.shell
ensure_symlink shell/common.sh $HOME/.shell/common.sh

ensure_symlink bash/.bash.mine $HOME/.bash.mine
ensure_symlink bash/.bash_profile $HOME/.bash_profile
ensure_symlink bash/.bashrc $HOME/.bashrc
ensure_symlink bash/.bash_complete_alias $HOME/.bash_complete_alias

ensure_symlink zsh/.zshrc $HOME/.zshrc
ensure_symlink zsh/.zsh.mine $HOME/.zsh.mine

ensure_symlink shell/.inputrc $HOME/.inputrc

################################################################################
### Git
################################################################################

ensure_symlink git/.gitconfig $HOME/.gitconfig
ensure_symlink git/.gitignore_global $HOME/.gitignore_global

################################################################################
### Vim
################################################################################

mkdir -p $HOME/.vim/autoload
ensure_symlink vim/autoload/plug.vim $HOME/.vim/autoload/plug.vim
ensure_symlink vim/vimrc $HOME/.vim/vimrc
# Neovim
ensure_symlink nvim $HOME/.config/nvim

################################################################################
### Tools
################################################################################

ensure_symlink ripgrep/.ripgreprc $HOME/.ripgreprc

mkdir -p $HOME/.tmux/plugins
git_clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
ensure_symlink tmux/.tmux.conf $HOME/.tmux.conf

ensure_symlink k9s $HOME/.config/k9s

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
cp -r applications/*.desktop $HOME/.local/share/applications
