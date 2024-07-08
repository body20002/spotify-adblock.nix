{
  description = "Spotify Adblock";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    spotify-adblock = {
      url = "github:abba23/spotify-adblock";
      flake = false;
    };

    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        bin = (pkgs.rustPlatform.buildRustPackage {
          name = "spotify-adblock";
          src = inputs.spotify-adblock.outPath;
          cargoLock = {
            lockFile = inputs.spotify-adblock.outPath + "/Cargo.lock";
          };
        }).outPath + "/lib/libspotifyadblock.so";
        desktopFile = pkgs.makeDesktopItem {
          name = "spotify-adblock";
          desktopName = "Spotify (adblock)";
          genericName = "Music Player";
          icon = "spotify-client";
          exec = ''
            env LD_PRELOAD=${bin} ${pkgs.spotify}/bin/spotify %U
          '';
          tryExec = "${pkgs.spotify}/bin/spotify";
          terminal = false;
          categories = [ "Audio" "Music" "Player" "AudioVideo" ];
          startupWMClass = "spotify";
        };
        configFile = inputs.spotify-adblock.outPath + "/config.toml";
      in
      {
        nixosModules.default = { config, lib, ... }: with lib;
          let
            cfg = config.programs.spotify-adblock;
          in
          {
            options.programs.spotify-adblock = {
              enable = mkEnableOption "Enable Spotify Adblock";
              configFile = mkOption {
                type = types.path;
                default = configFile;
                description = "Config File";
              };
            };
            config = mkIf cfg.enable {
              environment.etc."spotify-adblock/config.toml".source = cfg.configFile;
            };
          };
        homeManagerModules.default = { config, lib, ... }:
          with lib;
          let
            cfg = config.programs.spotify-adblock;
          in
          {

            options.programs.spotify-adblock = {
              enable = mkEnableOption "Spotify Adblock";
              configFile = mkOption {
                type = types.path;
                default = configFile;
                description = "Config File";
              };
            };
            config = mkIf cfg.enable {
              home.file.".local/share/applications/spotify-adblock.desktop".source = desktopFile;
              home.file.".config/spotify-adblock/config.toml".source = cfg.configFile;
            };
          };
        packages = rec {
          spotify-adblock = pkgs.stdenv.mkDerivation {
            name = "spotify-adblock";
            phases = [ "installPhase" ];
            installPhase = ''
              mkdir -p $out/bin

              echo "env LD_PRELOAD=${bin} ${pkgs.spotify}/bin/spotify %U" > $out/bin/spotify-adblock
              chmod +x $out/bin/spotify-adblock

              mkdir -p $out/share/applications/
              ln -s "${desktopFile}"/share/applications/* "$out/share/applications/"
            '';
          };
          default = spotify-adblock;
        };
        apps = rec {
          spotify-adblock = flake-utils.lib.mkApp { drv = self.packages.${system}.spotify-adblock; };
          default = spotify-adblock;
        };
      }
    );
}
