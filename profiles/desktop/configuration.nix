{
  config,
  pkgs,
  systemSettings,
  ...
}: {
  imports = [
    ../server/configuration.nix
    (./. + "../../../system/wm" + ("/" + systemSettings.wm) + ".nix") # My window manager
    ../../system/style/stylix.nix
  ];
  environment.systemPackages = with pkgs; [
    #obs-studio-plugins.wlrobs
    arc-kde-theme
    cava
    cmatrix
    dash
    font-awesome
    gnumake
    grim
    imlib2
    kate
    lolcat
    lxappearance
    mako
    materia-kde-theme
    nitrogen
    ocs-url
    pavucontrol
    picom
    python311Packages.sparklines
    pywal
    rofi
    sddm-kcm
    swaybg
    waybar
    wdisplays
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.xfce4-terminal
    xorg.libX11.dev
    xorg.libXft
    xorg.libXinerama
    yad
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
