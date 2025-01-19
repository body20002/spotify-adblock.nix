# Spotify Adblock In Nix

### How To Use

#### 1. Add flake to your inputs

```nix
inputs.spotify-adblock = {
  url = "github:body20002/spotify-adblock.nix";
  inputs.nixpkgs.follows = "nixpkgs";
  # inputs.systems.follows = "systems"; # optional
};
```

#### 2. HomeManager (Import & enable the module)

```nix
  imports = [
    # other imports
    inputs.spotify-adblock.homeManagerModules.${system}.spotify-adblock
  ];

  # other settings
  programs.spotify-adblock = {
    enable = true;
    package = inputs.spotify-adblock.default; # do this until it gets merged
    autostart = true;
    configFile = ./path-to-allow-and-deny-list # see: https://github.com/abba23/spotify-adblock/blob/main/config.toml
  };
```

#### 3. Nix OS (Import & enable the module)

```nix
  imports = [
    # other imports
    inputs.spotify-adblock.nixosModules.${system}.spotify-adblock
  ];

  # other settings
  programs.spotify-adblock = {
    enable = true;
    package = inputs.spotify-adblock.default; # do this until it gets merged
    configFile = ./path-to-allow-and-deny-list # see: https://github.com/abba23/spotify-adblock/blob/main/config.toml
  };
```

If you have any suggestions make an issue :)
