{
  description = "Burrito guild wars 2 overlay";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in 
  {

    packages.${system}.default = pkgs.stdenv.mkDerivation {
      name = "burrito-gw2";

      buildInputs = with pkgs; [
      ];

      # will fetch github source code
      # src = pkgs.fetchFromGitHub {
      #   owner = "AsherGlick";
      #   repo = "Burrito";
      #   # to find out rev view tags on github
      #   # also can check yourself with
      #   # https://github.com/AsherGlick/Burrito/archive/refs/tags/alpha-1.4.zip
      #   rev = "alpha-1.4";
      #   # to find sha256
      #   # nix-prefetch-url --unpack https://github.com/AsherGlick/Burrito/archive/refs/tags/alpha-1.4.zip --type sha256
      #   sha256 = "164wjr7y339s67fk1b3kyz4jdx0j64qx77mkzz09wdizi7idphf3";
      # };
      src = pkgs.fetchzip {
        url = "https://github.com/AsherGlick/Burrito/releases/download/alpha-1.4/Burrito_Linux.zip";
        # because zip don't have a root directory
        stripRoot=false;
        # nix-prefetch-url --unpack <url> --type sha256
        sha256 = "0a9f8dby8b3pn36nz0plf2kyjijlr0f6zc7vb8ym044ivrq97ss9";
      };

      # dummy
      # to see whats I'm getting
      installPhase = ''
        mkdir -p $out/bin
        cp -r $src $out/bin
      '';
    };

  };
}
