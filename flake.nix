{
  description = "Spotify Adblock";

  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {
    nixpkgs,
    systems,
    ...
  }: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.pkgs.alejandra);
    nixosModules.spotify-adblock = import ./nixos;
    homeManagerModules.spotify-adblock = import ./home;
    packages = eachSystem (system:
      import ./pkgs (import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }));
  };
}
