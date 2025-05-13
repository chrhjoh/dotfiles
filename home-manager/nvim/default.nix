{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs;[
      tree-sitter
      imagemagick

      #formatters
      nixpkgs-fmt
      stylua
      ruff
      isort
      typstfmt
      snakefmt
      jq

      #lsp
      ltex-ls-plus
      texlab
      basedpyright
      lua-language-server
      texlab
      nixd
      rust-analyzer
      tinymist
    ];
    withNodeJs = true;
  };
  home.file."./.config/nvim/" = {
    source = ./config;
    recursive = true;
  };
}
