{
  inputs,
  config,
  lib,
  pkgs,
  userSettings,
  systemSettings,
  ...
}: {
  imports = [
    ../app/terminal/kitty.nix
  ];
  # gtk.cursorTheme = {
  #   package = pkgs.quintom-cursor-theme;
  #   name =
  #     if (config.stylix.polarity == "light")
  #     then "Quintom_Ink"
  #     else "Quintom_Snow";
  #   size = 36;
  # };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {};
    extraConfig =
      ''          
        exec-once = dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland
      #   exec-once = hyprctl setcursor ''
      # + config.gtk.cursorTheme.name
      # + " "
      # + builtins.toString config.gtk.cursorTheme.size
      # + ''          
          
        env = XDG_CURRENT_DESKTOP,Hyprland
        env = XDG_SESSION_DESKTOP,Hyprland
        env = XDG_SESSION_TYPE,wayland
        env = WLR_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1
        env = GDK_BACKEND,wayland,x11,*
        env = QT_QPA_PLATFORM,wayland;xcb
        env = QT_QPA_PLATFORMTHEME,qt5ct
        env = QT_AUTO_SCREEN_SCALE_FACTOR,1
        env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
        env = CLUTTER_BACKEND,wayland
        env = GDK_PIXBUF_MODULE_FILE,${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
          
        exec-once = hyprprofile Default
          
        exec-once = ydotoold
        #exec-once = STEAM_FRAME_FORCE_CLOSE=1 steam -silent
        exec-once = nm-applet
        exec-once = blueman-applet
        exec-once = GOMAXPROCS=1 syncthing --no-browser
        exec-once = protonmail-bridge --noninteractive
        exec-once = waybar
          
        exec-once = hypridle
        exec-once = sleep 5 && libinput-gestures
        exec-once = obs-notification-mute-daemon
          
        exec-once = hyprpaper
          
        bezier = wind, 0.05, 0.9, 0.1, 1.05
        bezier = winIn, 0.1, 1.1, 0.1, 1.0
        bezier = winOut, 0.3, -0.3, 0, 1
        bezier = liner, 1, 1, 1, 1
        bezier = linear, 0.0, 0.0, 1.0, 1.0
          
        animations {
             enabled = yes
             animation = windowsIn, 1, 6, winIn, popin
             animation = windowsOut, 1, 5, winOut, popin
             animation = windowsMove, 1, 5, wind, slide
             animation = border, 1, 10, default
             animation = borderangle, 1, 100, linear, loop
             animation = fade, 1, 10, default
             animation = workspaces, 1, 5, wind
             animation = windows, 1, 6, wind, slide
             animation = specialWorkspace, 1, 6, default, slidefadevert -50%
        }
          
        general {
          layout = master
          border_size = 5
          col.active_border = 0xff''
      + config.lib.stylix.colors.base08
      + " "
      + ''0xff''
      + config.lib.stylix.colors.base09
      + " "
      + ''0xff''
      + config.lib.stylix.colors.base0A
      + " "
      + ''0xff''
      + config.lib.stylix.colors.base0B
      + " "
      + ''0xff''
      + config.lib.stylix.colors.base0C
      + " "
      + ''0xff''
      + config.lib.stylix.colors.base0D
      + " "
      + ''0xff''
      + config.lib.stylix.colors.base0E
      + " "
      + ''0xff''
      + config.lib.stylix.colors.base0F
      + " "
      + ''        270deg
          
                col.inactive_border = 0xaa''
      + config.lib.stylix.colors.base02
      + ''          
          
             resize_on_border = true
             gaps_in = 7
             gaps_out = 7
        }
          
        cursor {
          no_warps = false
          inactive_timeout = 30
        }
          
               bind=SUPER,SPACE,fullscreen,1
               bind=SUPERSHIFT,F,fullscreen,0
               bind=SUPER,Y,workspaceopt,allfloat
               bind=ALT,TAB,cyclenext
               bind=ALT,TAB,bringactivetotop
               bind=ALTSHIFT,TAB,cyclenext,prev
               bind=ALTSHIFT,TAB,bringactivetotop
               bind=SUPER,TAB,hyprexpo:expo, toggleoverview
               bind=SUPER,V,exec,wl-copy $(wl-paste | tr '\n' ' ')
               bind=SUPERSHIFT,T,exec,screenshot-ocr
               bind=CTRLALT,Delete,exec,hyprctl kill
               bind=SUPERSHIFT,K,exec,hyprctl kill
          
               bind=,code:172,exec,lollypop -t
               bind=,code:208,exec,lollypop -t
               bind=,code:209,exec,lollypop -t
               bind=,code:174,exec,lollypop -s
               bind=,code:171,exec,lollypop -n
               bind=,code:173,exec,lollypop -p
          
               bind = SUPER,R,pass,^(com\.obsproject\.Studio)$
               bind = SUPERSHIFT,R,pass,^(com\.obsproject\.Studio)$
          
               bind=SUPER,RETURN,exec,''
      + userSettings.term
      + ''          
          
        bind=SUPERSHIFT,RETURN,exec,''
      + userSettings.term
      + " "
      + ''        --class float_term
          
              bind=SUPER,A,exec,''
      + userSettings.spawnEditor
      + ''          
          
        bind=SUPER,S,exec,''
      + userSettings.spawnBrowser
      + ''          
          
        bind=SUPERCTRL,S,exec,container-open # qutebrowser only
          
        bind=SUPERCTRL,P,pin
          
        bind=SUPER,X,exec,fnottctl dismiss
        bind=SUPERSHIFT,X,exec,fnottctl dismiss all
        bind=SUPER,Q,killactive
        bind=SUPERSHIFT,Q,exit
        bindm=SUPER,mouse:272,movewindow
        bindm=SUPER,mouse:273,resizewindow
        bind=SUPER,T,togglefloating
        bind=SUPER,G,exec,hyprctl dispatch focusworkspaceoncurrentmonitor 9 && pegasus-fe;
        bind=,code:148,exec,''
      + userSettings.term
      + " "
      + ''        -e numbat
          
               bind=,code:107,exec,grim -g "$(slurp)"
               bind=SHIFT,code:107,exec,grim -g "$(slurp -o)"
               bind=SUPER,code:107,exec,grim
               bind=CTRL,code:107,exec,grim -g "$(slurp)" - | wl-copy
               bind=SHIFTCTRL,code:107,exec,grim -g "$(slurp -o)" - | wl-copy
               bind=SUPERCTRL,code:107,exec,grim - | wl-copy
          
               bind=,code:122,exec,swayosd-client --output-volume lower
               bind=,code:123,exec,swayosd-client --output-volume raise
               bind=,code:121,exec,swayosd-client --output-volume mute-toggle
               bind=,code:256,exec,swayosd-client --output-volume mute-toggle
               bind=SHIFT,code:122,exec,swayosd-client --output-volume lower
               bind=SHIFT,code:123,exec,swayosd-client --output-volume raise
               bind=,code:232,exec,swayosd-client --brightness lower
               bind=,code:233,exec,swayosd-client --brightness raise
               bind=,code:237,exec,brightnessctl --device='asus::kbd_backlight' set 1-
               bind=,code:238,exec,brightnessctl --device='asus::kbd_backlight' set +1
               bind=,code:255,exec,airplane-mode
               bind=SUPER,C,exec,wl-copy $(hyprpicker)
          
               bind=SUPERSHIFT,S,exec,systemctl suspend
               bindl=,switch:on:Lid Switch,exec,loginctl lock-session
               bind=SUPERCTRL,L,exec,loginctl lock-session
          
               bind=SUPER,H,movefocus,l
               bind=SUPER,J,movefocus,d
               bind=SUPER,K,movefocus,u
               bind=SUPER,L,movefocus,r
          
               bind=SUPERSHIFT,H,movewindow,l
               bind=SUPERSHIFT,J,movewindow,d
               bind=SUPERSHIFT,K,movewindow,u
               bind=SUPERSHIFT,L,movewindow,r
          
               bind=SUPER,1,focusworkspaceoncurrentmonitor,1
               bind=SUPER,2,focusworkspaceoncurrentmonitor,2
               bind=SUPER,3,focusworkspaceoncurrentmonitor,3
               bind=SUPER,4,focusworkspaceoncurrentmonitor,4
               bind=SUPER,5,focusworkspaceoncurrentmonitor,5
               bind=SUPER,6,focusworkspaceoncurrentmonitor,6
               bind=SUPER,7,focusworkspaceoncurrentmonitor,7
               bind=SUPER,8,focusworkspaceoncurrentmonitor,8
               bind=SUPER,9,focusworkspaceoncurrentmonitor,9
          
               bind=SUPERCTRL,right,exec,hyprnome
               bind=SUPERCTRL,left,exec,hyprnome --previous
               bind=SUPERSHIFT,right,exec,hyprnome --move
               bind=SUPERSHIFT,left,exec,hyprnome --previous --move
          
               bind=SUPERSHIFT,1,movetoworkspace,1
               bind=SUPERSHIFT,2,movetoworkspace,2
               bind=SUPERSHIFT,3,movetoworkspace,3
               bind=SUPERSHIFT,4,movetoworkspace,4
               bind=SUPERSHIFT,5,movetoworkspace,5
               bind=SUPERSHIFT,6,movetoworkspace,6
               bind=SUPERSHIFT,7,movetoworkspace,7
               bind=SUPERSHIFT,8,movetoworkspace,8
               bind=SUPERSHIFT,9,movetoworkspace,9
          
               bind=SUPER,Z,exec,if hyprctl clients | grep scratch_term; then echo "scratch_term respawn not needed"; else alacritty --class scratch_term; fi
               bind=SUPER,Z,togglespecialworkspace,scratch_term
               bind=SUPER,F,exec,if hyprctl clients | grep scratch_ranger; then echo "scratch_ranger respawn not needed"; else kitty --class scratch_ranger -e ranger; fi
               bind=SUPER,F,togglespecialworkspace,scratch_ranger
               bind=SUPER,N,exec,if hyprctl clients | grep scratch_numbat; then echo "scratch_ranger respawn not needed"; else alacritty --class scratch_numbat -e numbat; fi
               bind=SUPER,N,togglespecialworkspace,scratch_numbat
               bind=SUPER,M,exec,if hyprctl clients | grep lollypop; then echo "scratch_ranger respawn not needed"; else lollypop; fi
               bind=SUPER,M,togglespecialworkspace,scratch_music
               bind=SUPER,B,exec,if hyprctl clients | grep scratch_btm; then echo "scratch_ranger respawn not needed"; else alacritty --class scratch_btm -e btm; fi
               bind=SUPER,B,togglespecialworkspace,scratch_btm
               bind=SUPER,D,exec,if hyprctl clients | grep Element; then echo "scratch_ranger respawn not needed"; else element-desktop; fi
               bind=SUPER,D,togglespecialworkspace,scratch_element
               bind=SUPER,code:172,exec,togglespecialworkspace,scratch_pavucontrol
               bind=SUPER,code:172,exec,if hyprctl clients | grep pavucontrol; then echo "scratch_ranger respawn not needed"; else pavucontrol; fi
          
               $scratchpadsize = size 80% 85%
          
               $scratch_term = class:^(scratch_term)$
               windowrulev2 = float,$scratch_term
               windowrulev2 = $scratchpadsize,$scratch_term
               windowrulev2 = workspace special:scratch_term ,$scratch_term
               windowrulev2 = center,$scratch_term
          
               $float_term = class:^(float_term)$
               windowrulev2 = float,$float_term
               windowrulev2 = center,$float_term
          
               $scratch_ranger = class:^(scratch_ranger)$
               windowrulev2 = float,$scratch_ranger
               windowrulev2 = $scratchpadsize,$scratch_ranger
               windowrulev2 = workspace special:scratch_ranger silent,$scratch_ranger
               windowrulev2 = center,$scratch_ranger
          
               $scratch_numbat = class:^(scratch_numbat)$
               windowrulev2 = float,$scratch_numbat
               windowrulev2 = $scratchpadsize,$scratch_numbat
               windowrulev2 = workspace special:scratch_numbat silent,$scratch_numbat
               windowrulev2 = center,$scratch_numbat
          
               $scratch_btm = class:^(scratch_btm)$
               windowrulev2 = float,$scratch_btm
               windowrulev2 = $scratchpadsize,$scratch_btm
               windowrulev2 = workspace special:scratch_btm silent,$scratch_btm
               windowrulev2 = center,$scratch_btm
          
               windowrulev2 = float,class:^(Element)$
               windowrulev2 = size 85% 90%,class:^(Element)$
               windowrulev2 = workspace special:scratch_element silent,class:^(Element)$
               windowrulev2 = center,class:^(Element)$
          
               windowrulev2 = float,class:^(lollypop)$
               windowrulev2 = size 85% 90%,class:^(lollypop)$
               windowrulev2 = workspace special:scratch_music silent,class:^(lollypop)$
               windowrulev2 = center,class:^(lollypop)$
          
               $savetodisk = title:^(Save to Disk)$
               windowrulev2 = float,$savetodisk
               windowrulev2 = size 70% 75%,$savetodisk
               windowrulev2 = center,$savetodisk
          
               $pavucontrol = class:^(org.pulseaudio.pavucontrol)$
               windowrulev2 = float,$pavucontrol
               windowrulev2 = size 86% 40%,$pavucontrol
               windowrulev2 = move 50% 6%,$pavucontrol
               windowrulev2 = workspace special silent,$pavucontrol
               windowrulev2 = opacity 0.80,$pavucontrol
          
               $miniframe = title:\*Minibuf.*
               windowrulev2 = float,$miniframe
               windowrulev2 = size 64% 50%,$miniframe
               windowrulev2 = move 18% 25%,$miniframe
               windowrulev2 = animation popin 1 20,$miniframe
          
               windowrulev2 = float,class:^(pokefinder)$
               windowrulev2 = float,class:^(Waydroid)$
          
               windowrulev2 = float,title:^(Blender Render)$
               windowrulev2 = size 86% 85%,title:^(Blender Render)$
               windowrulev2 = center,title:^(Blender Render)$
               windowrulev2 = float,class:^(org.inkscape.Inkscape)$
               windowrulev2 = float,class:^(pinta)$
               windowrulev2 = float,class:^(krita)$
               windowrulev2 = float,class:^(Gimp)
               windowrulev2 = float,class:^(Gimp)
               windowrulev2 = float,class:^(libresprite)$
          
               windowrulev2 = opacity 0.80,title:ORUI
          
               windowrulev2 = opacity 1.0,class:^(org.qutebrowser.qutebrowser),fullscreen:1
               windowrulev2 = opacity 0.85,class:^(Element)$
               windowrulev2 = opacity 0.85,class:^(lollypop)$
               windowrulev2 = opacity 1.0,class:^(Brave-browser),fullscreen:1
               windowrulev2 = opacity 1.0,class:^(librewolf),fullscreen:1
               windowrulev2 = opacity 0.85,title:^(My Local Dashboard Awesome Homepage - qutebrowser)$
               windowrulev2 = opacity 0.85,title:\[.*\] - My Local Dashboard Awesome Homepage
               windowrulev2 = opacity 0.85,class:^(org.keepassxc.KeePassXC)$
               windowrulev2 = opacity 0.85,class:^(org.gnome.Nautilus)$
               windowrulev2 = opacity 0.85,class:^(org.gnome.Nautilus)$
          
               windowrulev2 = opacity 0.85,initialTitle:^(Notes)$,initialClass:^(Brave-browser)$
          
               layerrule = blur,waybar
               layerrule = xray,waybar
               blurls = waybar
               layerrule = blur,gtk-layer-shell
               layerrule = xray,gtk-layer-shell
               blurls = gtk-layer-shell
          
               bind=SUPER,equal, exec, hyprctl keyword cursor:zoom_factor "$(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 + 0.5}')"
               bind=SUPER,minus, exec, hyprctl keyword cursor:zoom_factor "$(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 - 0.5}')"
          
               bind=SUPER,I,exec,networkmanager_dmenu
               bind=SUPER,P,exec,keepmenu
               bind=SUPERSHIFT,P,exec,hyprprofile-dmenu
               bind=SUPERCTRL,R,exec,phoenix refresh
          
               # 3 monitor setup
               monitor=eDP-1,1920x1080@300,900x1080,1
               monitor=HDMI-A-1,1920x1080,1920x0,1
               monitor=DP-1,1920x1080,0x0,1
          
               # hdmi tv
               #monitor=eDP-1,1920x1080,1920x0,1
               #monitor=HDMI-A-1,1920x1080,0x0,1
          
               # hdmi work projector
               #monitor=eDP-1,1920x1080,1920x0,1
               #monitor=HDMI-A-1,1920x1200,0x0,1
          
               xwayland {
                 force_zero_scaling = true
               }
          
               binds {
                 movefocus_cycles_fullscreen = false
               }
          
               input {
                 kb_layout = us
                 kb_options = caps:escape
                 repeat_delay = 350
                 repeat_rate = 50
                 accel_profile = adaptive
                 follow_mouse = 2
                 float_switch_override_focus = 0
               }
          
               misc {
                 disable_hyprland_logo = true
                 mouse_move_enables_dpms = true
                 enable_swallow = true
                 swallow_regex = (scratch_term)|(Alacritty)|(kitty)
                 font_family = ''
      + userSettings.font
      + ''          
          
        }
        decoration {
          rounding = 8
          dim_special = 0.0
          blur {
            enabled = true
            size = 5
            passes = 2
            ignore_opacity = true
            contrast = 1.17
            brightness = ''
      + (
        if (config.stylix.polarity == "dark")
        then "0.8"
        else "1.25"
      )
      + ''

            xray = true
            special = true
            popups = true
          }
        }

      '';
    xwayland = {enable = true;};
    systemd.enable = true;
  };

  home.packages = with pkgs; [
    alacritty
    kitty
    feh
    killall
    polkit_gnome
    papirus-icon-theme
    libva-utils
    libinput-gestures
    gsettings-desktop-schemas
    (
      hyprnome.override (oldAttrs: {
        rustPlatform =
          oldAttrs.rustPlatform
          // {
            buildRustPackage = args:
              oldAttrs.rustPlatform.buildRustPackage (args
                // {
                  pname = "hyprnome";
                  version = "unstable-2024-05-06";
                  src = fetchFromGitHub {
                    owner = "donovanglover";
                    repo = "hyprnome";
                    rev = "f185e6dbd7cfcb3ecc11471fab7d2be374bd5b28";
                    hash = "sha256-tmko/bnGdYOMTIGljJ6T8d76NPLkHAfae6P6G2Aa2Qo=";
                  };
                  cargoDeps = oldAttrs.cargoDeps.overrideAttrs (oldAttrs: rec {
                    name = "${pname}-vendor.tar.gz";
                    inherit src;
                    outputHash = "sha256-cQwAGNKTfJTnXDI3IMJQ2583NEIZE7GScW7TsgnKrKs=";
                  });
                  cargoHash = "sha256-cQwAGNKTfJTnXDI3IMJQ2583NEIZE7GScW7TsgnKrKs=";
                });
          };
      })
    )
    gnome.zenity
    wlr-randr
    wtype
    ydotool
    wl-clipboard
    hyprland-protocols
    hyprpicker
    hyprlock
    hypridle
    hyprpaper
    fnott
    keepmenu
    pinentry-gnome3
    wev
    grim
    slurp
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    wlsunset
    pavucontrol
    pamixer
    tesseract4
    (pkgs.writeScriptBin "screenshot-ocr" ''
      #!/bin/sh
      imgname="/tmp/screenshot-ocr-$(date +%Y%m%d%H%M%S).png"
      txtname="/tmp/screenshot-ocr-$(date +%Y%m%d%H%M%S)"
      txtfname=$txtname.txt
      grim -g "$(slurp)" $imgname;
      tesseract $imgname $txtname;
      wl-copy -n < $txtfname
    '')
    (pkgs.writeScriptBin "sct" ''
      #!/bin/sh
      killall wlsunset &> /dev/null;
      if [ $# -eq 1 ]; then
        temphigh=$(( $1 + 1 ))
        templow=$1
        wlsunset -t $templow -T $temphigh &> /dev/null &
      else
        killall wlsunset &> /dev/null;
      fi
    '')
    (pkgs.writeScriptBin "obs-notification-mute-daemon" ''
      #!/bin/sh
      while true; do
        if pgrep -x .obs-wrapped > /dev/null;
          then
            pkill -STOP fnott;
          else
            pkill -CONT fnott;
        fi
        sleep 10;
      done
    '')
    (pkgs.writeScriptBin "suspend-unless-render" ''
      #!/bin/sh
      if pgrep -x nixos-rebuild > /dev/null || pgrep -x home-manager > /dev/null || pgrep -x kdenlive > /dev/null || pgrep -x FL64.exe > /dev/null || pgrep -x blender > /dev/null || pgrep -x flatpak > /dev/null;
      then echo "Shouldn't suspend"; sleep 10; else echo "Should suspend"; systemctl suspend; fi
    '')
  ];
  home.file.".config/hypr/hyprlock.conf".text =
    ''        
      background {
        monitor =
        path = screenshot
        
        # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
        blur_passes = 4
        blur_size = 5
        noise = 0.0117
        contrast = 0.8916
        brightness = 0.8172
        vibrancy = 0.1696
        vibrancy_darkness = 0.0
      }
        
      # doesn't work yet
      image {
        monitor =
        path = /home/emmet/.dotfiles/user/wm/hyprland/nix-dark.png
        size = 150 # lesser side if not 1:1 ratio
        rounding = -1 # negative values mean circle
        border_size = 0
        rotate = 0 # degrees, counter-clockwise
        
        position = 0, 200
        halign = center
        valign = center
      }
        
      input-field {
        monitor =
        size = 200, 50
        outline_thickness = 3
        dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = false
        dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
        outer_color = rgb(''
    + config.lib.stylix.colors.base07-rgb-r
    + '',''
    + config.lib.stylix.colors.base07-rgb-g
    + '', ''
    + config.lib.stylix.colors.base07-rgb-b
    + ''      )
            inner_color = rgb(''
    + config.lib.stylix.colors.base00-rgb-r
    + '',''
    + config.lib.stylix.colors.base00-rgb-g
    + '', ''
    + config.lib.stylix.colors.base00-rgb-b
    + ''      )
            font_color = rgb(''
    + config.lib.stylix.colors.base07-rgb-r
    + '',''
    + config.lib.stylix.colors.base07-rgb-g
    + '', ''
    + config.lib.stylix.colors.base07-rgb-b
    + ''      )
            fade_on_empty = true
            fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
            placeholder_text = <i>Input Password...</i> # Text rendered in the input box when it's empty.
            hide_input = false
            rounding = -1 # -1 means complete rounding (circle/oval)
            check_color = rgb(''
    + config.lib.stylix.colors.base0A-rgb-r
    + '',''
    + config.lib.stylix.colors.base0A-rgb-g
    + '', ''
    + config.lib.stylix.colors.base0A-rgb-b
    + ''      )
            fail_color = rgb(''
    + config.lib.stylix.colors.base08-rgb-r
    + '',''
    + config.lib.stylix.colors.base08-rgb-g
    + '', ''
    + config.lib.stylix.colors.base08-rgb-b
    + ''      )
            fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
            fail_transition = 300 # transition time in ms between normal outer_color and fail_color
            capslock_color = -1
            numlock_color = -1
            bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
            invert_numlock = false # change color if numlock is off
            swap_font_color = false # see below
        
            position = 0, -20
            halign = center
            valign = center
          }
        
          label {
            monitor =
            text = Hello, Emmet
            color = rgb(''
    + config.lib.stylix.colors.base07-rgb-r
    + '',''
    + config.lib.stylix.colors.base07-rgb-g
    + '', ''
    + config.lib.stylix.colors.base07-rgb-b
    + ''      )
            font_size = 25
            font_family = ''
    + userSettings.font
    + ''        
        
        rotate = 0 # degrees, counter-clockwise
        
        position = 0, 160
        halign = center
        valign = center
      }
        
      label {
        monitor =
        text = $TIME
        color = rgb(''
    + config.lib.stylix.colors.base07-rgb-r
    + '',''
    + config.lib.stylix.colors.base07-rgb-g
    + '', ''
    + config.lib.stylix.colors.base07-rgb-b
    + ''      )
            font_size = 20
            font_family = Intel One Mono
            rotate = 0 # degrees, counter-clockwise

            position = 0, 80
            halign = center
            valign = center
          }
    '';
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      postPatch = ''
        # use hyprctl to switch workspaces
        sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch focusworkspaceoncurrentmonitor " + std::to_string(id());\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
        sed -i 's/gIPC->getSocket1Reply("dispatch workspace " + std::to_string(id()));/gIPC->getSocket1Reply("dispatch focusworkspaceoncurrentmonitor " + std::to_string(id()));/g' src/modules/hyprland/workspaces.cpp
      '';
    });
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        margin = "7 7 3 7";
        spacing = 2;

        modules-left = ["group/power" "group/battery" "group/backlight" "group/cpu" "group/memory" "group/pulseaudio" "keyboard-state"];
        modules-center = ["custom/hyprprofile" "hyprland/workspaces"];
        modules-right = ["group/time" "idle_inhibitor" "tray"];

        "custom/os" = {
          "format" = " {} ";
          "exec" = ''echo "" '';
          "interval" = "once";
          "on-click" = "nwggrid-wrapper";
          "tooltip" = false;
        };
        "group/power" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "children-class" = "not-power";
            "transition-left-to-right" = true;
          };
          "modules" = [
            "custom/os"
            "custom/hyprprofileicon"
            "custom/lock"
            "custom/quit"
            "custom/power"
            "custom/reboot"
          ];
        };
        "custom/quit" = {
          "format" = "󰍃";
          "tooltip" = false;
          "on-click" = "hyprctl dispatch exit";
        };
        "custom/lock" = {
          "format" = "󰍁";
          "tooltip" = false;
          "on-click" = "hyprlock";
        };
        "custom/reboot" = {
          "format" = "󰜉";
          "tooltip" = false;
          "on-click" = "reboot";
        };
        "custom/power" = {
          "format" = "󰐥";
          "tooltip" = false;
          "on-click" = "shutdown now";
        };
        "custom/hyprprofileicon" = {
          "format" = "󱙋";
          "on-click" = "hyprprofile-dmenu";
          "tooltip" = false;
        };
        "custom/hyprprofile" = {
          "format" = " {}";
          "exec" = ''cat ~/.hyprprofile'';
          "interval" = 3;
          "on-click" = "hyprprofile-dmenu";
        };
        "keyboard-state" = {
          "numlock" = true;
          "format" = "{icon}";
          "format-icons" = {
            "locked" = "󰎠 ";
            "unlocked" = "󱧓 ";
          };
        };
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
            "1" = "󱚌";
            "2" = "󰖟";
            "3" = "";
            "4" = "󰎄";
            "5" = "󰋩";
            "6" = "";
            "7" = "󰄖";
            "8" = "󰑴";
            "9" = "󱎓";
            "scratch_term" = "_";
            "scratch_ranger" = "_󰴉";
            "scratch_music" = "_";
            "scratch_btm" = "_";
            "scratch_pavucontrol" = "_󰍰";
          };
          "on-click" = "activate";
          "on-scroll-up" = "hyprnome";
          "on-scroll-down" = "hyprnome --previous";
          "all-outputs" = false;
          "active-only" = false;
          "ignore-workspaces" = ["scratch" "-"];
          "show-special" = false;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
        };
        tray = {
          #"icon-size" = 21;
          "spacing" = 10;
        };
        "clock#time" = {
          "interval" = 1;
          "format" = "{:%I:%M:%S %p}";
          "timezone" = "America/Chicago";
          "tooltip-format" = ''              
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        "clock#date" = {
          "interval" = 1;
          "format" = "{:%a %Y-%m-%d}";
          "timezone" = "America/Chicago";
          "tooltip-format" = ''              
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        "group/time" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = false;
          };
          "modules" = ["clock#time" "clock#date"];
        };

        cpu = {"format" = "󰍛";};
        "cpu#text" = {"format" = "{usage}%";};
        "group/cpu" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = ["cpu" "cpu#text"];
        };

        memory = {"format" = "";};
        "memory#text" = {"format" = "{}%";};
        "group/memory" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = ["memory" "memory#text"];
        };

        backlight = {
          "format" = "{icon}";
          "format-icons" = ["" "" "" "" "" "" "" "" ""];
        };
        "backlight#text" = {"format" = "{percent}%";};
        "group/backlight" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = ["backlight" "backlight#text"];
        };

        battery = {
          "states" = {
            "good" = 75;
            "warning" = 30;
            "critical" = 15;
          };
          "fullat" = 80;
          "format" = "{icon}";
          "format-charging" = "󰂄";
          "format-plugged" = "󰂄";
          "format-full" = "󰁹";
          "format-icons" = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          "interval" = 10;
        };
        "battery#text" = {
          "states" = {
            "good" = 75;
            "warning" = 30;
            "critical" = 15;
          };
          "fullat" = 80;
          "format" = "{capacity}%";
        };
        "group/battery" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = ["battery" "battery#text"];
        };
        pulseaudio = {
          "scroll-step" = 1;
          "format" = "{icon}";
          "format-bluetooth" = "{icon}";
          "format-bluetooth-muted" = "󰸈";
          "format-muted" = "󰸈";
          "format-source" = "";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];
          };
          "on-click" = "hyprctl dispatch togglespecialworkspace scratch_pavucontrol; if hyprctl clients | grep pavucontrol; then echo 'scratch_ranger respawn not needed'; else pavucontrol; fi";
        };
        "pulseaudio#text" = {
          "scroll-step" = 1;
          "format" = "{volume}%";
          "format-bluetooth" = "{volume}%";
          "format-bluetooth-muted" = "";
          "format-muted" = "";
          "format-source" = "{volume}%";
          "format-source-muted" = "";
          "on-click" = "hyprctl dispatch togglespecialworkspace scratch_pavucontrol; if hyprctl clients | grep pavucontrol; then echo 'scratch_ranger respawn not needed'; else pavucontrol; fi";
        };
        "group/pulseaudio" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = ["pulseaudio" "pulseaudio#text"];
        };
      };
    };
    style =
      ''          
        * {
            /* `otf-font-awesome` is required to be installed for icons */
            font-family: FontAwesome, ''
      + userSettings.font
      + ''        ;
          
                  font-size: 20px;
              }
          
              window#waybar {
                  background-color: rgba(''
      + config.lib.stylix.colors.base00-rgb-r
      + ","
      + config.lib.stylix.colors.base00-rgb-g
      + ","
      + config.lib.stylix.colors.base00-rgb-b
      + ","
      + ''        0.55);
                  border-radius: 8px;
                  color: #''
      + config.lib.stylix.colors.base07
      + ''        ;
                  transition-property: background-color;
                  transition-duration: .2s;
              }
          
              tooltip {
                color: #''
      + config.lib.stylix.colors.base07
      + ''        ;
                background-color: rgba(''
      + config.lib.stylix.colors.base00-rgb-r
      + ","
      + config.lib.stylix.colors.base00-rgb-g
      + ","
      + config.lib.stylix.colors.base00-rgb-b
      + ","
      + ''        0.9);
                border-style: solid;
                border-width: 3px;
                border-radius: 8px;
                border-color: #''
      + config.lib.stylix.colors.base08
      + ''        ;
              }
          
              tooltip * {
                color: #''
      + config.lib.stylix.colors.base07
      + ''        ;
                background-color: rgba(''
      + config.lib.stylix.colors.base00-rgb-r
      + ","
      + config.lib.stylix.colors.base00-rgb-g
      + ","
      + config.lib.stylix.colors.base00-rgb-b
      + ","
      + ''        0.0);
              }
          
              window > box {
                  border-radius: 8px;
                  opacity: 0.94;
              }
          
              window#waybar.hidden {
                  opacity: 0.2;
              }
          
              button {
                  border: none;
              }
          
              #custom-hyprprofile {
                  color: #''
      + config.lib.stylix.colors.base0D
      + ''        ;
              }
          
              /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
              button:hover {
                  background: inherit;
              }
          
              #workspaces button {
                  padding: 0px 6px;
                  background-color: transparent;
                  color: #''
      + config.lib.stylix.colors.base04
      + ''        ;
              }
          
              #workspaces button:hover {
                  color: #''
      + config.lib.stylix.colors.base07
      + ''        ;
              }
          
              #workspaces button.active {
                  color: #''
      + config.lib.stylix.colors.base08
      + ''        ;
              }
          
              #workspaces button.focused {
                  color: #''
      + config.lib.stylix.colors.base0A
      + ''        ;
              }
          
              #workspaces button.visible {
                  color: #''
      + config.lib.stylix.colors.base05
      + ''        ;
              }
          
              #workspaces button.urgent {
                  color: #''
      + config.lib.stylix.colors.base09
      + ''        ;
              }
          
              #battery,
              #cpu,
              #memory,
              #disk,
              #temperature,
              #backlight,
              #network,
              #pulseaudio,
              #wireplumber,
              #custom-media,
              #tray,
              #mode,
              #idle_inhibitor,
              #scratchpad,
              #custom-hyprprofileicon,
              #custom-quit,
              #custom-lock,
              #custom-reboot,
              #custom-power,
              #mpd {
                  padding: 0 3px;
                  color: #''
      + config.lib.stylix.colors.base07
      + ''        ;
                  border: none;
                  border-radius: 8px;
              }
          
              #custom-hyprprofileicon,
              #custom-quit,
              #custom-lock,
              #custom-reboot,
              #custom-power,
              #idle_inhibitor {
                  background-color: transparent;
                  color: #''
      + config.lib.stylix.colors.base04
      + ''        ;
              }
          
              #custom-hyprprofileicon:hover,
              #custom-quit:hover,
              #custom-lock:hover,
              #custom-reboot:hover,
              #custom-power:hover,
              #idle_inhibitor:hover {
                  color: #''
      + config.lib.stylix.colors.base07
      + ''        ;
              }
          
              #clock, #tray, #idle_inhibitor {
                  padding: 0 5px;
              }
          
              #window,
              #workspaces {
                  margin: 0 6px;
              }
          
              /* If workspaces is the leftmost module, omit left margin */
              .modules-left > widget:first-child > #workspaces {
                  margin-left: 0;
              }
          
              /* If workspaces is the rightmost module, omit right margin */
              .modules-right > widget:last-child > #workspaces {
                  margin-right: 0;
              }
          
              #clock {
                  color: #''
      + config.lib.stylix.colors.base0D
      + ''        ;
              }
          
              #battery {
                  color: #''
      + config.lib.stylix.colors.base0B
      + ''        ;
              }
          
              #battery.charging, #battery.plugged {
                  color: #''
      + config.lib.stylix.colors.base0C
      + ''        ;
              }
          
              @keyframes blink {
                  to {
                      background-color: #''
      + config.lib.stylix.colors.base07
      + ''        ;
                      color: #''
      + config.lib.stylix.colors.base00
      + ''        ;
                  }
              }
          
              #battery.critical:not(.charging) {
                  background-color: #''
      + config.lib.stylix.colors.base08
      + ''        ;
                  color: #''
      + config.lib.stylix.colors.base07
      + ''        ;
                  animation-name: blink;
                  animation-duration: 0.5s;
                  animation-timing-function: linear;
                  animation-iteration-count: infinite;
                  animation-direction: alternate;
              }
          
              label:focus {
                  background-color: #''
      + config.lib.stylix.colors.base00
      + ''        ;
              }
          
              #cpu {
                  color: #''
      + config.lib.stylix.colors.base0D
      + ''        ;
              }
          
              #memory {
                  color: #''
      + config.lib.stylix.colors.base0E
      + ''        ;
              }
          
              #disk {
                  color: #''
      + config.lib.stylix.colors.base0F
      + ''        ;
              }
          
              #backlight {
                  color: #''
      + config.lib.stylix.colors.base0A
      + ''        ;
              }
          
              label.numlock {
                  color: #''
      + config.lib.stylix.colors.base04
      + ''        ;
              }
          
              label.numlock.locked {
                  color: #''
      + config.lib.stylix.colors.base0F
      + ''        ;
              }
          
              #pulseaudio {
                  color: #''
      + config.lib.stylix.colors.base0C
      + ''        ;
              }
          
              #pulseaudio.muted {
                  color: #''
      + config.lib.stylix.colors.base04
      + ''        ;
              }
          
              #tray > .passive {
                  -gtk-icon-effect: dim;
              }
          
              #tray > .needs-attention {
                  -gtk-icon-effect: highlight;
              }
          
              #idle_inhibitor {
                  color: #''
      + config.lib.stylix.colors.base04
      + ''        ;
              }
          
              #idle_inhibitor.activated {
                  color: #''
      + config.lib.stylix.colors.base0F
      + ''        ;
              }
      '';
  };

  services.udiskie.enable = true;
  services.udiskie.tray = "always";
}
