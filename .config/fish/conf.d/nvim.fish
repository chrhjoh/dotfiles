if set -q WEZTERM_EXECUTABLE
    functions -q nvim; or function nvim
        _run_prog nvim $argv
    end
end
