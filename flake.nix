{
  description = "Flake of ABayoumy";

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
      wm = "hyprland";
      wmType =
        if ((wm == "hyprland") || (wm == "plasma"))
        then "wayland"
        else "x11";
      browser = "firefox";
      term = "kitty"; # Default terminal command;
      font = "Intel One Mono"; # Selected font
      fontPkg = pkgs.intel-one-mono; # Font package
      editor = "micro"; # Default editor;
      theme = "nord";
    };
    pkgs-stable = import inputs.nixpkgs-stable {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
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
          inherit userSettings;
          inherit inputs;
        };
        modules = [
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix") # load home.nix from selected PROFILE
        ];
      };
    };
  };
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    hyprland = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/Hyprland.git";
      submodules = true;
      rev = "0f594732b063a90d44df8c5d402d658f27471dfe"; #v0.43.0
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprland-plugins.git";
      rev = "b73d7b901d8cb1172dd25c7b7159f0242c625a77"; #v0.43.0
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprlock.git";
      rev = "73b0fc26c0e2f6f82f9d9f5b02e660a958902763";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprgrass.url = "github:horriblename/hyprgrass/427690aec574fec75f5b7b800ac4a0b4c8e4b1d5";
    hyprgrass.inputs.hyprland.follows = "hyprland";
    stylix.url = "github:danth/stylix";

    blocklist-hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
  };
}
