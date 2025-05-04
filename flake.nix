{
  description = "Burrito guild wars 2 overlay";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      src = pkgs.fetchzip {
        url = "https://github.com/AsherGlick/Burrito/releases/download/burrito-1.0.0/burrito-1.0.0.zip";
        stripRoot = false;
        sha256 = "10iz1w3vz1881i8h898v2ankhfhcsi439jh8b38z14jpfzbv2m6x";
      };
      deps = with pkgs; [
        stdenv.cc.cc.lib
        glibc
        gcc
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
    in
    {
      packages.${system} = {
        burrito-fhs = pkgs.buildFHSUserEnv {
          name = "burrito-gw2";

          targetPkgs =
            pkgs: with pkgs; [
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

        default = self.packages.${system}.burrito;

        burrito = pkgs.stdenv.mkDerivation {
          name = "burrito";
          version = "1.0.0";
          src = src;
          nativeBuildInputs = [
            pkgs.makeWrapper
            # pkgs.autoPatchelfHook
          ];
          buildInputs = deps;
          # runtimeDependencies = deps;

          # '' = {
          description = "Burrito Guild Wars 2 overlay";
          platforms = [ "x86_64-linux" ];

          installPhase = ''
            mkdir -p $out/bin $out/lib

            # Copy the main executable
            cp $src/burrito.x86_64 $out/bin/burrito.x86_64
            chmod +x $out/bin/burrito.x86_64

            # Copy the xml_converter
            cp $src/xml_converter $out/bin/xml_converter
            chmod +x $out/bin/xml_converter

            # Copy the libraries
            cp $src/*.so $out/lib/

            # Patch the binary
            # chmod +w $out/bin/burrito.x86_64
            # patchelf --set-rpath "$out/lib:$ {pkgs.lib.makeLibraryPath deps}" $out/bin/burrito.x86_64
            # chmod -w $out/bin/burrito.x86_64

            # Create a wrapper script
            # makeWrapper $out/bin/burrito.x86_64 $out/bin/burrito \
            #     --set LD_LIBRARY_PATH "$out/lib:$ {pkgs.lib.makeLibraryPath deps}" \
            #     --chdir "$out/bin"

            # Create a wrapper
            cat > $out/bin/burrito << EOF
            #!/bin/sh
            cd $out/bin
            export LD_LIBRARY_PATH="$out/lib:${pkgs.lib.makeLibraryPath deps}"
            exec ./burrito.x86_64 "\$@"
            EOF

            chmod +x $out/bin/burrito
          '';
        };
      };

      devShell.${system} = pkgs.mkShell {
        buildInputs = [
          self.packages.${system}.burrito-fhs
        ];
      };
    };
}
