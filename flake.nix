let
  hostSettings = import ./hosts/nixos/settings.nix;
in
{
  description = "Modular NixOS configuration with shared SSH port option";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-${hostSettings.nixosVersion}";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nixos/default.nix
        ];
      };
    };
}
