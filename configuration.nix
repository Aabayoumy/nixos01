# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nfs.nix
  ];

  # Bootloader
boot.loader.systemd-boot.enable = true;
  # enable qemu-guest-agentfor proxmox
  services.qemuGuest.enable = true;

  system.autoUpgrade.enable = true;

  # Ensure nix flakes are enabled
  nix.package = pkgs.nixFlakes;
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    trusted-users = ["@wheel"];
  };
  # I'm sorry Stallman-taichou
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos01";
  networking.networkmanager.enable = true;

  # disable ipv6
  networking.enableIPv6  = false;

  # Newtwork firwall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  users.users.abayoumy = {
    isNormalUser = true;
    description = "Ahmed Bayoumy";
    hashedPassword = "${HASHED_PASSWORD}";
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
  time.timeZone = "Africa/Cairo"; # time zone
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
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
