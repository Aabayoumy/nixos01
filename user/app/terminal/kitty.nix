{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    kitty
  ];
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = lib.mkForce "0.85";
      modify_font = "cell_width 90%";
    };
    extraConfig = with config.stylix.base16Scheme; ''
      foreground #${base05}
      background #${base00}
      color0  #${base03}
      color1  #${base08}
      color2  #${base0B}
      color3  #${base09}
      color4  #${base0D}
      color5  #${base0E}
      color6  #${base0C}
      color7  #${base06}
      color8  #${base04}
      color9  #${base08}
      color10 #${base0B}
      color11 #${base0A}
      color12 #${base0C}
      color13 #${base0E}
      color14 #${base0C}
      color15 #${base07}
      color16 #${base00}
      color17 #${base0F}
      color18 #${base0B}
      color19 #${base09}
      color20 #${base0D}
      color21 #${base0E}
      color22 #${base0C}
      color23 #${base06}
      cursor  #${base07}
      cursor_text_color #${base00}
      selection_foreground #${base01}
      selection_background #${base0D}
      url_color #${base0C}
      active_border_color #${base04}
      inactive_border_color #${base00}
      bell_border_color #${base03}
      tab_bar_style fade
      tab_fade 1
      active_tab_foreground   #${base04}
      active_tab_background   #${base00}
      active_tab_font_style   bold
      inactive_tab_foreground #${base07}
      inactive_tab_background #${base08}
      inactive_tab_font_style bold
      tab_bar_background #${base00}
  '';
  };
}
