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

# Link the shell configs
link src/shell/.shell_paths $HOME/.shell_paths
link src/shell/.profile $HOME/.profile
link src/shell/.bash_profile $HOME/.bash_profile
link src/shell/.bashrc $HOME/.bashrc
link src/shell/.bash.mine $HOME/.bash.mine

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
