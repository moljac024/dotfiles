#!/usr/bin/env bash

function is_exported {
    local name="$1"
    if [[ "${!name@a}" == *x* ]]; then
        true; return
    else
        false; return
    fi
}

function is_wsl {
    if grep -qi microsoft /proc/version; then
        true; return
    else
        false; return
    fi
}

function export_secret () {
    local varName=$1
    local file=$2
    local content=$(cat $file)

    if [[ -f $file ]]; then
      export "${varName}"="$content"
    fi
}

################################################################################
### Environment
################################################################################


export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR='vim'
export DOTFILES=$HOME/dotfiles

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

# OS X Homebrew
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH=/usr/local/sbin:/usr/local/bin:$PATH
fi

# WSL
if is_wsl; then
    export WSL_HOST=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null)
    #export DISPLAY="$WSL_HOST:0"
    #export LIBGL_ALWAYS_INDIRECT=1

    function wsl_ip {
        ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
    }
    export WSL_GUEST=$(wsl_ip)
fi

# JAVA
if [ -d "/usr/lib/jvm/java-8-openjdk-amd64" ]; then
    export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
    export JRE_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre"
    export PATH=$PATH:$JAVA_HOME/bin
fi

if [ -d $HOME/Android/Sdk ];then
    export ANDROID_HOME=$HOME/Android
    export ANDROID_SDK_ROOT=$HOME/Android/Sdk
    export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
    export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
    if is_exported WSL_HOST; then
        export ADB_SERVER_SOCKET=tcp:$WSL_HOST:5037
    fi
fi

# Rust binaries
export PATH="$HOME/.cargo/bin:$PATH"

# Vector
if [[ -d $HOME/.vector ]]; then
    export PATH="$HOME/.vector/bin:$PATH"
fi

# Linuxbrew
if [[ -d "/home/linuxbrew" ]]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
fi

# Asdf version manager
if [ -f $HOME/.asdf/asdf.sh ]; then
    source $HOME/.asdf/asdf.sh
fi

# Volta nodejs version manager
if [[ -d $HOME/.volta ]]; then
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
fi

# N node version manager
if [[ -d $HOME/.n ]]; then
    export N_PREFIX=$HOME/.n
    export PATH=$N_PREFIX/bin:$PATH
fi

# Fly.io
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/home/bojan/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# Locally compiled/installed files
export PATH=$HOME/.local/bin:$PATH
# Home binaries (systems should do this already)
export PATH=$HOME/bin:$PATH

# Flatpak paths
export XDG_DATA_DIRS=$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS

################################################################################


# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

################################################################################
### Prompt
################################################################################

# Starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
    eval "$(starship completions bash)"
fi


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

alias c='clear'
alias ..='cd ..'
alias back='cd "$OLDPWD"'
alias mkdir='mkdir -p -v'
alias su='sudo -i'
alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'

alias erlang-version="erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), \"releases\", erlang:system_info(otp_release), \"OTP_VERSION\"])), io:fwrite(Version), halt().' -noshell"

alias serve-spa="npx --yes http-server-spa"

alias emacs="flatpak run org.gnu.emacs"

# Xorg aliases:
alias gta='gitk --all'
alias gita='gitk --all'
alias gg='git gui'

# AWS aliases
alias cdk='npx --package aws-cdk cdk'
alias cdktf='npx --package cdktf-cli cdktf'
alias cdk8s='npx --package cdk8s-cli cdk8s'

alias tf='terraform'

# k8s aliases
alias k='kubectl'
alias kc='k config view --minify | grep name'
alias kx='kubectx'

# Krew kubectl plugin package manager
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

################################################################################


################################################################################
### Other
################################################################################

# Enable Erlang/Elixir shell history
export ERL_AFLAGS="-kernel shell_history enabled"

# Dircolors
if [[ -f $HOME/.dir_colors ]]; then
    eval "$(dircolors $HOME/.dir_colors)"
fi

# Ripgrep and fzf config
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_FIND_FILE_COMMAND="rg --files"

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[[ -e "$HOME/.fzf-extras/fzf-extras.sh" ]] \
    && source "$HOME/.fzf-extras/fzf-extras.sh"

################################################################################


################################################################################
### Completions
################################################################################

# Bash completions
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
    if [ -d $HOME/.bash_completions ]; then
        for f in $HOME/.bash_completions/*
        do
            if [ -f $f ]; then
                source $f
            fi
        done
    fi

    if [ -f $HOME/.bash.complete_alias ]; then
        source $HOME/.bash.complete_alias
        # Complete all aliases
        complete -F _complete_alias "${!BASH_ALIASES[@]}"
    fi
fi

# Asdf completions
if [ -f $HOME/.asdf/completions/asdf.bash ]; then
    source $HOME/.asdf/completions/asdf.bash
fi

# Direnv
if hash direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi

if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion bash)
fi

if command -v dagger >/dev/null 2>&1; then
    source <(dagger completion bash)
fi

################################################################################


################################################################################
### Secrets
################################################################################

export_secret CR_PAT $DOTFILES/.credentials/github-token-registry
export_secret DO_PAT $DOTFILES/.credentials/digital-ocean
export_secret NPM_TOKEN_FOR_GITHUB $DOTFILES/.credentials/npm_token_for_github
