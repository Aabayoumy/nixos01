{
  description = "Flake of ABayoumy";

  outputs = inputs @ {
    self,
    home-manager,
    nixpkgs,
    alejandra,
    ...
  }: let
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${"x86_64-linux"};
    # ---- SYSTEM SETTINGS ---- #
    systemSettings = {
      system = "x86_64-linux"; # system arch
      hostname = "snowfire"; # hostname
      profile = "personal"; # select a profile defined from my profiles directory
      timezone = "America/Chicago"; # select timezone
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
    };
    pkgs-stable = import inputs.nixpkgs-stable {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
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
        modules = [./home.nix];
      };
    };
  };
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    # use the following for unstable:
    # nixpkgs.url = "nixpkgs/nixos-unstable";

    # or any branch you want:
    # nixpkgs.url = "nixpkgs/{BRANCH-NAME}";
  };
}
