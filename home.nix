{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./tmux.nix

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
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    prezto.tmux.autoStartRemote = true;
    shellAliases = {
      ls = "eza --header --icons --classify";
      ll = "eza --icons -l -T -L=1";
      la = "eza --icons -la -T -L=1";
      cat = "bat";
      htop = "btm";
      fd = "fd -Lu";
      cal = "gcal --starting-day=6";
      update = "nix-channel --update && nix-env -u";
      weather = "curl v2.wttr.in";
    };
  };

  home.file = {
    ".config/starship.toml".source = ./starship.toml;

    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.enableTransience = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
