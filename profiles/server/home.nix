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

  xdg.enable = true;
  xdg.userDirs = {
    extraConfig = {
      XDG_DESKTOP_DIR = "${config.home.homeDirectory}/Desktop";
      XDG_DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents";
      XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
      XDG_MUSIC_DIR = "${config.home.homeDirectory}/Music";
      XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
      XDG_PUBLICSHARE_DIR = "${config.home.homeDirectory}/Public";
      XDG_TEMPLATES_DIR = "${config.home.homeDirectory}/Templates";
      XDG_VIDEOS_DIR = "${config.home.homeDirectory}/Videos";
    };
  };

  xdg.userDirs.createDirectories = true;
  programs.home-manager.enable = true;
}
