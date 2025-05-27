# This function emits an OSC 1337 sequence to set a user var
# associated with the current terminal pane.
# It requires the `base64` utility to be available in the path.
__wezterm_set_user_var() {
  if hash base64 2>/dev/null ; then
    if [[ -z "${TMUX-}" ]] ; then
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
