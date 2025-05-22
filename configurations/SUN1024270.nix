{ pkgs, ... }: {
  system = {
    activationScripts.postActivation.text = ''
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    primaryUser = "hcq343";
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };
    casks = [
      "vivaldi"
      "1password"
      "slack"
      "spotify"
      "wezterm@nightly"
      "zotero"
      "obsidian"
      "rectangle"
      "skim"
    ];
    brews = [
    ];
  };
  users.users.hcq343 = {
    home = "/Users/hcq343";
    shell = pkgs.zsh;
  };
}
