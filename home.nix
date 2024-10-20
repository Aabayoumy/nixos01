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
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    # prezto.tmux.autoStartRemote = true;
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
    oh-my-zsh = {
      # 2023-07-28: oh-my-zsh doesn't have a plugin that shows me the exit code if it was not 0 (I'd probably have to define my own prompt)
      enable = true;
      theme = "kolo";
      plugins = [
        # List of plugins: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
        # "git" # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git -> overwrites with my own "ga" alias
        "fzf" # fuzzy auto-completion and key bindings https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/fzf
        "python" # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/python
        # conflicts with thefuck binding: "sudo" # Easily prefix your current or previous commands with sudo by pressing esc twice. https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
        "systemd" # useful aliases for systemd. https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemd
        "thefuck" # corrects your previous console command. https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/thefuck
        "tmux" # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/tmux
        "z" # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/z
      ];
    };
    history = {
      share = true; # false -> every terminal has it's own history
      size = 9999999; # Number of history lines to keep.
      save = 9999999; # Number of history lines to save.
      ignoreDups = true; # Do not enter command lines into the history list if they are duplicates of the previous event.
      extended = true; # Save timestamp into the history file.
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
