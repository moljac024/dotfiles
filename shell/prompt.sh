# vim: filetype=sh

source "$DOTFILES/shell/lib.sh"

# Disable flow control
stty -ixon

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
