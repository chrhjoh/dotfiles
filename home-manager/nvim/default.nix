{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs;[ gcc tree-sitter imagemagick ];
    withNodeJs = true;
  };
  home.file."./.config/nvim/" = {
    source = ./config;
    recursive = true;
  };
}
