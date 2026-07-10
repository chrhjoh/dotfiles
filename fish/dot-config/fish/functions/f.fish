function f --wraps fd
    set -l editor nano
    if set -q EDITOR
        set editor $EDITOR
    end


    set -l selected (
        fd --type f $argv |
        fzf \
            --preview 'bat -p --color=always {}' \
            --preview-window 'right:50%,border-rounded'
    )

    test -n "$selected"; or return

    $editor "$selected"
end
