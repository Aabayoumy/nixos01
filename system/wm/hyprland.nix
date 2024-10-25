# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  # Import wayland config
  imports = [
    ./wayland.nix
    ./pipewire.nix
    ./dbus.nix
  ];
  environment.systemPackages = with pkgs; [
    kitty
    polkit_gnome
    libva-utils
    fuseiso
    udiskie
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra
    nvidia-vaapi-driver
    gsettings-desktop-schemas
    swaynotificationcenter
    wlr-randr
    ydotool
    wl-clipboard
    hyprland-protocols
    hyprpicker
    swayidle
    swaylock
    xdg-desktop-portal-hyprland
    hyprpaper
    wofi
    firefox-wayland
    swww
    grim
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland
    adwaita-qt
    adwaita-qt6
  ];

  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable patching wlroots for better Nvidia support
    #enableNvidiaPatches = true;
  };
}
