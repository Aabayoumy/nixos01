{
  config,
  pkgs,
  userSettings,
  ...
}: {
  home.packages = [pkgs.git];
  programs.git.enable = true;
  programs.git.userName = userSettings.name;
  programs.git.userEmail = userSettings.email;
  programs.git.extraConfig = {
    init.defaultBranch = "main";
    safe.directory = [
      "/media/data/nixos01"
      "/media/data/nixos01/.git"
    ];
  };
}
