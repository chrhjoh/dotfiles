{ config, pkgs, ... }:
{
  imports = [
    ../home-manager/direnv.nix
    ../home-manager/git.nix
    ../home-manager/nushell
    ../home-manager/lazygit.nix
    ../home-manager/starship.nix
    ../home-manager/tmux.nix
    ../home-manager/zsh.nix
    ../home-manager/nvim
    ../home-manager/wezterm #Does not install wezterm as that is managed by homebrew
  ];

  home = {
    sessionPath = [ "/opt/homebrew/bin" ];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
      OBSIDIAN_HOME = "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents";
      XDG_CONFIG_HOME = config.xdg.configHome;
      XDG_DATA_HOME = config.xdg.dataHome;
      XDG_RUNTIME_DIR = "$HOME/.xdg-runtime";
      XDG_STATE_HOME = config.xdg.stateHome;
      DOTFILES = "$HOME/.dotfiles";
      LAZY_LOCK_FILE = "$HOME/.dotfiles/home-manager/nvim/lazy-lock.json";
      PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
    };
    preferXdgDirectories = true;

    packages = with pkgs;
      [
        curl
        htop
        neofetch
        vim
        ripgrep
        imagemagick

        # Fonts
        jetbrains-mono
        nerd-fonts.symbols-only
      ];
  };

  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
  programs.home-manager.enable = true;
}

