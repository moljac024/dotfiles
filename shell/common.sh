#/usr/bin/env sh
# vim: filetype=sh
# set -euo pipefail # Shell strict mode

THIS=$(readlink -f "${BASH_SOURCE[0]:-${(%):-%x}}" 2>/dev/null||echo $0) # Full path of the current script
DIR=$(dirname "${THIS}") # The directory where current script resides

source "$DIR/util.sh"

if [ "$(get_running_shell)" = "unknown" ]; then
  return
fi

################################################################################
### Environment
################################################################################

export_var LC_ALL "en_US.UTF-8"
export_var LANG "en_US.UTF-8"
export_var EDITOR "vi"
export_var DOTFILES "$HOME/dotfiles"
export_var RESTIC_REPOSITORY "/run/media/$(whoami)/Gunnar/Backup/Restic/Repository"

if [ $(get_running_shell) = "zsh" ]; then
  autoload -Uz compinit && compinit
  autoload -U +X bashcompinit && bashcompinit
fi

# WSL
if is_wsl; then
    export_var WSL_HOST $(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null)

    wsl_ip () {
        ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
    }
    export_var WSL_GUEST $(wsl_ip)
fi

# Android dev
if [ -d $HOME/Android/Sdk ]; then
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
if [ -d "$HOME/Applications/flutter" ]; then
    modify_path "$HOME/Applications/flutter/bin" append
fi

# Dotnet
modify_path "$HOME/.dotnet/tools" append

# Rust binaries
modify_path "$HOME/.cargo/bin" prepend

# Volta nodejs version manager
if [ -d $HOME/.volta ]; then
    export_var VOLTA_HOME "$HOME/.volta"
    modify_path "$VOLTA_HOME/bin" prepend
fi

# Fly.io
export_var FLYCTL_INSTALL "$HOME/.fly"
modify_path "$FLYCTL_INSTALL/bin" prepend

# Locally compiled/installed files
modify_path "$HOME/.local/bin" prepend
# Home binaries (systems should do this already)
modify_path "$HOME/bin" prepend
modify_path "$HOME/.config/sway/bin" prepend

# Flatpak paths
export_var XDG_DATA_DIRS $HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS

# Krew kubectl plugin package manager
modify_path "${KREW_ROOT:-$HOME/.krew}/bin" prepend

###############################################################################
# Mise dev tool manager
###############################################################################

if is_command mise; then
  modify_path $HOME/.local/share/mise/shims prepend
  case $(get_running_shell) in
    "zsh")
      eval "$(mise activate zsh)"
      ;;
    "bash")
      eval "$(mise activate bash)"
      ;;
    *)
      :
      ;;
  esac
fi

################################################################################
### Aliases
################################################################################

if [ "$OSTYPE" = "linux-gnu" ]; then
  alias ls='ls --color=auto --group-directories-first --sort=extension'
  alias update-ubuntu='sudo sh -c "apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get autoremove -y"'
  alias update-fedora='sudo sh -c "dnf update -y"'
  alias update-arch='sudo sh -c "pacman -Syu --noconfirm"'
elif [ "$OSTYPE" = "darwin"* ]; then
  alias ls='ls -FG'
  whoishoggingport () {
    lsof -n -iTCP:$1 | grep LISTEN
  }
fi

if is_command sudo; then
  # Keep terminal info when using sudo
  alias sudo="sudo TERMINFO=\"$TERMINFO\""
fi

# If running in kitty, alias ssh to kitten ssh
if [ "$TERM" = "xterm-kitty" ]; then
  alias ssh='kitten ssh'
fi

alias update-npm-packages="npx npm-check-updates -i"
alias c='clear'
alias ..='cd ..'
alias back='cd "$OLDPWD"'
alias mkdir='mkdir -p -v'
alias su='sudo -i'
alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias gs='git add . && git commit -m "Sync" && git push origin'
alias erlang-version="erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), \"releases\", erlang:system_info(otp_release), \"OTP_VERSION\"])), io:fwrite(Version), halt().' -noshell"
alias serve-spa="npx --yes http-server-spa"
alias emacs="flatpak run org.gnu.emacs"

if is_available nvim; then
  export_var EDITOR "nvim"
  export_var VISUAL "nvim"
  alias vi="nvim"
  alias vim="nvim"
  alias vimdiff="nvim -d"
fi

if is_available eza; then
  alias ls="eza"
fi

alias lg='lazygit'

# Git aliases
alias gta='gitk --all'
alias gita='gitk --all'
alias gg='git gui'

# If podman is installed, use it instead of docker
if is_command podman; then
  alias docker=podman
  alias docker-compose='podman-compose'
  export_var DOCKER_HOST "unix://$(podman info --format '{{.Host.RemoteSocket.Path}}')"
fi

# k8s aliases
alias k='kubectl'
alias kcfg='kubectl config view --minify | grep name'
alias kc='kubectl ctx'
alias kn='kubectl ns'

# Print out k8s secret
ksecret () {
  kubectl get secret $@ -o json | jq -r '.data | to_entries[] | "\(.key): \(.value | @base64d)"'
}

if is_command zide; then
  export_var ZIDE_DIR $HOME/.config/zide
fi

################################################################################
### Other
################################################################################

# Dircolors
# if [ -f $HOME/.dir_colors ]; then
#     eval "$(dircolors $HOME/.dir_colors)"
# fi

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

# FZF
if [ "$(get_running_shell)" = "bash" ]; then
  [ -f ~/.fzf.bash ] && source ~/.fzf.bash
  [ -e "$HOME/.fzf-extras/fzf-extras.sh" ] \
    && source "$HOME/.fzf-extras/fzf-extras.sh"
fi

################################################################################
### Secrets
################################################################################

export_secret CR_PAT "$DOTFILES/secrets/github-token-registry"
export_secret DO_PAT "$DOTFILES/secrets/digital-ocean"
export_secret NPM_TOKEN_FOR_GITHUB "$DOTFILES/secrets/npm-token-for-github"
export_secret COPILOT_API_KEY "$DOTFILES/secrets/copilot-api-key"

################################################################################
### Other
################################################################################

# Cursor size
if is_command gsettings; then
    export_var XCURSOR_SIZE "$(gsettings get org.gnome.desktop.interface cursor-size)"
fi

################################################################################
### Prompt
################################################################################

if is_interactive; then
  if is_command starship; then
    eval "$(starship init "$(get_running_shell)")"
    eval "$(starship completions "$(get_running_shell)")"
  elif is_mise_command starship; then
    eval "$(mise exec starship -- starship init "$(get_running_shell)")"
    eval "$(mise exec starship -- starship completions "$(get_running_shell)")"
  fi
fi
