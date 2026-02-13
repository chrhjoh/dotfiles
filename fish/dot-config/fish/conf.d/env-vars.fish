# XDG Base Directories
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"

set -x XDG_RUNTIME_DIR "/run/user/$(id -u)"
set -x XDG_STATE_HOME "$HOME/.local/state"

# Tool-specific directories
set -x RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -x CARGO_HOME "$XDG_DATA_HOME/cargo"
set -x GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -x GEM_SPEC_CACHE "$XDG_CACHE_HOME/gem"
set -x GEM_HOME "$XDG_DATA_HOME/gem"
set -x NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -x LESSHISTFILE "$XDG_STATE_HOME/less/history"
set -x PYTHON_HISTORY "$XDG_STATE_HOME/python_history"
set -x R_HISTFILE "$XDG_STATE_HOME/R/history"
set -x ZIM_HOME "$XDG_DATA_HOME/zim"
set -x HISTFILE "$XDG_STATE_HOME/zsh/history"
set -x TEXMFHOME "$XDG_DATA_HOME/texmf"
set -x ANSIBLE_HOME "$XDG_DATA_HOME/ansible"

set -x EDITOR "nvim"
set -x DOTFILES "$HOME/.config/dotfiles"

set -x PAGER "less -FRSXMK"
set -x SYSTEMD_LESS "FRXMK"

set -x HOMEBREW_NO_AUTO_UPDATE 1
set -x BUNDLE_USER_CONFIG "$XDG_CONFIG_HOME"/bundle
set -x BUNDLE_USER_CACHE "$XDG_CACHE_HOME"/bundle
set -x BUNDLE_USER_PLUGIN "$XDG_DATA_HOME"/bundle

