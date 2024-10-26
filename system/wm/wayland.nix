{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nvidia.nix
    ./pipewire.nix
    ./dbus.nix
    ./fonts.nix
  ];

  environment.systemPackages = with pkgs; [
    wayland
    waydroid
    sddm
    (sddm-chili-theme.override {
      themeConfig = {
        background = config.stylix.image;
        ScreenWidth = 1920;
        ScreenHeight = 1080;
        blur = true;
        recursiveBlurLoops = 3;
        recursiveBlurRadius = 5;
      };
    })
  ];

  services = {
    xserver = {
      enable = false;
      xkb = {
        layout = "us,ara";
        variant = "";
      };
      excludePackages = [pkgs.xterm];
      # videoDrivers = ["nvidia"];
    };
    libinput.enable = true;
    dbus.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    gnome = {
      sushi.enable = true;
      gnome-keyring.enable = true;
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      theme = "chili";
    };
  };
}
