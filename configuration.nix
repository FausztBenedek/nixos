# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports =
    [
      <nixos-wsl/modules>
    ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    ssl-cer-file = "/etc/ssl/certs/ca-certificates.crt";
    trusted-users = [ "root" "nixos" ];
  };
  security.pki.certificates = [
    (builtins.readFile ./cp-proxy.dlva.directline.de.crt)
    (builtins.readFile ./cache.nixos.org.crt)
    (builtins.readFile ./nixos.org.crt)
  ];
  wsl.enable = true;
  wsl.defaultUser = "nixos";
  console.keyMap = "hu-custom";

  environment.systemPackages = with pkgs; [
    neovim
    curl
    git
    gh
    zulu17
  ];
  system.stateVersion = "25.05";

}
