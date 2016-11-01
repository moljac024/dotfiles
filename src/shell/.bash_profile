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

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT=/Users/bojan/Apps/cocos2d-x-3.12/tools/cocos2d-console/bin
export PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_X_ROOT for cocos2d-x
export COCOS_X_ROOT=/Users/bojan/Apps
export PATH=$COCOS_X_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT=/Users/bojan/Apps/cocos2d-x-3.12/templates
export PATH=$COCOS_TEMPLATES_ROOT:$PATH
