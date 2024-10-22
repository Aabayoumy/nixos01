{
  config,
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../server/home.nix
    (./. + "../../../user/wm" + ("/" + userSettings.wm + "/" + userSettings.wm) + ".nix")
    ../../user/style/stylix.nix
  ];
  # ] ++ (if config.users.users.abayoumy.shell == pkgs.zsh then [ ./shells/zsh.nix ] else []);

  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    kitty
    firefox
  ];

  programs.home-manager.enable = true;
}
