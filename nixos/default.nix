{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.programs.spotify-adblock;
in
{
  options.programs.spotify-adblock = {
    enable = mkEnableOption "Enable Spotify Adblock";
    package = mkOption {
      type = types.package;
      default = pkgs.spotify-adblock;
      description = "Spotify adblock package";
    };
    configFile = mkOption {
      type = types.path;
      default = "${pkgs.spotify-adblock}/etc/spotify-adblock/config.toml";
      description = "Config File";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.etc."spotify-adblock/config.toml".source = cfg.configFile;
  };
}
