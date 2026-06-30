function e
    set -l editor nano
    if set -q EDITOR
        set editor $EDITOR
    end

    set -l dir $argv[1]
    test -n "$dir"; or set dir .

    set -l selected (
        command fish -c "cd "(string escape -- "$dir")"; and fzf \
            --preview 'bat -p --color=always {1}' \
            --preview-window 'up:80%,border-bottom,~3,+{2}+3/3'"
    )

    test -n "$selected"; or return

    $editor "$dir/$selected"
end
