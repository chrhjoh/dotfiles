{ pkgs, ... }: {
  system = {
    activationScripts.postUserActivation.text = ''
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

  };
  homebrew = {
    enable = true;
    onActivation = {
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
