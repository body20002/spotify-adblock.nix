# Spotify Adblock In Nix

### How To Use

#### 1. Add flake to your inputs
```nix
inputs.spotify-adblock = {
  url = "github:body20002/spotify-adblock.nix";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

#### 2. HomeManager (Import & enable the module) 
```nix
  imports = [
    # other imports
    inputs.spotify-adblock.homeManagerModules.${system}.default
  ];

  # other settings
  programs.spotify-adblock.enable = true;
```

#### 3. Nix OS (Import & enable the module)
```nix
  imports = [
    # other imports
    inputs.spotify-adblock.nixosModules.${system}.default
  ];

  # other settings
  programs.spotify-adblock.enable = true;
```


If you have any suggestions make an issue :)
