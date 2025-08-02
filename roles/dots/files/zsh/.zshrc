source "$ZDOTDIR/config/variables.zsh"

export PATH="$HOME/.local/bin:$PATH"
fpath+="$XDG_DATA_HOME/zsh/completions/"

# Load homebrew without $fpath extend (functions are already included) since it causes compinit reload currently
 if [[ -d /opt/homebrew && -z "$HOMEBREW_PREFIX" ]]; then
   export HOMEBREW_PREFIX="/opt/homebrew";
   export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
   export HOMEBREW_REPOSITORY="/opt/homebrew";
   export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
   [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
   export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
 fi

source "$ZDOTDIR/config/options.zsh"
source "$ZDOTDIR/config/functions.zsh"
source "$ZDOTDIR/config/keys.zsh"
source "$ZDOTDIR/config/aliases.zsh"

[[ -f "$ZDOTDIR/zshrc.local" ]] && source "$ZDOTDIR/zshrc.local"

eval "$(starship init zsh)"

# ----- bootstrap zimfw plugin manager -----
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
