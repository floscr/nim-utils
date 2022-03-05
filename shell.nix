{ pkgs, nimpkgs, buildInputs }:

pkgs.mkShell {
  shellHook = ''
    export NIMBLE_DIR="$PWD/.nimble"
    export NIMBLE_BIN_DIR="$NIMBLE_DIR/bin"
    export PATH="$NIMBLE_BIN_DIR:$PATH"
    # Mutable nimble install
  '';
  buildInputs = with pkgs; buildInputs ++ [
    nim
    nimlsp
  ];
}
