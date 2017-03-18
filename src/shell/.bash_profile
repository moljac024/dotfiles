# Concise way to check for unix type
# case "$OSTYPE" in
#   solaris*) echo "SOLARIS" ;;
#   darwin*)  echo "OSX" ;;
#   linux*)   echo "LINUX" ;;
#   bsd*)     echo "BSD" ;;
#   *)        echo "unknown: $OSTYPE" ;;
# esac

# Source .bashrc
if [ -f $HOME/.bashrc ]; then
    source $HOME/.bashrc
fi
