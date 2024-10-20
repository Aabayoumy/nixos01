{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./shells/tmux.nix
    ./shells/zsh.nix
  ];
  # ] ++ (if config.users.users.abayoumy.shell == pkgs.zsh then [ ./shells/zsh.nix ] else []);

  home.username = "abayoumy";
  home.homeDirectory = "/home/abayoumy";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    cowsay
    starship
    gcal
    bat
    fzf
    fd
    eza
    thefuck
  ];

  home.sessionVariables = {
    EDITOR = "micro";
    ZSH_TMUX_AUTOSTART = "true";
    ZSH_TMUX_AUTOSTART_ONCE = "true";
    ZSH_TMUX_AUTOQUIT = "true";
    ZSH_TMUX_AUTOCONNECT = "true";
    ZSH_TMUX_AUTONAME_SESSION = "abayoumy";
  };

  home.file = {
    ".config/starship.toml".source = ./dot/starship.toml;
    ".config/fastfetch/config.jsonc".source = ./dot/config.jsonc;
  };

  programs.home-manager.enable = true;
}
