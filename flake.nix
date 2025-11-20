{
  description = "flake for Benedek Fauszt";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }: {
    packages.aarch64-linux.nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./configuration.nix
        ];
    };
  };
  
}
