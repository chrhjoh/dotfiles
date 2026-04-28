function syspod
    set -l less_var $SYSTEMD_LESS

    if test -z "$less_var"
        set less_var FXRMK
    end
    
    sudo SYSTEMD_LESS=$less_var systemctl -M podman@ --user $argv
end
