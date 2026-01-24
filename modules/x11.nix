{ lib, config, pkgs, ... }: {
  options = {
    option.x11.enable = lib.mkEnableOption "Use x11 instead of wayland";
  };
  config = lib.mkIf config.option.x11.enable {

    system.nixos.tags = [ "add-x11" ];
    nixpkgs.config.nvidia.acceptLicense = true;
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
    ];
    hardware = {
      nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
      nvidia.nvidiaSettings = true;
    };
    services.xserver = {
      enable = true;

      displayManager = {
        startx.enable = true;
      };

      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          enableXfwm = true;
        };
      };
      videoDrivers = [ "nvidia" ];
    };

    environment.systemPackages = with pkgs; [
      nvidia-modprobe

      xfce.xfce4-panel
      xfce.xfce4-settings
      xfce.xfwm4
    ];
  };
}
