# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports =
    [
      <nixos-wsl/modules>
    ];

  # programs.fuse.userAllowOther = true; # Needed for java_home bind with bindfs

  system.activationScripts.javaSetup = ''
    mkdir -p /usr/lib/jvm
    ln -sfn ${pkgs.jdk17}/lib/openjdk /usr/lib/jvm/openjdk-17
  '';

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    ssl-cert-file = "/etc/ssl/certs/ca-certificates.crt";
    trusted-users = [ "root" "nixos" ];
  };
  security.pki.certificates = [
    (builtins.readFile ./cp-proxy.dlva.directline.de.crt)
    (builtins.readFile ./cache.nixos.org.crt)
    (builtins.readFile ./nixos.org.crt)
  ];
  wsl.enable = true;
  wsl.defaultUser = "nixos";
  # console.keyMap = "hu-custom";

  environment.systemPackages = with pkgs; [
    neovim
    curl
    git
    gh
    unzip
    zip
    jdk21_headless
    # bindfs
  ];
  system.stateVersion = "25.05";

}

