{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "abayoumy";
  home.homeDirectory = "/home/abayoumy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    cowsay
    starship
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

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
    shellAliases = {
      ls = "eza --header --icons --classify";
      ll = "eza --icons -l -T -L=1";
      la = "eza --icons -la -T -L=1";
      cat = "bat";
      htop = "btm";
      fd = "fd -Lu";
    };
  };
  home.file."~/.config/starship.toml".text = ''
      format = """\
    [](bg:#030B16 fg:#7DF9AA)\
    [󰀵 ](bg:#7DF9AA fg:#090c0c)\
    [](fg:#7DF9AA bg:#1C3A5E)\
    $time\
    [](fg:#1C3A5E bg:#3B76F0)\
    $directory\
    [](fg:#3B76F0 bg:#FCF392)\
    $git_branch\
    $git_status\
    $git_metrics\
    [](fg:#FCF392 bg:#030B16)\
    $character\
    """

    [directory]
    format = "[ ﱮ $path ]($style)"
    style = "fg:#E4E4E4 bg:#3B76F0"

    [git_branch]
    format = '[ $symbol$branch(:$remote_branch) ]($style)'
    symbol = "  "
    style = "fg:#1C3A5E bg:#FCF392"

    [git_status]
    format = '[$all_status]($style)'
    style = "fg:#1C3A5E bg:#FCF392"

    [git_metrics]
    format = "([+$added]($added_style))[]($added_style)"
    added_style = "fg:#1C3A5E bg:#FCF392"
    deleted_style = "fg:bright-red bg:235"
    disabled = false

    [hg_branch]
    format = "[ $symbol$branch ]($style)"
    symbol = " "

    [cmd_duration]
    format = "[  $duration ]($style)"
    style = "fg:bright-white bg:18"

    [character]
    success_symbol = '[ ➜](bold green) '
    error_symbol = '[ ✗](#E84D44) '

    [time]
    disabled = false
    time_format = "%R" # Hour:Minute Format
    style = "bg:#1d2230"
    format = '[[ 󱑍 $time ](bg:#1C3A5E fg:#8DFBD2)]($style)'
  '';

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.enableTransience = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
