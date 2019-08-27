#!/usr/bin/env bash

################################################################################
### Environment
################################################################################

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR='vim'

# OS X Homebrew
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH=/usr/local/sbin:/usr/local/bin:$PATH
fi

# Linuxbrew
if [[ -d "/home/linuxbrew" ]]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
fi

# Locally compiled files
export PATH=$HOME/.local/bin:$PATH

# Asdf version manager
if [ -f $HOME/.asdf/asdf.sh ]; then
    source $HOME/.asdf/asdf.sh
fi

# Home binaries (systems should do this already)
export PATH=$HOME/bin:$PATH

# Yarn local install
if [[ -d $HOME/.yarn/bin ]]; then
    export PATH=$HOME/.yarn/bin:$PATH
fi

################################################################################


# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac


################################################################################
### Bash it!
################################################################################

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='bakke'

unset GIT_HOSTING

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Load Bash It
source "$BASH_IT"/bash_it.sh

################################################################################


################################################################################
### Aliases
################################################################################

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    alias ls='ls --color=auto --group-directories-first --sort=extension'
    alias update-ubuntu='sudo sh -c "apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get autoremove -y"'
elif [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -FG'

    whoishoggingport () {
        lsof -n -iTCP:$1 | grep LISTEN
    }
fi

alias ..='cd ..'
alias back='cd "$OLDPWD"'
alias mkdir='mkdir -p -v'
alias su='sudo -i'
alias mux='tmuxinator start'
alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'

alias erlang-version="erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), \"releases\", erlang:system_info(otp_release), \"OTP_VERSION\"])), io:fwrite(Version), halt().' -noshell"

# Xorg aliases:
alias gta='gitk --all'
alias gita='gitk --all'

################################################################################


################################################################################
### Other
################################################################################

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[[ -e "$HOME/.fzf-extras/fzf-extras.sh" ]] \
    && source "$HOME/.fzf-extras/fzf-extras.sh"


# OS X
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Enable bash completion on OS X
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        source `brew --prefix`/etc/bash_completion
    fi

    # Iterm integration
    if [ -f $HOME/.iterm2_shell_integration.bash ]; then
        source $HOME/.iterm2_shell_integration.bash
    fi
fi

# Bash completions
if [ -d $HOME/.bash_completions ]; then
    for f in $HOME/.bash_completions/*
    do
        if [ -f $f ]; then
            source $f
        fi
    done
fi

# Asdf completions
if [ -f $HOME/.asdf/completions/asdf.bash ]; then
    source $HOME/.asdf/completions/asdf.bash
fi


# Enable Erlang/Elixir shell history
export ERL_AFLAGS="-kernel shell_history enabled"

export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_FIND_FILE_COMMAND="rg --files"

################################################################################

export PATH="$HOME/.cargo/bin:$PATH"

# If running from tty1 start sway
if [ "$(tty)" = "/dev/tty1" ]; then
    exec sway
fi
