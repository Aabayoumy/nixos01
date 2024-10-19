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
  home.file.".config/starship.toml".text = ''
    #sorce https://raw.githubusercontent.com/typecraft-dev/dotfiles/refs/heads/master/starship/.config/starship.toml


    "$schema" = 'https://starship.rs/config-schema.json'

    format = """
    [](surface0)\
    $os\
    $username$hostname\
    [](bg:peach fg:surface0)\
    $directory\
    [](fg:peach bg:green)\
    $git_branch\
    $git_status\
    [](fg:green bg:teal)\
    $c\
    $rust\
    $golang\
    $nodejs\
    $php\
    $java\
    $kotlin\
    $haskell\
    $python\
    [](fg:teal bg:blue)\
    $docker_context\
    [](fg:blue bg:purple)\
    $time\
    [ ](fg:purple)\
    $line_break$character"""

    palette = 'catppuccin_mocha'

    [palettes.gruvbox_dark]
    color_fg0 = '#fbf1c7'
    color_bg1 = '#3c3836'
    color_bg3 = '#665c54'
    color_blue = '#458588'
    color_aqua = '#689d6a'
    color_green = '#98971a'
    color_orange = '#d65d0e'
    color_purple = '#b16286'
    color_red = '#cc241d'
    color_yellow = '#d79921'

    [palettes.catppuccin_mocha]
    rosewater = "#f5e0dc"
    flamingo = "#f2cdcd"
    pink = "#f5c2e7"
    orange = "#cba6f7"
    red = "#f38ba8"
    maroon = "#eba0ac"
    peach = "#fab387"
    yellow = "#f9e2af"
    green = "#a6e3a1"
    teal = "#94e2d5"
    sky = "#89dceb"
    sapphire = "#74c7ec"
    blue = "#89b4fa"
    lavender = "#b4befe"
    text = "#cdd6f4"
    subtext1 = "#bac2de"
    subtext0 = "#a6adc8"
    overlay2 = "#9399b2"
    overlay1 = "#7f849c"
    overlay0 = "#6c7086"
    surface2 = "#585b70"
    surface1 = "#45475a"
    surface0 = "#313244"
    base = "#1e1e2e"
    mantle = "#181825"
    crust = "#11111b"

    [os]
    disabled = false
    style = "bg:surface0 fg:text"

    [os.symbols]
    Windows = "󰍲"
    Ubuntu = "󰕈"
    SUSE = ""
    Raspbian = "󰐿"
    Mint = "󰣭"
    Macos = ""
    Manjaro = ""
    Linux = "󰌽"
    Gentoo = "󰣨"
    Fedora = "󰣛"
    Alpine = ""
    Amazon = ""
    Android = ""
    Arch = "󰣇"
    Artix = "󰣇"
    CentOS = ""
    Debian = "󰣚"
    Redhat = "󱄛"
    RedHatEnterprise = "󱄛"

    [username]
    show_always = true
    style_user = "bg:surface0 fg:text"
    style_root = "bg:surface0 fg:text"
    format = '[ $user]($style)'

    [hostname]
    ssh_only = true
    style = "bg:surface0 fg:text"
    format = '[@$hostname ]($style)'

    [directory]
    style = "fg:mantle bg:peach"
    format = "[ $path ]($style)"
    truncation_length = 3
    truncation_symbol = "…/"

    [directory.substitutions]
    "Documents" = "󰈙 "
    "Downloads" = " "
    "Music" = "󰝚 "
    "Pictures" = " "
    "Developer" = "󰲋 "

    [git_branch]
    symbol = ""
    style = "bg:teal"
    format = '[[ $symbol $branch ](fg:base bg:green)]($style)'

    [git_status]
    style = "bg:teal"
    format = '[[($all_status$ahead_behind )](fg:base bg:green)]($style)'

    [nodejs]
    symbol = ""
    style = "bg:teal"
    format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

    [c]
    symbol = " "
    style = "bg:teal"
    format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

    [rust]
    symbol = ""
    style = "bg:teal"
    format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

    [golang]
    symbol = ""
    style = "bg:teal"
    format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

    [php]
    symbol = ""
    style = "bg:teal"
    format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

    [java]
    symbol = " "
    style = "bg:teal"
    format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

    [kotlin]
    symbol = ""
    style = "bg:teal"
    format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

    [haskell]
    symbol = ""
    style = "bg:teal"
    format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

    [python]
    symbol = ""
    style = "bg:teal"
    format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

    [docker_context]
    symbol = ""
    style = "bg:mantle"
    format = '[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)'

    [time]
    disabled = false
    time_format = "%R"
    style = "bg:peach"
    format = '[[  $time ](fg:mantle bg:purple)]($style)'

    [line_break]
    disabled = false

    [character]
    disabled = false
    success_symbol = '[](bold fg:green)'
    error_symbol = '[](bold fg:red)'
    vimcmd_symbol = '[](bold fg:creen)'
    vimcmd_replace_one_symbol = '[](bold fg:purple)'
    vimcmd_replace_symbol = '[](bold fg:purple)'
    vimcmd_visual_symbol = '[](bold fg:lavender)'

  '';

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.starship.enableTransience = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
