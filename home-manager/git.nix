{
  programs.git = {
    enable = true;
    userName = "Christian Johansen";
    userEmail = "christian.holm.johansen@gmail.com";
    aliases = {
      a = "add";
      s = "status";
      c = "commit";
      cm = "commit -m";
      ca = "commit --amend";
      co = "checkout";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
    };
    extraConfig = {
      pull = { rebase = true; };
    };
    ignores = [
      # macOS
      ".DS_Store"
      "._*"
      ".Spotlight-V100"
      ".Trashes"

      # Windows
      "Thumbs.db"
      "Desktop.ini"
    ];
  };
}
