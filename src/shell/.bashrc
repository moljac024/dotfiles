# Add custom paths.
if [ -f $HOME/.shell_paths ]; then
    source $HOME/.shell_paths
fi

# Source custom bash config
if [ -f $HOME/.bash.mine ]; then
  source $HOME/.bash.mine
fi

