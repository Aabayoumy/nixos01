{pkgs, ...}: {
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
  ];

  # Configure X11
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = ",digits";
    xkbOptions = "grp:alt_shift_toggle,caps:escape";
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
  };
  services.displayManager.sddm.enable = true;

}
