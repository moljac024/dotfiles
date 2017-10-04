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

# Link the shell configs
link src/shell/.bash.paths $HOME/.bash.paths
link src/shell/.bash_profile $HOME/.bash_profile
link src/shell/.bash.mine $HOME/.bash.mine

cat >> $HOME/.bashrc <<EOF
# Source custom bash config
if [ -f $HOME/.bash.mine ]; then
  source $HOME/.bash.mine
fi
EOF


# Link the git config
link src/git/.gitconfig $HOME/.gitconfig
link src/git/.gitignore_global $HOME/.gitignore_global

# Link tmux config
link src/tmux/.tmux.conf $HOME/.tmux.conf

# Link the tmuxinator bash completion script
mkdir -p $HOME/.bash_completions
link src/tmux/tmuxinator-completion.bash $HOME/.bash_completions/tmuxinator

# Link spacemacs
link src/misc/.spacemacs $HOME/.spacemacs

# Link vim
mkdir -p $HOME/.vim/autoload
link src/vim/autoload/plug.vim $HOME/.vim/autoload/plug.vim
link src/vim/vimrc $HOME/.vim/vimrc
link src/vim/vimrc $HOME/.vimrc

# i3 window manager
mkdir -p $HOME/.config
link src/i3 $HOME/.config/i3


# Install rbenv and rbenv-build
git_clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
mkdir -p $HOME/.rbenv/plugins
git_clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build

# Install pyenv
git_clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

# Install oh-my-git
git_clone https://github.com/arialdomartini/oh-my-git.git $HOME/.oh-my-git
