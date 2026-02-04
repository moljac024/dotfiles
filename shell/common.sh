# vim: filetype=sh

source "$DOTFILES/shell/lib.sh"

if [ "$(get_running_shell)" = "unknown" ]; then
  echo "Unknown shell, stopping."
  return
fi

################################################################################
### Environment
################################################################################

export_var LC_ALL "en_US.UTF-8"
export_var LANG "en_US.UTF-8"

# Homebrew
if [ -d "/opt/homebrew/bin" ]; then
    modify_path "/opt/homebrew/bin" prepend
fi

# Dotnet
modify_path "$HOME/.dotnet/tools" append

# Rust binaries
modify_path "$HOME/.cargo/bin" prepend

# Locally compiled/installed files
modify_path "$HOME/.local/bin" prepend
# Home binaries (systems should do this already)
modify_path "$HOME/bin" prepend

modify_path "$HOME/.config/sway/bin" prepend

# Krew kubectl plugin package manager
modify_path "${KREW_ROOT:-$HOME/.krew}/bin" prepend

# Windsurf
if [ -d $HOME/.codeium/windsurf/bin ]; then
  modify_path $HOME/.codeium/windsurf/bin prepend
fi

# Mise dev env
# NOTE: This has to come after PATH setup
if is_command mise; then
  export_var MISE_ENV_FILE .env
  modify_path "$HOME"/.local/share/mise/shims prepend
  shell=$(get_running_shell); case "$shell" in zsh|bash) eval "$(mise activate "$shell")";; esac
fi

################################################################################
### Aliases
################################################################################

if is_linux; then
  alias ls='ls --color=auto --group-directories-first --sort=extension'
  alias update-ubuntu='sudo sh -c "apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get autoremove -y"'
  alias update-fedora='sudo sh -c "dnf update -y"'
  alias update-arch='sudo sh -c "pacman -Syu --noconfirm"'
fi

if is_mac; then
  alias ls='ls -FG'
  whoishoggingport () {
    lsof -n -iTCP:$1 | grep LISTEN
  }
fi

if is_command sudo; then
  # Keep terminal info when using sudo
  alias sudo="sudo TERMINFO=\"$TERMINFO\""
fi

alias c='clear'
alias ..='cd ..'
alias cdn='cd $HOME/MyDocuments/Notebook/'
alias back='cd "$OLDPWD"'
alias mkdir='mkdir -p -v'
alias su='sudo -i'
alias gs='git add . && git commit -m "sync" && git push origin'

alias serve-spa="npx --yes http-server-spa"
alias update-npm-packages="npx -y npm-check-updates -i"
alias pbg="pick-ghostty-background"

if is_available eza; then
  alias ls="eza --group-directories-first"
fi

# Git aliases
alias gta='gitk --all'
alias gita='gitk --all'
alias gg='git gui'
alias lg='lazygit'

# k8s aliases
alias k='kubectl'
alias kcfg='kubectl config view --minify | grep name'
alias kc='kubectl ctx'
alias kn='kubectl ns'

################################################################################
### Other
################################################################################

# Nvim
if is_available nvim; then
  export_var EDITOR "nvim"
  export_var VISUAL "nvim"
  export_var MANPAGER "nvim +Man!"
fi

# WSL
if is_wsl; then
    export_var WSL_HOST "$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null)"

    wsl_ip () {
        ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
    }
    export_var WSL_GUEST "$(wsl_ip)"
fi

# Flatpak
if is_linux; then
  export_var XDG_DATA_DIRS "$HOME"/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:"$XDG_DATA_DIRS"
fi

# Android dev
if [ -d "$HOME/Android/Sdk" ]; then
    export_var ANDROID_HOME "$HOME/Android/Sdk"
    export_var ANDROID_SDK_ROOT "$ANDROID_HOME"

    modify_path "$ANDROID_HOME/emulator" append
    modify_path "$ANDROID_HOME/platform-tools" append

    # If cmdline tools version 8.0 are installed they should have precendence,
    # because react native does not work with newer ones
    modify_path "$ANDROID_HOME/cmdline-tools/8.0/bin" append
    modify_path "$ANDROID_HOME/cmdline-tools/latest/bin" append
    modify_path "$ANDROID_HOME/cmdline-tools/11.0/bin" append
    modify_path "$ANDROID_HOME/cmdline-tools/10.0/bin" append
    modify_path "$ANDROID_HOME/cmdline-tools/9.0/bin" append

    modify_path "$ANDROID_HOME/tools" append
    modify_path "$ANDROID_HOME/tools/bin" append

    if is_exported WSL_HOST; then
        export_var ADB_SERVER_SOCKET "tcp:$WSL_HOST:5037"
    fi
fi

# Android studio
if [ -d "$HOME/Applications/android-studio" ]; then
    export_var ANDROID_STUDIO "$HOME/Applications/android-studio"
    ensure_symlink "$ANDROID_STUDIO/bin/studio.sh" "$HOME/bin/android-studio"
    modify_path "$HOME/Applications/android-studio/bin" append
fi

if is_linux; then
  export_var RESTIC_REPOSITORY "/run/media/$(whoami)/Gunnar/Backup/Restic/Repository"
  export_var LIBVIRT_DEFAULT_URI "qemu:///system"
fi

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

# If podman is installed, use it instead of docker
if is_command podman && is_linux; then
  export_var DOCKER_HOST "ssh://vm-ubuntu-docker"
fi

################################################################################
### Local shell overrides
################################################################################

source_dir "$DOTFILES/shell/local.sh.d"

################################################################################
### Secrets
################################################################################

export_vars_from_dir "$DOTFILES/data/secrets"
