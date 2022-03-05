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
      nimpkgs = nimble.packages.${system};
      customNimPkgs = import ./nix/packages/nimExtraPackages.nix { inherit pkgs; inherit nimpkgs; };
      buildInputs = with pkgs; [ ];
      utils = import ./nix/lib/nimBuildGenerator.nix;
      inherit (nixos.lib) flatten;
    in
    rec {
      packages.get_url_title =
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

          buildInputs = buildInputs;

          buildPhase = utils.makeNimBuildScript {
            srcFile = "./src/${pkgName}.nim";
            dstName = pkgName;
            packages = flatten [
              (with nimpkgs; [
              ])
              customNimPkgs.fusion
              customNimPkgs.nimfp
            ];
            extraLines = [];
          };

          installPhase = ''
            mkdir -p $out/lib
            install -Dt \
            $out/bin \
            $TMPDIR/${pkgName}
          '';
        };

      devShell = import ./shell.nix {
        inherit pkgs;
        inherit nimpkgs;
        inherit buildInputs;
      };
    });
}
