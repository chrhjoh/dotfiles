function __wezterm_set_user_var
    if type -q base64
        if not set -q TMUX
            printf "\033]1337;SetUserVar=%s=%s\007" $argv[1] (echo -n $argv[2] | base64)
        else
            printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" $argv[1] (echo -n $argv[2] | base64)
        end
    end
end
