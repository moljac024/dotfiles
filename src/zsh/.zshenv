################################################################################
### Environment
################################################################################

fpath=("$HOME/.zsh/functions" $fpath)

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vim

# Rust PATH
export PATH="$HOME/.cargo/bin:$PATH"

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

# Yarn local install
if [[ -d $HOME/.yarn/bin ]]; then
    export PATH=$HOME/.yarn/bin:$PATH
fi

# Locally compiled files
export PATH=$HOME/.local/bin:$PATH

# Home binaries (systems should do this already)
export PATH=$HOME/bin:$PATH

# FZF
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_FIND_FILE_COMMAND="rg --files"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

################################################################################


################################################################################
### Aliases
################################################################################

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    alias ls='ls --color=auto --group-directories-first --sort=extension'
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
alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'

alias erlang-version="erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), \"releases\", erlang:system_info(otp_release), \"OTP_VERSION\"])), io:fwrite(Version), halt().' -noshell"

# Xorg aliases:
alias gta='gitk --all'
alias gita='gitk --all'

################################################################################

