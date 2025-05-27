source "$ZDOTDIR/config/variables.zsh"
eval "$(/opt/homebrew/bin/brew shellenv)"

source "$ZDOTDIR/config/options.zsh"
source "$ZDOTDIR/config/functions.zsh"
source "$ZDOTDIR/config/keys.zsh"
source "$ZDOTDIR/config/aliases.zsh"
[[ -f "$ZDOTDIR/zshrc.local" ]] && source "$ZDOTDIR/zshrc.local"
# ----- zimfw plugin manager -----
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi


# ----- Source ZIM -----
source ${ZIM_HOME}/init.zsh

eval "$(starship init zsh)"
