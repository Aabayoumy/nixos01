## Sourc https://github.com/librephoenix/nixos-config
{
  description = "Flake of ABayoumy";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-stable.url = "github:nix-community/home-manager/release-24.05";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";

    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      timezone = "Africa/Cairo"; # select timezone
      locale = "en_US.UTF-8"; # select locale
      wm = "hyprland";
      wmType =
        if ((systemSettings.wm == "hyprland") || (systemSettings.wm == "plasma"))
        then "wayland"
        else "x11";
      bootMode = "uefi"; # uefi or bios
      bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
      grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
      gpuType = "nvidia"; # amd, intel or nvidia; only makes some slight mods for amd at the moment
    };
    userSettings = rec {
      username = "abayoumy"; # username
      name = "Ahmed Bayoumy"; # name/identifier
      email = "abayoumy@outlook.com";
      theme = "nord";
      browser = "librewolf";
      wm = "hyprland";
      wmType =
        if ((userSettings.wm == "hyprland") || (userSettings.wm == "plasma"))
        then "wayland"
        else "x11";
      spawnBrowser =
        if ((userSettings.browser == "qutebrowser") && (wm == "hyprland"))
        then "qutebrowser-hyprprofile"
        else
          (
            if (userSettings.browser == "qutebrowser")
            then "qutebrowser --qt-flag enable-gpu-rasterization --qt-flag enable-native-gpu-memory-buffers --qt-flag num-raster-threads=4"
            else userSettings.browser
          ); # Browser spawn command must be specail for qb, since it doesn't gpu accelerate by default (why?)
      term = "kitty"; # Default terminal command;
      font = "Intel One Mono"; # Selected font
      fontPkg = pkgs.intel-one-mono; # Font package
      editor = "micro"; # Default editor;
      spawnEditor = editor;
    };

    # create patched nixpkgs
    nixpkgs-patched =
      (import inputs.nixpkgs { system = systemSettings.system; rocmSupport = (if systemSettings.gpu == "amd" then true else false); }).applyPatches {
        name = "nixpkgs-patched";
        src = inputs.nixpkgs;
        patches = [ #./patches/emacs-no-version-check.patch
                    #./patches/nixpkgs-348697.patch
                  ];
      };
      
    pkgs = (if ((systemSettings.profile == "server"))
      then
        pkgs-stable
      else
        (import nixpkgs-patched {
          system = systemSettings.system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
          };
          overlays = [ inputs.rust-overlay.overlays.default ];
        }));

    pkgs-stable = import inputs.nixpkgs-stable {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };

    pkgs-unstable = import inputs.nixpkgs-patched {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
      overlays = [ inputs.rust-overlay.overlays.default ];
    };


    # configure lib
    # use nixpkgs if running a server (homelab or worklab profile)
    # otherwise use patched nixos-unstable nixpkgs
    lib = (if ((systemSettings.profile == "server"))
      then
        inputs.nixpkgs-stable.lib
      else
        inputs.nixpkgs.lib);
    system = systemSettings.system;
    # use home-manager-stable if running a server (homelab or worklab profile)
    # otherwise use home-manager-unstable
    home-manager = (if ((systemSettings.profile == "server"))
      then
        inputs.home-manager-stable
      else
        inputs.home-manager-unstable);


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
}
