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

# --------------------------------------------------------------
# Bash
# --------------------------------------------------------------
link src/shell/.bash.paths $HOME/.bash.paths
link src/shell/.bash_profile $HOME/.bash_profile
link src/shell/.bash.mine $HOME/.bash.mine

cat >> $HOME/.bashrc <<EOF
# Source custom bash config
if [ -f $HOME/.bash.mine ]; then
  source $HOME/.bash.mine
fi
EOF
# ______________________________________________________________


# --------------------------------------------------------------
# Git
# --------------------------------------------------------------
link src/git/.gitconfig $HOME/.gitconfig
link src/git/.gitignore_global $HOME/.gitignore_global
# ______________________________________________________________

# --------------------------------------------------------------
# Vim
# --------------------------------------------------------------
mkdir -p $HOME/.vim/autoload
link src/vim/autoload/plug.vim $HOME/.vim/autoload/plug.vim
link src/vim/vimrc $HOME/.vim/vimrc
# ______________________________________________________________

# --------------------------------------------------------------
# Ripgrep
link src/.ripgreprc $HOME/.ripgreprc
# ______________________________________________________________

# --------------------------------------------------------------
# Tmux
# --------------------------------------------------------------
link src/tmux/.tmux.conf $HOME/.tmux.conf
# ______________________________________________________________

# --------------------------------------------------------------
# Tmuxinator
# --------------------------------------------------------------
mkdir -p $HOME/.bash_completions
link src/tmux/tmuxinator-completion.bash $HOME/.bash_completions/tmuxinator
# ______________________________________________________________

# --------------------------------------------------------------
# i3 window manager
# --------------------------------------------------------------
mkdir -p $HOME/.config
link src/i3 $HOME/.config/i3
# ______________________________________________________________

# --------------------------------------------------------------
# XMonad
# --------------------------------------------------------------
link src/xmonad $HOME/.xmonad
# ______________________________________________________________

# --------------------------------------------------------------
# Asdf version manager
# --------------------------------------------------------------
git_clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.1
# ______________________________________________________________

# --------------------------------------------------------------
# Oh-my-git
# --------------------------------------------------------------
git_clone https://github.com/arialdomartini/oh-my-git.git $HOME/.oh-my-git
# ______________________________________________________________
