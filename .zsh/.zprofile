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

function activate_pyenv () { 
  VENV_DIR="$HOME/.pyenvs/"
  venvs=($(ls "$VENV_DIR"))

  if [ -z "$1" ]; then
    echo "Please provide the name of the virtual environment to activate."
    echo "Available virtual environments in $VENV_DIR:"
    echo ""

  
    for i in {1..${#venvs[@]}}; do
      echo "$i) ${venvs[$((i))]}"
    done
    echo ""

    echo -n "Please enter the name or number of the virtual environment: "
    read VENV
  else
    VENV=$1
  fi
  if [[ "$VENV" =~ ^[0-9]+$ ]]; then
    VENV="${venvs[$((VENV))]}"
  fi

  VENV_PATH="${VENV_DIR}/$VENV/bin/activate"

  # Check if the provided virtual environment exists
  if [ -f "$VENV_PATH" ]; then
    source "$VENV_PATH"
    echo ""
    echo "Activated virtual environment: $VENV"
  else
    echo ""
    echo "Virtual environment '$VENV' not found in $VENV_DIR"
    echo "Please choose from the created environments:"
    echo ""

    ls "$VENV_DIR"

    return 1
  fi }

# Setup paths
path=($path  "/Users/hcq343/.local/bin")
