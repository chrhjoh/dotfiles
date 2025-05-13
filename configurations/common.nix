{
  system = {
    stateVersion = 6;
    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock
    };
  };
  security.pam.services.sudo_local.touchIdAuth = true;
  nixpkgs.config.allowUnfree = true;
  nix = {
    enable = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      use-xdg-base-directories = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
