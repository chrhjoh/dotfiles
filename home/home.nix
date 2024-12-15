{
  config,
  pkgs,
  wezterm,
  ...
}:

{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  home.packages = with pkgs; [


  ];

  #create dotfile symlinks to store
  xdg.configFile."wezterm".source = ./../wezterm;
  xdg.configFile."nvim".source = ./../nvim;
  xdg.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = false;
      palette = "catppuccin_mocha";
      character = {
        success_symbol = "[[󰄛 ](green)❯](peach)";
        error_symbol = "[[󰄛 ](red)❯](peach)";

      };
      cmd_duration.disabled = true;
      git_status = {
        style = "bold mauve";
      };
      git_branch = {
        style = "bold mauve";
        format = "on [$symbol$branch(:$remote_branch)]($style) ";
      };
      nix_shell = {
        format = "[$symbol $state( \($name\))]($style) ";
        symbol = "❄️";
      };
      directory = {
        style = "bold flamingo";
      };
      python = {
        symbol = " ";
        format = "[($symbol($virtualenv))]($style) ";
        style = "bold yellow";
      };
      conda = {
        format = "[$symbol$environment]($style) ";
      };
      rust = {
        symbol = " ";
        format = "[$symbol ($version)]($style) ";
        style = "bold red";
      };
      package.disabled = true;
      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";

      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Christian Johansen";
    userEmail = "christian.johansen@cpr.ku.dk";
    aliases = {
      co = "checkout";
      cm = "commit -m";
      s = "status";
      ca = "commit --amend";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
    };
  };

  # Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "alias-finder"
        "docker"
        "python"
        "rust"
      ];
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      update = "darwin-rebuild switch --flake $DOTFILES";
      mm = "micromamba";
      dots = "cd $DOTFILES";
    };
    sessionVariables =
      let
        xdg = config.xdg;
        runtime_dir = "${config.home.homeDirectory}/.xdg-runtime";
      in
      {
        XDG_DATA_HOME = xdg.dataHome;
        XDG_CONFIG_HOME = xdg.configHome;
        XDG_STATE_HOME = xdg.stateHome;
        XDG_CACHE_HOME = xdg.cacheHome;
        XDG_RUNTIME_DIR = runtime_dir;
        CARGO_HOME = "${xdg.dataHome}/cargo";
        MAMBA_ROOT_PREFIX = "${xdg.dataHome}/micromamba";
        CONDARC = "${xdg.configHome}/conda/condarc";
        DOTFILES = "${xdg.configHome}/dotfiles";
        R_HISTFILE = "${xdg.stateHome}/R/history";
        HISTFILE = "${xdg.stateHome}/bash/history";
        BUNDLE_USER_CACHE = "${xdg.cacheHome}/bundle";
        BUNDLE_USER_CONFIG = "${xdg.configHome}/bundle";
        BUNDLE_USER_PLUGIN = "${xdg.dataHome}/bundle";
        JULIA_DEPOT_PATH = "${xdg.dataHome}/julia:$JULIA_DEPOT_PATH";
        DOCKER_CONFIG = "${xdg.configHome}/docker";
        NPM_CONFIG_INIT_MODULE = "${xdg.configHome}/npm/config/npm-init.js";
        NPM_CONFIG_CACHE = "${xdg.cacheHome}/npm";
        NPM_CONFIG_TMP = "${runtime_dir}/npm";
        PYTHON_HISTORY = "${xdg.stateHome}/python_history";
        LESSHISTFILE = "${xdg.stateHome}/less/history";
      };
    history = {
      size = 10000;
      path = "${config.xdg.stateHome}/zsh_history";
    };
    initExtra = ''
      HYPHEN_INSENSITIVE="true"
      unsetopt beep
      setopt COMBINING_CHARS

      ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=+(vi-forward-word)
      bindkey "^[[1;5C" vi-forward-word
      bindkey "^[[1:5D" vi-backward-word

      # >>> mamba initialize >>>
      # !! Contents within this block are managed by 'mamba init' !!
      export MAMBA_EXE='/etc/profiles/per-user/hcq343/bin/micromamba';
      export MAMBA_ROOT_PREFIX='/Users/hcq343/.local/share/micromamba';
      __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__mamba_setup"
      else
          alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
      fi
      unset __mamba_setup
      # <<< mamba initialize <<<'';

    profileExtra = ''
      function devshell() {
          local repo="git+ssh://git@github.com/chrhjoh/dev-shells/" 
          local available_shells
          local selected_shell

          # Fetch the available shells using nix flake metadata
          available_shells=$(nix flake show --quiet --quiet --json "$repo" | jq -r '.devShells | values[] | keys[]'| sort | uniq)  

          # Check if any shells are available
          if [[ -z "$available_shells" ]]; then
            echo "No available shells found in the flake."
            return 1
          fi

          echo "Available shells from $repo:"
          echo "$available_shells"  | nl  # Numbered list of shells

          # Prompt the user to select a shell
          echo -n "Enter the number of the shell you want to activate: "
          read shell_index

          # Get the shell name corresponding to the index
          selected_shell=$(echo "$available_shells" | sed -n "''${shell_index}p")

          if [[ -n "$selected_shell" ]]; then
            echo "Activating shell: $selected_shell"
            nix develop "$repo#$selected_shell" -c "$SHELL"
          else
            echo "Invalid selection. Please try again."
          fi
          eval "$(/opt/homebrew/bin/brew shellenv)"
        }'';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    prefix = "C-Space";
    sensibleOnTop = true;

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
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.yank;
        extraConfig = ''
          set -g @yank_action 'copy-pipe'
          set -g @yank_with_mouse off

        '';
      }
      {
        plugin = tmuxPlugins.catppuccin;
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

  };
  programs.nushell = {
    enable = true;
    extraConfig = ''
      let color_palette = {
              rosewater: "#f5e0dc"
              flamingo: "#f2cdcd"
              pink: "#f5c2e7"
              mauve: "#cba6f7"
              red: "#f38ba8"
              maroon: "#eba0ac"
              peach: "#fab387"
              yellow: "#f9e2af"
              green: "#a6e3a1"
              teal: "#94e2d5"
              sky: "#89dceb"
              sapphire: "#74c7ec"
              blue: "#89b4fa"
              lavender: "#b4befe"
              text: "#cdd6f4"
              subtext1: "#bac2de"
              subtext0: "#a6adc8"
              overlay2: "#9399b2"
              overlay1: "#7f849c"
              overlay0: "#6c7086"
              surface2: "#585b70"
              surface1: "#45475a"
              surface0: "#313244"
              base: "#1e1e2e"
              mantle: "#181825"
              crust: "#11111b"
          }
      let catppuccin_theme = {
              separator: $color_palette.overlay0
              leading_trailing_space_bg: { attr: "n" }
              header: { fg: $color_palette.blue attr: "b" }
              empty: $color_palette.lavender
              bool: $color_palette.lavender
              int: $color_palette.peach
              duration: $color_palette.text
              filesize: {|e|
                  if $e < 1mb {
                      $color_palette.green
                  } else if $e < 100mb {
                      $color_palette.yellow
                  } else if $e < 500mb {
                      $color_palette.peach
                  } else if $e < 800mb {
                      $color_palette.maroon
                  } else if $e > 800mb {
                      $color_palette.red
                  }
              }
              date: {|| (date now) - $in |
                  if $in < 1hr {
                      $color_palette.green
                  } else if $in < 1day {
                      $color_palette.yellow
                  } else if $in < 3day {
                      $color_palette.peach
                  } else if $in < 1wk {
                      $color_palette.maroon
                  } else if $in > 1wk {
                      $color_palette.red
                  }
              }
              range: $color_palette.text
              float: $color_palette.text
              string: $color_palette.text
              nothing: $color_palette.text
              binary: $color_palette.text
              'cell-path': $color_palette.text
              row_index: { fg: $color_palette.mauve attr: "b" }
              record: $color_palette.text
              list: $color_palette.text
              block: $color_palette.text
              hints: $color_palette.overlay1
              search_result: { fg: $color_palette.red bg: $color_palette.surface1 }

              shape_and: { fg: $color_palette.pink attr: "b" }
              shape_binary: { fg: $color_palette.pink attr: "b" }
              shape_block: { fg: $color_palette.blue attr: "b" }
              shape_bool: $color_palette.teal
              shape_custom: $color_palette.green
              shape_datetime: { fg: $color_palette.teal attr: "b" }
              shape_directory: $color_palette.teal
              shape_external: $color_palette.teal
              shape_externalarg: { fg: $color_palette.green attr: "b" }
              shape_filepath: $color_palette.teal
              shape_flag: { fg: $color_palette.blue attr: "b" }
              shape_float: { fg: $color_palette.pink attr: "b" }
              shape_garbage: { fg: $color_palette.base bg: $color_palette.red attr: "b" }
              shape_globpattern: { fg: $color_palette.teal attr: "b" }
              shape_int: { fg: $color_palette.pink attr: "b" }
              shape_internalcall: { fg: $color_palette.teal attr: "b" }
              shape_list: { fg: $color_palette.teal attr: "b" }
              shape_literal: $color_palette.blue
              shape_match_pattern: $color_palette.green
              shape_matching_brackets: { attr: "u" }
              shape_nothing: $color_palette.teal
              shape_operator: $color_palette.peach
              shape_or: { fg: $color_palette.pink attr: "b" }
              shape_pipe: { fg: $color_palette.pink attr: "b" }
              shape_range: { fg: $color_palette.peach attr: "b" }
              shape_record: { fg: $color_palette.teal attr: "b" }
              shape_redirection: { fg: $color_palette.pink attr: "b" }
              shape_signature: { fg: $color_palette.green attr: "b" }
              shape_string: $color_palette.green
              shape_string_interpolation: { fg: $color_palette.teal attr: "b" }
              shape_table: { fg: $color_palette.blue attr: "b" }
              shape_variable: $color_palette.pink

              background: $color_palette.base
              foreground: $color_palette.text
              cursor: $color_palette.blue
          }
          
      $env.config = {
          show_banner: false # true or false to enable or disable the welcome banner at startup

          completions: {
              case_sensitive: false # case-sensitive completions
              quick: true    # set to false to prevent auto-selecting completions
              partial: true    # set to false to prevent partial filling of the prompt
              algorithm: "prefix"    # prefix or fuzzy
              external: {
              # set to false to prevent nushell looking into $env.PATH to find more suggestions
                  enable: true 
              # set to lower can improve completion performance at the cost of omitting some options
                  max_results: 100 
                }
              }
          color_config: $catppuccin_theme
          }

    '';

  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
    config = {
      hide_env_diff = true;
    };
  };

}
