ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=+(vi-forward-word)

# ZSH substring searching
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_PREFIXED=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=#24273a,fg=yellow,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=#24273a,fg=magenta,bold'

unsetopt beep

# ----- Completion Options ------
zstyle ':zim:completion' dumpfile $XDG_CACHE_HOME/zsh/zshcompdump
zstyle ':completion::complete:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
