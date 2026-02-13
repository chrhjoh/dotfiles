function _run_prog
    set prog $argv[1]
    __wezterm_set_user_var PROG $prog

    function __clear_prog --on-event fish_exit
        __wezterm_set_user_var PROG ""
    end

    command $argv
end
