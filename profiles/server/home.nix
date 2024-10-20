{
  config,
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../../user/shells/sh.nix
  ];
  # ] ++ (if config.users.users.abayoumy.shell == pkgs.zsh then [ ./shells/zsh.nix ] else []);

  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    cowsay
    starship
    gcal
    bat
    fzf
    fd
    eza
    thefuck
  ];

  programs.home-manager.enable = true;
}
