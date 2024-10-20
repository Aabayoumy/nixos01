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
}
