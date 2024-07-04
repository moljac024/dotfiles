#!/bin/bash

# List of plugins to install
declare -a ASDF_PLUGINS=(
  "starship"
  "fzf"
  "ripgrep"
  "lazygit"
  "neovim"
  "kubectl"
  "kubectx"
  "minikube"
  "kustomize"
  "helm"
  "k9s"
  "dagger"
  "doctl"
  "opentofu"
  "jq"
  "yq"
)

# Install all the asdf managed programs
for plugin in "${ASDF_PLUGINS[@]}"; do
  echo "====================================================="
  echo "Installing $plugin..."
  echo "====================================================="

  asdf plugin add "$plugin"
  asdf install "$plugin" latest
  asdf global "$plugin" latest

  echo "Installed $plugin."
  echo "====================================================="
  echo ""
done
