{
  pkgs,
  systemSettings,
  ...
}: {
  imports = [
    ../server/configuration.nix
    (./. + "../../../system/wm" + ("/" + systemSettings.wm) + ".nix") # My window manager
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
