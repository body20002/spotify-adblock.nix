pkgs: {
  default = pkgs.callPackage ./spotify-adblock { };
  spotify-adblock = pkgs.callPackage ./spotify-adblock { };
}
