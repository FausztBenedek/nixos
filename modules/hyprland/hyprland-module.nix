{ pkgs, ... }: {
  config = {

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.etc."hypr".source = ./config;

    environment.systemPackages = with pkgs; [
      waybar
      dunst
      libnotify
      networkmanagerapplet
      hyprpaper
      hyprlock
      brightnessctl
      xorg.xrdb
      grim # screenshot functionality
      slurp # screenshot functionality
    ];

    # TODO Test if it is still needed
    # (This was needed for tuigreet)
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };
}
