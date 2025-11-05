# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  console.keyMap = "sv-latin1";

  users.users.abe = {
    isNormalUser = true;
    description = "abe";
    extraGroups = [ "networkmanager" "wheel" "storage" ];
    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ vim wget kitty ];
  system.stateVersion = "25.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  users.users."abe".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5cgxnudR4k79xZ5OeNOHATZNJj0HVkwYb68UtVBEDyMjvDB5pffxNO7WY4mseiepuqTlINUoJjOjIBSKKn8gsIPLpH4+2ErBpQnkz3Ci6OEFWfzzAkdM0lKN39j/F4f1JqNneNHloUBxIL7g9WwH1Q9zKJw0fD1rgilRjA9EUs1ri+MMUCENVRQBprdQjgvjeHgK/oKzgM3Ysod6xG393wvgvSrM4Ogeoz8iwPDhNR4EsXur6CRTuRwfIJCbwt8rAxeu731dbYokzzjqZUTcXM0LEcQN0lciNM2Czdt5v0C/k4kJ50WmAFkrPfaYma5LNGeyk5gL5z5EgDjzUJY8lNPB8E2MdrNQKCOlObCsF3J3paPrKyu8nU/lHT3pQEVZD8Wpe0Yx+0BYd9SVLsSXH83wW4lyv331GJ8cY6eZjrffmDqy+10io6J4YNGcI0QD/d47qqNC27Q2XGkXQW6nhbMmFTwvW1j3uQjD+NeQI91fBVUAV3H7w71WDZvbFq88= agu@MacBookPro"
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      material-design-icons
      material-icons
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      maple-mono.NF
      noto-fonts
      noto-fonts-emoji
      liberation_ttf
      dejavu_fonts
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "MapleMono" "JetBrains Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  programs.hyprland = {
    enable = true;
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.dconf.enable = true;

  services.udisks2.enable = true;

  boot.supportedFilesystems = [ "ntfs" ];
}
