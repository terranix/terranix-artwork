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
            ${convert} ../terranix-logo.svg \
            -thumbnail '256x256>' \
            -gravity center \
            -extent 256x256 \
            -transparent white logo.png

            ${convert} logo.png -define icon:auto-resize=64,48,32,16 favicon.ico

            ${convert} logo.png -resize 57x57 apple-touch-icon.png
            ${convert} logo.png -resize 57x57 apple-touch-icon-57x57.png
            ${convert} logo.png -resize 72x72 apple-touch-icon-72x72.png
            ${convert} logo.png -resize 76x76 apple-touch-icon-76x76.png
            ${convert} logo.png -resize 114x114 apple-touch-icon-114x114.png
            ${convert} logo.png -resize 120x120 apple-touch-icon-120x120.png
            ${convert} logo.png -resize 144x144 apple-touch-icon-144x144.png
            ${convert} logo.png -resize 152x152 apple-touch-icon-152x152.png
            ${convert} logo.png -resize 180x180 apple-touch-icon-180x180.png

            ${convert} logo.png -resize 192x192 android-icon-192x192.png

            ${convert} logo.png -resize 150x150 mstile-150.png

            rm -f logo.png
          '');
        };
        defaultApp = self.apps.${system}.favicon;
      });
}
