{
  description = "Flake of ABayoumy";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    # System application(s)
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Window Manager(s) + Extensions
    xmonad = {
      url = "github:xmonad/xmonad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xmonad-contrib.url = "github:xmonad/xmonad-contrib";

    xmonad-contexts = {
      url = "github:Procrat/xmonad-contexts";
      flake = false;
    };
    pyprland.url = "github:hyprland-community/pyprland";

    stylix.url = "github:danth/stylix";

    blocklist-hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    home-manager,
    nixpkgs,
    alejandra,
    ...
  }: let
    # ---- SYSTEM SETTINGS ---- #
    systemSettings = {
      system = "x86_64-linux"; # system arch
      hostname = "nixos01"; # hostname
      profile = "desktop"; # select a profile defined from my profiles directory
      wm = "kde";
      wmType = "x11";
      timezone = "Africa/Cairo"; # select timezone
      locale = "en_US.UTF-8"; # select locale
      bootMode = "uefi"; # uefi or bios
      bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
      grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
      gpuType = "amd"; # amd, intel or nvidia; only makes some slight mods for amd at the moment
    };
    userSettings = rec {
      username = "abayoumy"; # username
      name = "Ahmed Bayoumy"; # name/identifier
      email = "abayoumy@outlook.com";
      theme = "Dracula";
      browser = "firefox";
      wm = "kde";
      spawnBrowser = browser ; # Browser spawn command must be specail for qb, since it doesn't gpu accelerate by default (why?)
      term = "kitty"; # Default terminal command;
      font = "Intel One Mono"; # Selected font
      fontPkg = pkgs.intel-one-mono; # Font package
      editor = "micro"; # Default editor;
      spawnEditor = editor;
    };

    pkgs-stable = import inputs.nixpkgs-stable {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
    pkgs-nwg-dock-hyprland = import inputs.nwg-dock-hyprland-pin-nixpkgs {
      system = systemSettings.system;
    };
    pkgs = pkgs-stable;
    lib = inputs.nixpkgs.lib;
    system = systemSettings.system;
  in {
    nixosConfigurations = {
      nixos01 = lib.nixosSystem {
        inherit system;
        specialArgs = {
          # pass config variables from above
          inherit pkgs-stable;
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
        };
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
          {environment.systemPackages = [alejandra.defaultPackage.${system}];}
        ];
      };
    };
    homeConfigurations = {
      abayoumy = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          # pass config variables from above
          inherit pkgs-stable;
          inherit systemSettings;
          inherit pkgs-nwg-dock-hyprland;
          inherit userSettings;
          inherit inputs;
        };
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix") # load home.nix from selected PROFILE
        ];
      };
    };
  };
}
