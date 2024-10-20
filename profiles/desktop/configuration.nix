{
  pkgs,
  lib,
  systemSettings,
  userSettings,
  ...
}: {...}: {
  imports = [
    ../server/configuration.nix
    (./. + "../../system/wm" + ("/" + userSettings.wm) + "/install.nix") # My window manager
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
