# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  systemSettings,
  userSettings,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nfs.nix
  ];

  # Bootloader
  # Use systemd-boot if uefi, default to grub otherwise
  boot.loader.systemd-boot.enable =
    if (systemSettings.bootMode == "uefi")
    then true
    else false;
  boot.loader.efi.canTouchEfiVariables =
    if (systemSettings.bootMode == "uefi")
    then true
    else false;
  boot.loader.efi.efiSysMountPoint = systemSettings.bootMountPath; # does nothing if running bios rather than uefi
  boot.loader.grub.enable =
    if (systemSettings.bootMode == "uefi")
    then false
    else true;
  boot.loader.grub.device = systemSettings.grubDevice; # does nothing if running uefi rather than bios

  # enable qemu-guest-agentfor proxmox
  services.qemuGuest.enable = true;
  system.autoUpgrade.enable = true;

  # Fix nix path
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=$HOME/.dotfiles/system/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  # Ensure nix flakes are enabled
  nix.package = pkgs.nixFlakes;
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    trusted-users = ["@wheel"];
  };
  # I'm sorry Stallman-taichou
  nixpkgs.config.allowUnfree = true;

  networking.hostName = systemSettings.hostname;
  networking.networkmanager.enable = true;

  # disable ipv6
  networking.enableIPv6  = false;

  # Newtwork firwall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = "Ahmed Bayoumy";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "plugdev"
      "input"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINr7JrFzSbXZlgH+M+QS6TvpbIEHL7S/76BAflXDnF6J gb-laptop"
    ];
  };
  environment.shells = with pkgs; [zsh];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  fonts.fontDir.enable = true;

  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };
  services.timesyncd.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Timezone and locale
  time.timeZone = systemSettings.timezone; # time zone
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = with pkgs; [
    nfs-utils
    zsh
    fd
    starship
    gcal
    micro
    fastfetch
    btop
    cryptsetup
    home-manager
    xdg-user-dirs
    coreutils
    curl
    eza
    thefuck
    findutils
    fzf
    git
    gnumake
    gnutar
    htop
    iproute2
    jq
    killall
    less
    libuuid
    linuxHeaders
    mkpasswd
    netcat
    nettools
    nmap
    openssl
    python3
    python3Packages.pip
    ripgrep
    rsync
    spice-vdagent
    ssh-import-id
    strace
    sysstat
    tealdeer
    tree
    tzdata
    unzip
    util-linux
    wget
    aria2
    yq
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
  system.stateVersion = "24.05"; # Did you read the comment?
}
