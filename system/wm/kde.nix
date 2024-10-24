# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  # Import x11 config
  imports = [
    ./x11.nix
    ./pipewire.nix
    ./dbus.nix
  ];
  
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Install firefox.
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    kitty
  ];
  system.stateVersion = "24.05"; # Did you read the comment?

}
