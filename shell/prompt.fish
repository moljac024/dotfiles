source $DOTFILES/shell/util.fish

# Disable flow control
stty -ixon

################################################################################
### Prompt
################################################################################

if is_interactive
   if is_command starship
       starship init fish | source
   else
       if is_mise_command starship
           mise exec starship -- starship init fish | source
       end
   end
end
