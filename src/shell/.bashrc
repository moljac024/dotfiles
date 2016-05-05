if [[ "$OSTYPE" == "darwin"* ]]; then
    # Enable bash completion on OS X
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        source `brew --prefix`/etc/bash_completion
    fi

    # Enable rbenv shims and autocompletion (per Homebrew's caveat after installing rbenv and ruby-build)
    if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
fi

# Oh-my-git prompt
source $HOME/.oh-my-git/prompt.sh
# Virtualenv prompt play nice with oh-my-git
VIRTUAL_ENV_DISABLE_PROMPT=true
function omg_prompt_callback() {
    if [ -n "${VIRTUAL_ENV}" ]; then
        echo "\e[0;31m(`basename ${VIRTUAL_ENV}`)\e[0m "
    fi
}

# Add custom paths.
if [ -f $HOME/.shell_paths ]; then
    source $HOME/.shell_paths
fi

# Source custom bash config
if [ -f $HOME/.bash.mine ]; then
  source $HOME/.bash.mine
fi

