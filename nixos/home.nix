{ config, pkgs, inputs, lib, ... }:

{
  home.username = "abe";
  home.homeDirectory = "/home/abe";
  home.stateVersion = "25.05";

  wayland.windowManager.hyprland = {
    enable = true;
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    settings = {
      monitor = ",highrr,auto,auto";

      input = {
        kb_layout = "se";
        kb_options = "caps:escape";
        follow_mouse = 1;
        touchpad = { natural_scroll = false; };
        sensitivity = 0;
      };

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      animations = { enabled = false; };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = { force_default_wallpaper = 0; };

      windowrulev2 = "suppressevent maximize, class:.*";

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, Q, killactive,"
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod, Return, exec, kitty"
        "$mainMod, E, exec, kitty -e yazi"
        "$mainMod, T, exec, kitty -e nvim"
        "$mainMod, B, exec, firefox --new-window"
        "$mainMod, D, exec, fuzzel"

        '', Print, exec, grim -g "$(slurp)" - | wl-copy''

        "$mainMod, V, togglefloating,"

        "$mainMod, F, fullscreen,"

        "$mainMod SHIFT, L, exec, swaylock -f"

        "ALT, Tab, workspace, previous"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      exec-once = [ "waybar" "mako" ];
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 580;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
    events = [{
      event = "before-sleep";
      command = "${pkgs.swaylock}/bin/swaylock -f";
    }];
  };

  services.gammastep = {
    enable = true;
    latitude = 59.3; # Stockholm coordinates
    longitude = 18.1;
    temperature = {
      day = 6500;
      night = 3500;
    };
    settings = { general = { adjustment-method = "wayland"; }; };
    tray = true;
  };

  home.packages = with pkgs; [
    # UI and system
    fuzzel
    mako

    # Terminal
    kitty

    # Editors
    neovim
    vim

    # Terminal utilities
    yazi

    # Screenshots and clipboard
    grim
    slurp
    wl-clipboard

    # Screen locking and idle
    swayidle
    swaylock

    # System utilities
    htop
    p7zip
    pavucontrol
    wget
    unzip
    firefox
    fzf

    # Gaming platforms
    bottles
    lutris
    steam

    # Gaming communication
    discord

    # Wine and compatibility layers
    dxvk # DirectX to Vulkan translation
    protontricks
    wineWowPackages.staging
    winetricks

    # Gaming performance tools
    gamemode
    mangohud

    # Gaming libraries
    glib
    glibc
    libglvnd
    mesa
    vulkan-loader
    vulkan-tools
    protonplus

    # Development tools
    appimage-run
    claude-code
    dbeaver-bin
    gcc
    gnumake
    libgcc
    pkg-config
    lazygit
    k9s
    jq
    azure-cli
    kubelogin
    kubectl
    go

    # misc
    protonvpn-gui
    qbittorrent
    mpv
    ffmpeg-full
    proggyfonts
    kdePackages.kcalc
    spotify
    (pkgs.writeShellScriptBin "calibre-appimage" ''
      export LD_LIBRARY_PATH="${
        pkgs.lib.makeLibraryPath [
          pkgs.pcre2
          pkgs.qt6.qtbase
          pkgs.qt6.qtwayland
          pkgs.libGL
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
        ]
      }:$LD_LIBRARY_PATH"

      exec ${pkgs.appimage-run}/bin/appimage-run "$HOME/Downloads/Calibre-8.13.0-x86_64.AppImage" "$@"
    '')
    appimage-run

    # Development runtimes
    (with pkgs.dotnetCorePackages; combinePackages [ sdk_8_0 sdk_9_0 sdk_10_0 ])

    nodejs_22

    (python3.withPackages (ps: with ps; [ requests ]))
  ];

  home.sessionVariables = { DOTNET_CLI_TELEMETRY_OPTOUT = "1"; };

  home.file = {
    ".dotnet/.keep".text = "";
    ".nuget/.keep".text = "";
  };

  home.activation = {
    fixDotnetPermissions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD chmod -R u+w $HOME/.dotnet $HOME/.nuget 2>/dev/null || true
    '';
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = builtins.fromJSON (builtins.readFile ./waybar/config.json);
    };
    style = builtins.readFile ./waybar/style.css;
  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      ignore-timeout = true;
    };
  };

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
      };
      colors = {
        background = "1e1e2eff";
        text = "cdd6f4ff";
        match = "33ccffff";
        selection = "313244ff";
        selection-text = "cdd6f4ff";
        selection-match = "00ff99ff";
        border = "33ccffff";
      };
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  xdg.desktopEntries.yazi = {
    name = "Yazi";
    comment = "Blazing fast terminal file manager";
    exec = "kitty -e yazi %F";
    icon = "folder";
    terminal = false;
    type = "Application";
    categories = [ "System" "FileManager" ];
    mimeType = [ "inode/directory" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "yazi.desktop" ];
      "application/x-gnome-saved-search" = [ "yazi.desktop" ];
    };
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "Albin Gudmundsson";
      email = "albin.gudmundsson@gmail.com";
    };
  };
}

