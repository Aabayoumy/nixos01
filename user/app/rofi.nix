{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    rofi-wayland
  ];
  programs.rofi.terminal = "${pkgs.kitty}/bin/kitty";
  # programs.rofi = let
  #   inherit (config.lib.formats.rasi) mkLiteral;
  # in {
  #   cycle = true;
  #   # Install the wayland variant of rofi
  #   package = pkgs.rofi-wayland;
  #   # Set terminal to kitty
  #   terminal = "${pkgs.kitty}/bin/kitty";
  # };
}
