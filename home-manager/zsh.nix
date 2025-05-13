{ config, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    dotDir = ".config/zsh";
    history = {
      path = "${config.xdg.stateHome}/zsh/zsh_history";
      expireDuplicatesFirst = true;
      extended = true;
    };
    shellAliases = {
      df = "df -h";
      ll = "ls -alGhF";
      la = "ls -AhF";
      l = "ls -CFh";
      ls = "ls -Gh --color";
      du = "du -h -d 2";

    };
    sessionVariables = { LS_COLORS = "di=34:ln=35:so=36:pi=33:ex=32:bd=44;37:cd=44;37:su=37;41:sg=30;43:tw=30;42:ow=34;42"; };
    initContent = ''
      unsetopt beep
      setopt AUTO_CD

      zstyle ':completion:*:default' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*:default' list-prompt '%S%M matches%s'

      # Group matches and describe.
      zstyle ':completion:*:*:*:*:*' menu select
      zstyle ':completion:*:matches' group 'yes'
      zstyle ':completion:*:options' description 'yes'
      zstyle ':completion:*:options' auto-description '%d'
      zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
      zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
      zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
      zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
      zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' verbose yes
      zstyle ':completion:*' list-rows-first true
      zstyle ':completion:*' list-packed yes
      zstyle ':completion:*' select-prompt '%SScrolling active: current selection →%s'

      # Fuzzy match mistyped completions.
      zstyle ':completion:*' completer _complete _match _approximate
      zstyle ':completion:*:match:*' original only
      zstyle ':completion:*:approximate:*' max-errors 1 numeric

      # This function emits an OSC 1337 sequence to set a user var
      # associated with the current terminal pane.
      # It requires the `base64` utility to be available in the path.
      __wezterm_set_user_var() {
        if hash base64 2>/dev/null ; then
          if [[ -z "$\{TMUX-}" ]] ; then
            printf "\033]1337;SetUserVar=%s=%s\007" "$1" `echo -n "$2" | base64`
          else
            # <https://github.com/tmux/tmux/wiki/FAQ#what-is-the-passthrough-escape-sequence-and-how-do-i-use-it>
            # Note that you ALSO need to add "set -g allow-passthrough on" to your tmux.conf
            printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" "$1" `echo -n "$2" | base64`
          fi
        fi
      }

      function _run_prog() {
          # set PROG to the program being run
          __wezterm_set_user_var "PROG" "$1"

          # arrange to clear it when it is done
          trap '__wezterm_set_user_var PROG ""' EXIT

          # and now run the corresponding command, taking care to avoid looping
          # with the definition
          command "$@"
      }
      if [[ -n "$WEZTERM_EXECUTABLE" ]]; then
          nvim() {
              _run_prog nvim "$@"
          }
      fi
    '';
  };
}
