{
  inputs,
  pkgs,
  lib,
  xmonad-contexts,
  ...
}: {
  # Import x11 config
  imports = [
    ./x11.nix
    ./pipewire.nix
    ./dbus.nix
  ];
  environment.systemPackages = with pkgs; [
    kitty
    firefox
    polkit_gnome
    libva-utils
    fuseiso
    udiskie
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra
    gsettings-desktop-schemas
    swaynotificationcenter
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    rofi
  ];
  # Security
  security = {
    pam.services.login.enableGnomeKeyring = true;
  };

  services = {
    xserver = {
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = builtins.readFile ../../dot/xmonad.hs;
        ghcArgs = [
          "-hidir /tmp" # place interface files in /tmp, otherwise ghc tries to write them to the nix store
          "-odir /tmp" # place object files in /tmp, otherwise ghc tries to write them to the nix store
          "-i${xmonad-contexts}" # tell ghc to search in the respective nix store path for the module
        ];
      };
      enable = true;
      layout = "us";
      xkbVariant = "";
      excludePackages = [pkgs.xterm];
      # videoDrivers = ["nvidia"];
      libinput.enable = true;
      displayManager.sddm.enable = true;
      displayManager.sessionCommands = ''
        xset -dpms  # Disable Energy Star, as we are going to suspend anyway and it may hide "success" on that
        xset s blank # `noblank` may be useful for debugging
        xset s 300 # seconds
        ${pkgs.lightlocker}/bin/light-locker --idle-hint &
      '';
    };

    dbus.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    gnome = {
      sushi.enable = true;
      gnome-keyring.enable = true;
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = false;
      enableHidpi = true;
      theme = "chili";
      package = pkgs.sddm;
    };
  };
}
