{
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    extraConfig = builtins.readFile ./catppuccin_macchiato.nu;
  };
}
