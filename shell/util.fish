################################################################################
### Helper functions
################################################################################

function get_running_shell
    echo "fish"
end

function is_interactive
    status --is-interactive
end

function is_wsl
    grep -qi microsoft /proc/version
end

function is_exported
    set -q "$argv[1]"
end

function is_command
    command -v "$argv[1]" >/dev/null 2>&1
end

function is_mise_command
    is_command mise && mise which "$argv[1]" >/dev/null 2>&1
end

function is_available
    is_command "$argv[1]" || is_mise_command "$argv[1]"
end

function export_var
    set -l var_name $argv[1]
    set -l var_value $argv[2]
    # Replace spaces with underscores in variable name
    set var_name (string replace -a ' ' '_' $var_name)
    set -gx $var_name $var_value
end

function export_secret
    set -l var_name $argv[1]
    set -l file $argv[2]
    if test -f $file
        set -l content (cat $file)
        export_var $var_name $content
    end
end

function ensure_symlink
    set -l original $argv[1]
    set -l path $argv[2]
    set -l original_fullpath (realpath $original)
    if test -L $path
        rm $path
    end

    if test -e $path
        mv $path $path.old
    end
    ln -s $original_fullpath $path
end

function modify_path
    set -l dir $argv[1]
    set -l action $argv[2]
    if not contains $dir $PATH
        if test "$action" = "prepend"
            set -gx PATH $dir $PATH
        else
            set -gx PATH $PATH $dir
        end
    end
end

function git_clone
    set -l repo $argv[1]
    set -l location $argv[2]
    set -l location_fullpath (realpath (dirname $location))/(basename $location)
    if not test -d "$location_fullpath"
        git clone "$repo" "$location_fullpath"
    end
end
