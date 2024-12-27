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

          src = pkgs.lib.cleanSourceWith {
            src = ./.;
            filter = path: type:
              let baseName = baseNameOf (toString path);
              in baseName == "target" ||
                 baseName == "scadcljcli-0.1.0-SNAPSHOT-standalone.jar" ||
                 pkgs.lib.cleanSourceFilter path type;
          };

          nativeBuildInputs = with pkgs; [ jdk8 ];

          buildPhase = "true";  # Skip build phase as we already have the jar

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
