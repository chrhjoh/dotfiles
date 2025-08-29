# ZDOTDIR is set in .zshenv

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_RUNTIME_DIR="$HOME/.xdg-runtime"
export XDG_STATE_HOME="$HOME/.local/state"

export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export GEM_HOME="$XDG_DATA_HOME/gem"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
export R_HISTFILE="$XDG_STATE_HOME/R/history"
export ZIM_HOME="$XDG_DATA_HOME/zim"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export TEXMFHOME="$XDG_DATA_HOME/texmf"

export EDITOR="nvim"
export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/homebrew/Brewfile.$HOST"
