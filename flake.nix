{
  description = "Burrito guild wars 2 overlay";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    src = pkgs.fetchzip {
      url = "https://github.com/AsherGlick/Burrito/releases/download/burrito-1.0.0/burrito-1.0.0.zip";
      stripRoot = false;
      sha256 = "10iz1w3vz1881i8h898v2ankhfhcsi439jh8b38z14jpfzbv2m6x";
    };
  in 
  {

    packages.${system}.default = pkgs.buildFHSUserEnv {
      name = "burrito-gw2";

      targetPkgs = pkgs: with pkgs; [
        glibc
        xorg.libXcursor
        xorg.libX11
        xorg.libXinerama
        xorg.libXext
        xorg.libXrandr
        xorg.libXrender
        xorg.libXi
        libGL
        libudev-zero
      ];

      runScript = "${self}/script.sh ${src}";
    };

    devShell.${system} = pkgs.mkShell {
      buildInputs = [
        self.packages.${system}.default
      ];
    };
  };
}
