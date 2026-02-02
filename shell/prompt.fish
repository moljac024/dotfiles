source $DOTFILES/shell/util.fish

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
