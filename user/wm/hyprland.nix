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
  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name =
      if (config.stylix.polarity == "light")
      then "Quintom_Ink"
      else "Quintom_Snow";
    size = 36;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {};
    extraConfig =
      ''        
        $mainMod = SUPER
        $terminal = kitty
        $browser = ''
      + userSettings.spawnBrowser
      + ''

        $menu = rofi -show drun
        $files = thunar
        $UserScripts = $HOME/.config/hypr/scripts
        exec-once = systemctl --user import-environment &
        exec-once = hash dbus-update-activation-environment 2>/dev/null &
        exec-once = dbus-update-activation-environment --systemd &
        exec-once = nm-applet &
        exec-once = hypridle
          
        ################
        ### imports   ###
        ################
        source = ~/.config/hypr/monitors.conf
        source = ~/.config/hypr/workspaces.conf
        source = ~/.config/hypr/input.conf
        source = ~/.config/hypr/animation.conf
        source = ~/.config/hypr/scratchpads.conf
          
        exec-once = hyprctl setcursor ''
      + config.gtk.cursorTheme.name
      + " "
      + builtins.toString config.gtk.cursorTheme.size
      + ''


        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = $mainMod, RETURN, exec, $terminal
        bind = $mainMod, B, exec, $browser
        bind = $mainMod, E, exec, $files
        bind = $mainMod, A, exec, grim -g "$(slurp)" - | swappy -f -
        bind = $mainMod, Q, killactive,
        bind = $mainMod SHIFT, Q, exit,
        bind = $mainMod, V, togglefloating,
        # bind = CTRL, SPACE, exec, rofi -show combi -modi window,run,combi -combi-modi window,run
        bind = SUPER,Super_L,exec, killall rofi || $menu
        bind = $mainMod, W, exec, $UserScripts/WallpaperSelect.sh # Select wallpaper to apply
        # bind = CTRL, SPACE, exec, $menu
        bind = $mainMod, F, fullscreen
        bind = $mainMod, Y, pin
        #bind = $mainMod, P, pseudo, # dwindle
        bind = $mainMod, J, togglesplit, # dwindle

        bind = $mainMod, K, togglegroup,
        bind = $mainMod, Tab, changegroupactive, f

        bind = $mainMod SHIFT, G,exec,hyprctl --batch "keyword general:gaps_out 5;keyword general:gaps_in 3"
        bind = $mainMod , G,exec,hyprctl --batch "keyword general:gaps_out 0;keyword general:gaps_in 0"

        # Volume control

        bind=,XF86AudioLowerVolume,exec,pamixer -ud 3 && pamixer --get-volume > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob
        bind=,XF86AudioRaiseVolume,exec,pamixer -ui 3 && pamixer --get-volume > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob
        # mute sound
        bind=,XF86AudioMute,exec,amixer sset Master toggle | sed -En '/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob

        # Playback control

        bind=,XF86AudioPlay,exec, playerctl play-pause
        bind=,XF86AudioNext,exec, playerctl next
        bind=,XF86AudioPrev,exec, playerctl previous

        # Screen brightness
        bind = , XF86MonBrightnessUp, exec, brightnessctl s +5%
        bind = , XF86MonBrightnessDown, exec, brightnessctl s 5%-

        bind = ,XF86Calculator, exec, gnome-calculator
        # bind = $mainMod, L, exec, swaylock-fancy -e -K -p 10 -f Hack-Regular
        #bind = $mainMod, P, exec, ~/.scripts/dmshot

        # Screen locking
        bind = $mainMod, L, exec, hyprlock

        bind = $mainMod, Escape, exec, killall -SIGUSR2 waybar
        # bind = Ctrl, Escape, exec, killall waybar || waybar # toggle waybar

        # Move focus with mainMod + arrow keys
        bind = $mainMod, left, movefocus, l
        bind = $mainMod, right, movefocus, r
        bind = $mainMod, up, movefocus, u
        bind = $mainMod, down, movefocus, d

        # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10
        bind = $mainMod, period, workspace, e+1
        bind = $mainMod, comma, workspace,e-1

        bind = $mainMod, minus, movetoworkspace,special
        bind = $mainMod, equal, togglespecialworkspace

        bind = $mainMod SHIFT,left ,movewindow, l
        bind = $mainMod SHIFT,right ,movewindow, r
        bind = $mainMod SHIFT,up ,movewindow, u
        bind = $mainMod SHIFT,down ,movewindow, d

        # Move active window to a workspace with mainMod + CTRL + [0-9]
        bind = $mainMod CTRL, 1, movetoworkspace, 1
        bind = $mainMod CTRL, 2, movetoworkspace, 2
        bind = $mainMod CTRL, 3, movetoworkspace, 3
        bind = $mainMod CTRL, 4, movetoworkspace, 4
        bind = $mainMod CTRL, 5, movetoworkspace, 5
        bind = $mainMod CTRL, 6, movetoworkspace, 6
        bind = $mainMod CTRL, 7, movetoworkspace, 7
        bind = $mainMod CTRL, 8, movetoworkspace, 8
        bind = $mainMod CTRL, 9, movetoworkspace, 9
        bind = $mainMod CTRL, 0, movetoworkspace, 10
        bind = $mainMod CTRL, left, movetoworkspace, -1
        bind = $mainMod CTRL, right, movetoworkspace, +1

        # same as above, but doesnt switch to the workspace
        bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
        bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
        bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
        bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
        bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
        bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
        bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
        bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
        bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
        bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10

        # Scroll through existing workspaces with mainMod + scroll
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

        binds {
             workspace_back_and_forth = 1
             allow_workspace_cycles = 1
        }
        bind = $mainMod,slash,workspace,previous

        bind = $mainMod,R,submap,resize
        submap = resize
        binde =,right,resizeactive,15 0
        binde =,left,resizeactive,-15 0
        binde =,up,resizeactive,0 -15
        binde =,down,resizeactive,0 15
        binde =,l,resizeactive,15 0
        binde =,h,resizeactive,-15 0
        binde =,k,resizeactive,0 -15
        binde =,j,resizeactive,0 15
        bind =,escape,submap,reset
        submap = reset


        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow

        #exec-once = alacritty
        #exec-once = telegram-desktop
        #exec-once = armcord
        exec-once = swaybg  -m fill -o \* -i  ''
        + config.stylix.image 
        + '' 
        
        #------------#
        # auto start #
        #------------#
        exec-once = waybar -c .config/waybar/config-hypr &
        exec-once = fcitx5 -d &
        exec-once = mako &
        exec-once = nm-applet --indicator &
        exec-once = bash -c "mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown" &
        exec-once = /usr/lib/polkit-kde-authentication-agent-1 &

        # Float Necessary Windows
        windowrule=float,Rofi
        windowrule=float,pavucontrol
        windowrulev2 = float,class:^()$,title:^(Picture in picture)$
        windowrulev2 = float,class:^(brave)$,title:^(Save File)$
        windowrulev2 = float,class:^(brave)$,title:^(Open File)$
        windowrulev2 = float,class:^(LibreWolf)$,title:^(Picture-in-Picture)$
        windowrulev2 = float,class:^(blueman-manager)$
        windowrulev2 = float,class:^(xdg-desktop-portal-gtk)$
        windowrulev2 = float,class:^(xdg-desktop-portal-kde)$
        windowrulev2 = float,class:^(xdg-desktop-portal-hyprland)$
        windowrulev2 = float,class:^(org.kde.polkit-kde-authentication-agent-1)$
        windowrulev2 = float,class:^(CachyOSHello)$
        windowrulev2 = float,class:^(zenity)$
        windowrulev2 = float,class:^()$,title:^(Steam - Self Updater)$

        # Increase the opacity
        windowrule=opacity 0.92,Thunar
        windowrule=opacity 0.92,Nautilus
        windowrule=opacity 0.96,discord
        windowrule=opacity 0.96,armcord
        windowrule=opacity 0.96,webcord


        #---------------#
        # windows rules #
        #---------------#
        #`hyprctl clients` get class、title...
        windowrule=float,title:^(Picture-in-Picture)$
        windowrule=size 960 540,title:^(Picture-in-Picture)$
        windowrule=move 25%-,title:^(Picture-in-Picture)$
        windowrule=float,imv
        windowrule=move 25%-,imv
        windowrule=size 960 540,imv
        windowrule=float,mpv
        windowrule=move 25%-,mpv
        windowrule=size 960 540,mpv
        windowrule=float,danmufloat
        windowrule=move 25%-,danmufloat
        windowrule=pin,danmufloat
        windowrule=rounding 5,danmufloat
        windowrule=size 960 540,danmufloat
        windowrule=float,termfloat
        windowrule=move 25%-,termfloat
        windowrule=size 960 540,termfloat
        windowrule=rounding 5,termfloat
        windowrule=float,nemo
        windowrule=move 25%-,nemo
        windowrule=size 960 540,nemo
        windowrule=float,Calculator
        windowrule=opacity 0.95,title:Telegram
        windowrule=opacity 0.95,title:QQ
        windowrule=opacity 0.95,title:NetEase Cloud Music Gtk4
        windowrule=animation slide right,kitty
        windowrule=animation slide right,alacritty
        windowrule=float,ncmpcpp
        windowrule=move 25%-,ncmpcpp
        windowrule=size 960 540,ncmpcpp
        windowrule=noblur,^(firefox)$
        windowrule=noblur,^(waybar)$

      '';
    xwayland = {enable = true;};
    systemd.enable = true;
  };

  home.file.".config/hypr/monitors.conf".text = ''
    monitor=HDMI-A-1,1920x1080@74.97,0x0,1.0
    monitor=DP-1,2560x1440@120,1920x0,1.0
  '';

  home.file.".config/hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
        before_sleep_cmd = loginctl lock-session    # lock before suspend.
        after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
    }

    # Screenlock
    listener {
        # HYPRLOCK TIMEOUT
        timeout = 600
        # HYPRLOCK ONTIMEOUT
        on-timeout = loginctl lock-session
    }

    # dpms
    listener {
        # DPMS TIMEOUT
        timeout = 660
        # DPMS ONTIMEOUT
        on-timeout = hyprctl dispatch dpms off
        # DPMS ONRESUME
        on-resume = hyprctl dispatch dpms on
    }
  '';

  home.file.".config/hypr/workspaces.conf".text = ''
    workspace=1,monitor:DP-1,default:true
    workspace=3,monitor:DP-1
    workspace=5,monitor:DP-1
    workspace=7,monitor:DP-1
    workspace=9,monitor:DP-1
    workspace=2,monitor:HDMI-A-1,default:true
    workspace=4,monitor:HDMI-A-1
    workspace=6,monitor:HDMI-A-1
    workspace=8,monitor:HDMI-A-1
  '';
  home.file.".config/hypr/scratchpads.conf".text = ''
    exec-once = /usr/local/bin/pypr --debug /tmp/pypr.log
    bind = $mainMod SHIFT, RETURN, exec, pypr toggle term                  # toggles the "term" scratchpad visibility
    bind = $mainMod CTRL, V, exec, pypr toggle volume && hyprctl dispatch bringactivetotop

    $scratchpadsize = size 98% 95%
    $scratchpad = class:^(main-dropterm)$
    windowrulev2 = float,$scratchpad
    windowrulev2 = $scratchpadsize.$scratchpad
    windowrulev2 = workspace special silent,$scratchpad
    windowrulev2 = center,$scratchpad

    windowrulev2 = float,class:^(org.pulseaudio.pavucontrol)$
    windowrulev2 = workspace special silent,class:^(pavucontrol)$

  '';

  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = [
     "expose",
     "fetch_client_menu",
     "lost_windows",
     "magnify",
     "scratchpads",
     "shift_monitors",
     "toggle_special",
     "workspaces_follow_focus",
    ]

    # using variables for demonstration purposes (not needed)
    [pyprland.variables]
    term_classed = "kitty --class"

    [scratchpads.term]
    animation = "fromTop"
    command = "[term_classed] main-dropterm"
    class = "main-dropterm"
    # size = "98% 90%"
    # max_size = "1920px 100%"
    unfocus = "hide"
    margin = 50
    lazy = trueV

    [scratchpads.volume]
    command = "pavucontrol"
    animation = "fromRight"
    lazy = true
    size = "40% 40%"
    unfocus = "hide"
  '';

  home.file.".config/hypr/input.conf".text = ''
    input {
      kb_layout=us,ara
      # kb_variant=,digits
      kb_model=
      kb_options=grp:alt_shift_toggle,caps:escape
      kb_rules=
      repeat_rate=50
      repeat_delay=300
      numlock_by_default=1
      left_handed=0
      follow_mouse=1
      float_switch_override_focus=0
      # sensitivity = -0.5 to 0.5
    }
  '';

  home.file.".config/hypr/animation.conf".text =
    ''
      general {
          gaps_in = 3
          gaps_out = 5
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
    + ''      270deg
          
              col.inactive_border = 0xaa''
    + config.lib.stylix.colors.base02
    + ''        

          layout = master # master|dwindle

      }

      decoration {
          active_opacity = 0.95
          inactive_opacity = 1.0
          fullscreen_opacity = 1.0

          rounding = 0
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

          drop_shadow = false
          shadow_range = 4
          shadow_render_power = 3
          shadow_ignore_window = true

          dim_inactive = false
          col.shadow = rgba(1a1a1aee)
      }

      # Blur for waybar
      #blurls = waybar

      animations {
          enabled = yes

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          #bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          bezier = overshot, 0.13, 0.99, 0.29, 1.1
          animation = windows, 1, 4, overshot, slide
          animation = windowsOut, 1, 5, default, popin 80%
          animation = border, 1, 5, default
          animation = fade, 1, 8, default
          animation = workspaces, 1, 6, overshot, slide

          #animation = windows, 1, 7, myBezier
          #animation = windowsOut, 1, 7, default, popin 80%
          #animation = fade, 1, 7, default
          #animation = border, 1, 10, default
          #animation = workspaces, 1, 6, default
      }

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle {
          no_gaps_when_only = false
          force_split = 0
          special_scale_factor = 0.8
          split_width_multiplier = 1.0
          use_active_for_splits = true
          pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = yes
      }

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master {
          no_gaps_when_only = false
          new_status = master
          special_scale_factor = 0.8
      }

      misc {
          #disable_autoreload = true
          disable_hyprland_logo = true
          always_follow_on_dnd = true
          layers_hog_keyboard_focus = true
          animate_manual_resizes = false
          enable_swallow = true
          swallow_regex =
          focus_on_activate = true
          vfr = 1
      }

      gestures {
           workspace_swipe = true
           workspace_swipe_fingers = 4
           workspace_swipe_distance = 250
           workspace_swipe_invert = true
           workspace_swipe_min_speed_to_force = 15
           workspace_swipe_cancel_ratio = 0.5
           workspace_swipe_create_new = false
      }
    '';

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

  services.udiskie.enable = true;
  services.udiskie.tray = "always";
}
