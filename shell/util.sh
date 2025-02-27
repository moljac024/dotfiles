#/usr/bin/env sh
# vim: filetype=sh

################################################################################
### Helper functions
################################################################################

get_running_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    elif [ -n "$BASH_VERSION" ]; then
        echo "bash"
    else
        echo "unknown"
    fi
}

is_interactive() {
  case "$(get_running_shell)" in
    bash|zsh)
      [[ $- == *i* ]]
      ;;
    *)
      # Fallback for unknown shells
      case $- in
        *i*) return 0 ;;
        *) return 1 ;;
      esac
      ;;
  esac
}

is_wsl() {
  grep -qi microsoft /proc/version
}

is_exported() {
    [ -n "$(export -p | grep "^export $1=")" ]
}

is_command() {
  command -v "$1" >/dev/null 2>&1
}

is_mise_command() {
  is_command mise && mise which "$1" >/dev/null 2>&1
}

is_available() {
  is_command "$1" || is_mise_command "$1"
}

export_var() {
  local var_name="$1"
  local var_value="$2"

  # Replace spaces with underscores in variable name
  var_name="${var_name// /_}"
  export "$var_name=$var_value"
}

export_secret () {
  local var_name=$1
  local file=$2
  if [ -f $file ]; then
    local content=$(cat $file)
    export_var "${var_name}" "$content"
  fi
}

export_secrets_from_dir() {
    local dir=$1
    if [[ ! -d "$dir" ]]; then
        echo "Error: '$dir' is not a directory" >&2
        return 1
    fi

    for file in "$dir"/*; do
        if [[ -f "$file" ]]; then
            local var_name
            var_name=$(basename "$file")
            local content
            content=$(<"$file") # Read file content efficiently
            export_var "$var_name" "$content"
        fi
    done
}

ensure_symlink () {
  local original=$1
  local path=$2
  local original_fullpath="$(cd "$(dirname "$original")"; pwd)/$(basename "$original")"

  if [ -L "$path" ]; then
    rm "$path"
  fi

  if [ -e "$path" ]; then
    mv "$path" "$path.old"
  fi

  ln -s "$original_fullpath" "$path"
}

modify_path() {
  local dir="$1"
  local action="$2"
  if [[ ":$PATH:" != *":$dir:"* ]]; then
    if [ "$action" = "prepend" ]; then
      export PATH="$dir:$PATH"
    else
      export PATH="$PATH:$dir"
    fi
  fi
}

git_clone () {
    local repo=$1
    local location=$2
    local location_fullpath="$(cd "$(dirname "$location")"; pwd)/$(basename "$location")"

    if [ ! -d "$location_fullpath" ]; then
        git clone "$repo" "$location_fullpath"
    fi
}

cdr() {
    dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]]; then
            cd "$dir" || return
            return
        fi
        dir=$(dirname "$dir")
    done
    echo "No .git directory found" >&2
}
