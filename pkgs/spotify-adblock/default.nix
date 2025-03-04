{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeDesktopItem,
  spotify,
}:
rustPlatform.buildRustPackage rec {
  pname = "spotify-adblock";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "abba23";
    repo = pname;
    rev = "fc0d2e21d886f5dbb9dc1f20ad51daaddd2cf737";
    hash = "sha256-rjgLrJ42eFST3aEcc59UWi7kpwoxzE0oDhY0Bvb7yOg==";
  };

  cargoHash = "sha256-wPV+ZY34OMbBrjmhvwjljbwmcUiPdWNHFU3ac7aVbIQ=";

  meta = with lib; {
    description = "Adblocker for Spotify";
    homepage = "https://github.com/abba23/spotify-adblock";
    license = licenses.gpl3;
    maintainers = with lib.maintainers; [body20002];
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Spotify (adblock)";
    genericName = "Music Player";
    icon = "spotify-client";
    exec = "env LD_PRELOAD=@out@/lib/libspotifyadblock.so ${spotify}/bin/spotify %U";
    tryExec = "${spotify}/bin/spotify";
    terminal = false;
    categories = ["Audio" "Music" "Player" "AudioVideo"];
    startupWMClass = "spotify";
  };

  postInstall = ''
    echo "Installing desktop item..."
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
    substituteAllInPlace $out/share/applications/*
    echo "Copying default config.toml"
    mkdir -p $out/etc/spotify-adblock
    cp ${src}/config.toml $out/etc/spotify-adblock
  '';
}
