{
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../server/configuration.nix
    (./. + "../../../system/wm" + ("/" + userSettings.wm) + ".nix") # My window manager
    ../../system/style/stylix.nix
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
