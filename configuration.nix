# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  benedek-st = pkgs.callPackage ./suckless/st { };
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  networking.hostName = "stew"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "idea-ultimate"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  #environment.sessionVariables.LIBGL_ALWAYS_SOFTWARE = "1";
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
  };

  # Configure console keymap
  console.keyMap = "hu";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.benedekfauszt = {
    isNormalUser = true;
    description = "Benedek Fauszt";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    packages = with pkgs; [
      #  thunderbird
      chromium
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget


    benedek-st
    (makeDesktopItem {
      name = "st";
      desktopName = "st";
      icon = ./suckless/st/terminal-icon.png;
      exec = "${benedek-st}/bin/st-wl";
    })

    jetbrains.idea-ultimate
    xorg.xrdb
    nerd-fonts.jetbrains-mono
    nerd-fonts.zed-mono
    gcc
    rustup
    rofi
    kitty
    alacritty
    xterm
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    pciutils
    htop
    nemo
    brightnessctl
    numix-gtk-theme
    numix-icon-theme-circle
    volantes-cursors
    qutebrowser # I had to start it with --qt-flag disable-gpu
    cliphist

    evtest
    xorg.xev
    xorg.xkbcomp
    alsa-utils

    # Hyprland stuff
    waybar
    dunst
    libnotify
    networkmanagerapplet
    hyprpaper
    hyprlock
    greetd.tuigreet
  ];
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-hyprland
  ];

  environment.etc."hypr".source = ./hyprland-config;



  #Bloothoth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true; # Adds a nice gui to handle Bluetooth devices


  services.greetd = {
    enable = true;
    # vt = 3;
    settings = {
      # initial_session = {}, which could be used to login automatically
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd \"Hyprland -c /etc/hypr/hyprland.conf\"";
        user = "greeter";
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
