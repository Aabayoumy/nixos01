{pkgs, ...}: {
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
  ];

  # Configure X11
  services = { 
    displayManager.sddm.enable = true;
    displayManager.sddm.settings.General.DisplayServer = "x11-user";
    # displayManager = {
    #   lightdm.enable = true;
    #   sessionCommands = ''
    #     xset -dpms
    #     xset s blank
    #     xset r rate 350 50
    #     xset s 300
    #     ${pkgs.lightlocker}/bin/light-locker --idle-hint &
    #   '';
    # };
    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
    };
      xserver = {
      enable = true;
        xkb = { 
          layout = "us,ara";
          Variant = "digits";
          Options = "grp:alt_shift_toggle,caps:escape";
        }

    };
  };
}
