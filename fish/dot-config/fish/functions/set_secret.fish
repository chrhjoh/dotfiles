function set_secret
    if test (count $argv) -ne 1
        echo "Usage: set_secret VARIABLE_NAME"
        return 1
    end

    set varname $argv[1]

    read -s -P "Enter value for $varname: " value
    echo

    set -gx $varname $value
end
