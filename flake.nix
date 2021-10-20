{
  description = "terranix artwork";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        convert = "${pkgs.imagemagick}/bin/convert";
      in {
        # nix run ".#favicon"
        apps.favicon = {
          type = "app";
          program = toString (pkgs.writers.writeBash "favicon" ''
            cd terranix-logo-favicon
            ${convert} ../terranix-logo.svg -resize 256x256 -transparent white favicon-256.png
            ${convert} favicon-256.png -resize 16x16 favicon-16.png
            ${convert} favicon-256.png -resize 32x32 favicon-32.png
            ${convert} favicon-256.png -resize 64x64 favicon-64.png
            ${convert} favicon-256.png -resize 128x128 favicon-128.png
            ${convert} favicon-16.png favicon-32.png favicon-64.png favicon-128.png favicon-256.png -colors 256 favicon.ico
          '');
        };
        defaultApp = self.apps.${system}.favicon;
      });
}
