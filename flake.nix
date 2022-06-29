{
  description = "Nim utils";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.nimble.url = "github:floscr/flake-nimble";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { self
    , nixpkgs
    , nimble
    , nixos
    , flake-utils
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      customPkgs = {
        based-connect = (pkgs.callPackage ./packages/based-connect.nix { });
      };
      nimpkgs = nimble.packages.${system};
      customNimPkgs = import ./nix/packages/nimExtraPackages.nix { inherit pkgs; inherit nimpkgs; };
      utils = import ./nix/lib/nimBuildGenerator.nix;
      inherit (nixos.lib) flatten getBin;
    in
    {
      packages =
        {
          get_url_title =
            let
              pkgName = "get_url_title";
            in
            pkgs.stdenv.mkDerivation {
              name = pkgName;
              description = "Get the title from an url";
              src = ./.;

              nativeBuildInputs = with pkgs; [
                nim
              ];

              buildPhase = utils.makeNimBuildScript {
                srcFile = "./src/${pkgName}.nim";
                dstName = pkgName;
                packages = flatten [
                  (with nimpkgs; [
                    argparse
                  ])
                  customNimPkgs.fusion
                  customNimPkgs.nimfp
                ];
                extraLines = [
                  "-d:ssl"
                ];
              };

              installPhase = ''
                mkdir -p $out/lib
                install -Dt $out/bin $TMPDIR/${pkgName}
              '';
            };
          bose_battery_level =
            let
              pkgName = "bose_battery_level";
            in
            pkgs.stdenv.mkDerivation {
              name = pkgName;
              description = "A battery level meter for Bose QC35 headphones";
              src = ./.;

              nativeBuildInputs = with pkgs; [
                nim
                makeWrapper
              ];

              buildPhase = utils.makeNimBuildScript {
                srcFile = "./src/${pkgName}.nim";
                dstName = pkgName;
                packages = flatten [
                  (with nimpkgs; [
                    argparse
                    result
                  ])
                  customNimPkgs.fusion
                  customNimPkgs.nimfp
                ];
                extraLines = [
                ];
              };

              installPhase = ''
                mkdir -p $out/lib
                install -Dt $out/bin $TMPDIR/${pkgName}
                runHook postInstall
              '';

              postInstall = ''
                wrapProgram $out/bin/${pkgName} \
                  --prefix PATH : ${pkgs.lib.getBin customPkgs.based-connect}/bin \
                  --prefix PATH : ${pkgs.lib.getBin pkgs.bluez-tools}/bin \
              '';
            };
        };

      devShell = import ./shell.nix {
        inherit pkgs;
        inherit nimpkgs;
        buildInputs = with pkgs; [
          customPkgs.based-connect
          bluez-tools
        ];
      };
    });
}
