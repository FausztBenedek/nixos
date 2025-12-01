{
  description = "flake for Benedek Fauszt";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    keyboard-remap-flake.url = "github:FausztBenedek/keyboard-remap-flake";
  };

  outputs = { self, nixpkgs, keyboard-remap-flake, ... }: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./configuration.nix
        keyboard-remap-flake.nixosModules.default
      ];
    };
  };

}
