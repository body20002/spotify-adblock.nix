{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.spotify-adblock;
in {
  options.programs.spotify-adblock = {
    enable = mkEnableOption "Enable Spotify Adblock";
    package = mkOption {
      type = types.package;
      default = pkgs.spotify-adblock;
      description = "Spotify adblock package";
    };
    configFile = mkOption {
      type = types.path;
      default = "${cfg.package}/etc/spotify-adblock/config.toml";
      description = "Config file";
    };
    autostart = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Autostart";
    };
  };
  config = mkIf cfg.enable {
    home.packages = [cfg.package];
    home.file."${config.xdg.configHome}/spotify-adblock/config.toml".source = cfg.configFile;
    home.file."${config.xdg.configHome}/autostart/spotify-adblock.desktop" = mkIf cfg.autostart {
      source = "${cfg.package}/share/applications/spotify-adblock.desktop";
    };
  };
}
