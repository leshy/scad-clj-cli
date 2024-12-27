{
  description = "scad-clj CLI tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "scadcljcli";
          version = "0.1.0";

          src = ./.;

          nativeBuildInputs = with pkgs; [
            leiningen
            jdk8
          ];

          buildPhase = ''
            export HOME=$PWD
            lein uberjar
          '';

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/share/java

            cp target/*standalone.jar $out/share/java/scadcljcli.jar

            cat > $out/bin/scadcljcli << EOF
            #!${pkgs.runtimeShell}
            exec ${pkgs.jdk8}/bin/java -jar $out/share/java/scadcljcli.jar "\$@"
            EOF

            chmod +x $out/bin/scadcljcli
          '';
        };

        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
          name = "scadcljcli";
        };
      }
    );
}
