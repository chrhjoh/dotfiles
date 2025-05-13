{ pkgs, ... }: {
  system = {
    activationScripts.postUserActivation.text = ''
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
    };
    casks = [
      "vivaldi"
      "1password"
      "1password-cli"
      "slack"
      "spotify"
      "wezterm@nightly"
      "zotero"
      "obsidian"
      "rectangle"
    ];
    brews = [
    ];
  };
  users.users.hcq343 = {
    home = "/Users/hcq343";
    shell = pkgs.zsh;
  };
}
