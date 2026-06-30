function s
    argparse 'q/query=' -- $argv
    or return

    set editor nano
    if set -q EDITOR
        set editor $EDITOR
    end

    set query $_flag_query
    set search_roots $argv
    test (count $search_roots) -eq 0; and set search_roots .

    fzf --ansi --disabled \
        --query "$query" \
        --bind "start:reload:rg --line-number --no-heading --color=always --smart-case {q} $search_roots || :" \
        --bind "change:reload:rg --line-number --no-heading --color=always --smart-case {q} $search_roots || :" \
        --bind "enter:execute($editor +{2} {1})" \
        --delimiter ":" \
        --preview "bat -p --color=always {1} --highlight-line {2}" \
        --preview-window "up:80%,border-bottom,~3,+{2}+3/3"
end
