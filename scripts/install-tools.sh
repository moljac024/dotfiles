#!/bin/bash

# List of plugins to install
declare -a TOOLS=(
"starship"
"fzf"
"ripgrep"
"lazygit"
"neovim"
"kubectl"
"kubectx"
"kubecm"
"minikube"
"kustomize"
"helm"
"k9s"
"dagger"
"doctl"
"opentofu"
"jq"
"yq"
"mkcert"
"zig"
)

is_command () {
  command -v $cmd >/dev/null 2>&1
}

install_tool () {
  local tool="$1"
  if is_command mise; then
    echo "installing $tool via mise"
    mise use --global "$tool"@latest
  elif is_command asdf; then
    echo "installing $tool via asdf"
    asdf plugin add "$tool"
    asdf install "$tool" latest
    asdf global "$tool" latest
  else
    echo "cannot install tools, no version manager found"
    exit 1
  fi
}

for tool in "${TOOLS[@]}"; do
  echo "================================================================================"
  echo "$tool"
  echo "================================================================================"

  install_tool $tool

  echo "================================================================================"
  echo ""

  sleep 2
done

if is_command asdf; then
  asdf reshim
fi
