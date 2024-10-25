{pkgs,lib, ...}: {
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
  ];

  # Configure X11
  # services = {
  #   displayManager.sddm.enable = true;
  #   displayManager.sddm.settings.General.DisplayServer = "x11-user";
  #   # displayManager = {
  #   #   lightdm.enable = true;
  #   #   sessionCommands = ''
  #   #     xset -dpms
  #   #     xset s blank
  #   #     xset r rate 350 50
  #   #     xset s 300
  #   #     ${pkgs.lightlocker}/bin/light-locker --idle-hint &
  #   #   '';
  #   # };
  #   libinput = {
  #     enable = true;
  #     touchpad.disableWhileTyping = true;
  #   };
  #   xserver = {
  #     enable = true;
  #     xkb = {
  #       layout = "us,ara";
  #       # variant = "digits";
  #       # options = "grp:alt_shift_toggle,caps:escape";
  #     };
  #   };
  # };

    services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";
      excludePackages = [pkgs.xterm];
      # videoDrivers = ["nvidia"];
      libinput.enable = true;
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
      # wayland = true;
      enableHidpi = true;
      theme = "chili";
      package = lib.mkForce  pkgs.sddm;
    };
  };

}
