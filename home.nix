{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./shells/tmux.nix
    ./shells/zsh.nix
    # etc..
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "abayoumy";
  home.homeDirectory = "/home/abayoumy";

  home.stateVersion = "24.05"; # Please read the comment before changing.

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/abayoumy/etc/profile.d/hm-session-vars.sh
  #
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

    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  programs.fastfetch.enable = true;
  programs.starship.enable = true;
  programs.starship.enableTransience = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
