{ pkgs, ... }: {
  programs.tmux = {
    enable = true; # Set the default terminal type
    terminal = "screen";
    mouse = true;
    prefix = "C-Space";
    keyMode = "vi";
    baseIndex = 1;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      {
        plugin = yank;
        extraConfig = ''
          set -g @yank_action 'copy-pipe'
          set -g @yank_with_mouse off
        '';
      }
      {
        plugin = catppuccin;
        extraConfig = ''
          set -ogq @catppuccin_window_number_position "left"
          set -ogq @catppuccin_window_current_text_color "#{@thm_surface_0}"
          set -ogq @catppuccin_window_current_number_color "#{@thm_peach}"
          set -ogq @catppuccin_window_text_color "#{@thm_surface_0}"
          set -ogq @catppuccin_window_number_color "#{@thm_overlay_2}"
          set -ogq @catppuccin_window_text " #{b:pane_current_path}"
          set -ogq @catppuccin_window_current_text " #{b:pane_current_path}"


          set -g status-right-length 100
          set -g status-left ""

          set -ogq @catppuccin_status_left_separator "█"
          set -g @catppuccin_status_right_separator " "
          set -g status-right "#{E:@catppuccin_status_application}#{E:@catppuccin_status_directory}#{E:@catppuccin_status_session}#{E:@catppuccin_status_host}#{E:@catppuccin_status_date_time}" 

          set -g @catppuccin_directory_color "#cba6f7"
          set -g @catppuccin_directory_text " #{b:pane_current_path}"

          set -g @catppuccin_pane_border_style "fg=#313244"
          set -g @catppuccin_pane_active_border_style "fg=#313244"
        '';
      }

    ];
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on


      # Shift Alt h/l to change windows
      bind -n M-h previous-window
      bind -n M-l next-window

      # Creating panes
      bind-key    -T prefix -   split-window
      bind-key    -T prefix |   split-window -h
      # Creating windows
      bind-key    -T prefix c    new-window
      # Rename windows
      bind-key    -T prefix n   command-prompt -I "#S" { rename-window "%%" }
      # Rename session
      bind-key    -T prefix N   command-prompt -I "#S" { rename-session "%%" }
      # Kill pane
      bind-key    -T prefix k    confirm-before -p "kill-pane #P? (y/n)" kill-pane
      # Kill window
      bind-key    -T prefix K    confirm-before -p "kill-window #W? (y/n)" kill-window

      # Reconfigure copy-mode-vi keys
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X end-selection
    '';

  };
}
