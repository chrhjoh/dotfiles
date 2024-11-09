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

    htop

    # Fuzzy finder
    fd
    ripgrep
    fzf

    # Python stuff
    pipx
    snakemake
    poetry
    micromamba

    # R
    R

    # markup
    typst
    texlive.combined.scheme-small

    #rust
    cargo

    #nix
    nixfmt-rfc-style

    spotify

    rectangle
    obsidian

    zotero
    slack

    wezterm.packages.${pkgs.system}.default
  ];

  #create dotfile symlinks
  xdg.configFile."wezterm".source = ./../wezterm;
  xdg.configFile."nvim".source = ./../nvim;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.oh-my-posh = {
    enable = true;
    useTheme = "catppuccin_mocha";
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
    dotDir = ".local/share/zsh/";
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
      update = "darwin-rebuild switch --flake ~/.config/dotfiles/";
      mm = "micromamba";
      dots = "cd $DOTFILES";
    };
    sessionVariables = {
      CARGO_HOME = "$HOME/.local/share/cargo";
      MAMBA_ROOT_PREFIX = "$HOME/.local/share/micromamba";
      DOTFILES = "$HOME/.config/dotfiles";
    };
    history = {
      size = 10000;
      path = "$ZDOTDIR/zsh_history";
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
      function activate_pyvenv () { 
      VENV_DIR="$HOME/.pyvenvs/"
      venvs=($(ls "$VENV_DIR"))

      if [ -z "$1" ]; then
        echo "Please provide the name of the virtual environment to activate."
        echo "Available virtual environments in $VENV_DIR:"
        echo ""


        for i in {1..''${#venvs[@]}}; do
          echo "$i) ''${venvs[$((i))]}"
        done
        echo ""

        echo -n "Please enter the name or number of the virtual environment: "
        read VENV
      else
        VENV=$1
      fi
      if [[ "$VENV" =~ ^[0-9]+$ ]]; then
        VENV="''${venvs[$((VENV))]}"
      fi

      VENV_PATH="''${VENV_DIR}/$VENV/bin/activate"

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
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
  };

  programs.zathura = {
    enable = true;
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

}