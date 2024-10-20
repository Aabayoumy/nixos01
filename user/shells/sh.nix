{
  config,
  pkgs,
  pkgs-stable,
  userSettings,
  ...
}: {
  imports = [
    ./tmux.nix
    ./zsh.nix
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
    ".config/starship.toml".source = ../../dot/starship.toml;
    ".config/fastfetch/config.jsonc".source = ../../dot/config.jsonc;
  };
}
