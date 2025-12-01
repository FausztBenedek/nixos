{
  description = "flake for Benedek Fauszt";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    keyboard-remap-flake.url = "github:FausztBenedek/keyboard-remap-flake";
  };

  outputs = { self, nixpkgs, keyboard-remap-flake, ... }: {
    nixosConfigurations."stew" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        keyboard-remap-flake.nixosModules.default
      ];
    };
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        keyboard-remap-flake.nixosModules.default
      ];
    };
  };

}
