{ config, pkgs, inputs, ... }:

{
  home.username = "abe";
  home.homeDirectory = "/home/abe";
  home.stateVersion = "25.05"; # Replace with your actual version from nixos-version

  # Configure Hyprland via Home Manager
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    
    settings = {
      # Monitor setup
      monitor = ",highrr,auto,auto";
      
      # Input configuration
      input = {
        kb_layout = "se";
        kb_options = "caps:escape";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };
      
      # General settings
      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };
      
      # Animations
      animations = {
        enabled = false;
      };
      
      # Layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      # Misc
      misc = {
        force_default_wallpaper = 0;
        background_color = "0x1e1e2e";
      };
      
      # Window rules
      windowrulev2 = "suppressevent maximize, class:.*";
      
      # Set mod key
      "$mainMod" = "SUPER";
      
      # Keybinds
      bind = [
        "$mainMod, Q, killactive,"
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        
        # Workspace switching
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
        
        # Move active window to workspace
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
        
        # Application launchers
        "$mainMod, Return, exec, kitty"
        "$mainMod, E, exec, kitty -e yazi"
        "$mainMod, T, exec, kitty -e nvim"
        "$mainMod, B, exec, firefox --new-window"
        "$mainMod, D, exec, fuzzel"
        
        # Screenshot
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        
        # Toggle floating/tiling mode
        "$mainMod, V, togglefloating,"
        
        # Toggle fullscreen
        "$mainMod, F, fullscreen,"
        
        # Lock screen
        "$mainMod SHIFT, L, exec, swaylock -f"

	"ALT, Tab, workspace, previous"
      ];
      
      # Move/resize windows with mouse
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      
      # Auto-start applications
      exec-once = [
        "waybar"
        "mako"
        # "swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f'"
      ];
    };
  };

  # Essential packages for your setup
  home.packages = with pkgs; [
    # UI and system
    fuzzel
    mako
    waybar
    
    # Terminal
    kitty
    
    # Editors
    neovim
    vim
    
    # Terminal utilities
    yazi
    
    # Browser
    firefox
    
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
    
    # Gaming platforms
    bottles
    lutris
    steam
    
    # Gaming communication
    discord
    
    # Wine and compatibility layers
    dxvk                     # DirectX to Vulkan translation
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
    
    # Development tools
    appimage-run
    claude-code
    dbeaver-bin
    gcc
    gnumake
    libgcc
    pkg-config
    
    # Development runtimes
    (with pkgs.dotnetCorePackages; combinePackages [
      sdk_8_0
      sdk_9_0
    ])
];

  # Configure mako notifications                                                                                         
  services.mako = { 
    enable = true;
    settings = {
        default-timeout = 5000;
        ignore-timeout = true;
    };
  };

  # Configure fuzzel
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

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName  = "Albin Gudmundsson";
    userEmail = "albin.gudmundsson@gmail.com";
  };

}
