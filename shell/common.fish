#!/usr/bin/env fish

set script_dir (dirname (status --current-filename))
source $script_dir/util.fish

################################################################################
### Environment
################################################################################

export_var LC_ALL "en_US.UTF-8"
export_var LANG "en_US.UTF-8"
export_var EDITOR "vi"
export_var DOTFILES "$HOME/dotfiles"

# WSL
if is_wsl
    export_var WSL_HOST (awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null)

    function wsl_ip
        ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
    end
    export_var WSL_GUEST (wsl_ip)
end

# Android dev
if test -d $HOME/Android/Sdk
    export_var ANDROID_HOME "$HOME/Android/Sdk"
    export_var ANDROID_SDK_ROOT "$ANDROID_HOME"

    modify_path "$ANDROID_HOME/emulator" append
    modify_path "$ANDROID_HOME/platform-tools" append

    # If cmdline tools version 8.0 are installed they should have precedence,
    # because react native does not work with newer ones
    modify_path "$ANDROID_HOME/cmdline-tools/8.0/bin" append
    modify_path "$ANDROID_HOME/cmdline-tools/latest/bin" append
    modify_path "$ANDROID_HOME/cmdline-tools/11.0/bin" append
    modify_path "$ANDROID_HOME/cmdline-tools/10.0/bin" append
    modify_path "$ANDROID_HOME/cmdline-tools/9.0/bin" append

    modify_path "$ANDROID_HOME/tools" append
    modify_path "$ANDROID_HOME/tools/bin" append

    if is_exported WSL_HOST
        export_var ADB_SERVER_SOCKET "tcp:$WSL_HOST:5037"
    end
end

# Android studio
if test -d "$HOME/Applications/android-studio"
    export_var ANDROID_STUDIO "$HOME/Applications/android-studio"
    ensure_symlink "$ANDROID_STUDIO/bin/studio.sh" "$HOME/bin/android-studio"
    modify_path "$HOME/Applications/android-studio/bin" append
end
if test -d "$HOME/Applications/flutter"
    modify_path "$HOME/Applications/flutter/bin" append
end

# Rust binaries
modify_path "$HOME/.cargo/bin" prepend

# Volta nodejs version manager
if test -d $HOME/.volta
    export_var VOLTA_HOME "$HOME/.volta"
    modify_path "$VOLTA_HOME/bin" prepend
end

# Fly.io
export_var FLYCTL_INSTALL "$HOME/.fly"
modify_path "$FLYCTL_INSTALL/bin" prepend

# Locally compiled/installed files
modify_path "$HOME/.local/bin" prepend
# Home binaries (systems should do this already)
modify_path "$HOME/bin" prepend

# Flatpak paths
export_var XDG_DATA_DIRS "$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"

# Krew kubectl plugin package manager
set -q KREW_ROOT; or set KREW_ROOT "$HOME/.krew"
modify_path "$KREW_ROOT/bin" prepend

###############################################################################
# Mise dev tool manager
###############################################################################

if is_command mise
    mise activate fish | source
end

################################################################################
### Aliases
################################################################################

if test "$OSTYPE" = "linux-gnu"
    alias ls='ls --color=auto --group-directories-first --sort=extension'
    alias update-ubuntu='sudo sh -c "apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get autoremove -y"'
    alias update-fedora='sudo sh -c "dnf update -y"'
    alias update-arch='sudo sh -c "pacman -Syu --noconfirm"'
else if string match -q "darwin*" "$OSTYPE"
    alias ls='ls -FG'
    function whoishoggingport
        lsof -n -iTCP:$argv[1] | grep LISTEN
    end
end

if is_command sudo
    # Keep terminal info when using sudo
    alias sudo="sudo TERMINFO=\"$TERMINFO\""
end

# If running in kitty, alias ssh to kitten ssh
if test "$TERM" = "xterm-kitty"
    alias ssh='kitten ssh'
end

alias update-npm-packages="npx npm-check-updates -i"
alias c='clear'
alias ..='cd ..'
alias back='cd "$OLDPWD"'
alias mkdir='mkdir -p -v'
alias su='sudo -i'
alias duf="du -sk * | sort -n | perl -ne '\$s,\$f=split(m{\t});for (qw(K M G)) {if(\$s<1024) {printf(\"%.1f\",\$s);print \"\$_\t\$f\"; last};\$s=\$s/1024}'"
alias gs='git add . && git commit -m "Sync" && git push origin'
alias erlang-version="erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), \"releases\", erlang:system_info(otp_release), \"OTP_VERSION\"])), io:fwrite(Version), halt().' -noshell"
alias serve-spa="npx --yes http-server-spa"
alias emacs="flatpak run org.gnu.emacs"

if is_available nvim
    export_var EDITOR "nvim"
    export_var VISUAL "nvim"
    alias vi="nvim"
    alias vim="nvim"
    alias vimdiff="nvim -d"
end

alias lg='lazygit'

# Git aliases
alias gta='gitk --all'
alias gita='gitk --all'
alias gg='git gui'

# If podman is installed, use it instead of docker
if is_command podman
    alias docker=podman
    alias docker-compose='podman-compose'
    export_var DOCKER_HOST "unix://(podman info --format '{{.Host.RemoteSocket.Path}}')"
end

# k8s aliases
alias k='kubectl'
alias kcfg='kubectl config view --minify | grep name'
alias kc='kubectx'
alias kn='kubens'

################################################################################
### Other
################################################################################

# Enable Erlang/Elixir shell history
export_var ERL_AFLAGS "-kernel shell_history enabled"

# Ripgrep and fzf config
export_var RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"
export_var FZF_DEFAULT_COMMAND "rg --files"
export_var FZF_FIND_FILE_COMMAND "rg --files"

# Catppuccin frappe theme for FZF
export_var FZF_DEFAULT_OPTS " \
--color=bg+:-1,bg:-1 \
--color=spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

################################################################################
### Secrets
################################################################################

export_secret CR_PAT "$DOTFILES/secrets/github-token-registry"
export_secret DO_PAT "$DOTFILES/secrets/digital-ocean"
export_secret NPM_TOKEN_FOR_GITHUB "$DOTFILES/secrets/npm-token-for-github"

################################################################################
### Other
################################################################################

# Cursor size
if is_command gsettings
    export_var XCURSOR_SIZE (gsettings get org.gnome.desktop.interface cursor-size)
end

################################################################################
### Prompt
################################################################################

#if is_interactive
#    if is_command starship
#        starship init fish | source
#    else if is_mise_command starship
#        mise exec starship -- starship init fish | source
#    end
#end
