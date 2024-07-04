# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"
# Initialize oh-my-posh
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.json)"

export EDITOR="nvim"

# Move annoying dotfiles out of $HOME
export RUSTUP_HOME="$HOME/.local/rustup"
export CARGO_HOME="$HOME/.local/cargo"
export DOCKER_CONFIG="$HOME/.config/docker"


alias lazygit='LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml" lazygit'
# Set dir for dotfiles and config
export DOTBARE_DIR="$HOME/.local/share/dotfiles/"
export DOTBARE_TREE=$HOME
alias .git="/usr/bin/git --git-dir=$DOTBARE_DIR --work-tree=$DOTBARE_TREE"

# For neovim and zathura to connect
export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

alias vi=nvim
alias vim=nvim
alias e=nvim

function pyactivate () { source "$HOME/.pyenvs/$1/bin/activate" }

# Setup paths
path=($path  "/Users/hcq343/.local/bin")
