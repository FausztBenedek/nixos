{ pkgs, ... }: {
  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.cnijfilter_4_00 ];
    };

    ipp-usb.enable = true;
  };
  environment.systemPackages = with pkgs; [
    system-config-printer
  ];
}
