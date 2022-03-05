let
  inherit (builtins) foldl';
in
rec {
  makeNimBuildScript =
    { srcFile
    , dstName
    , packages ? [ ]
    , extraLines ? [ ]
    }:
    let
      packageLines = map (a: "-p:${a}/src") packages;
      lines = [
        "nim compile"
        "-d:release"
        "--hint[Processing]:off"
        "--excessiveStackTrace:on"
      ] ++ packageLines
      ++ extraLines
      ++ [
        "--out:$TMPDIR/${dstName}"
        srcFile
      ];
      buildCommand = foldl' (a: b: a + " " + b) "" lines;
    in
    ''
      HOME=$TMPDIR
      ${buildCommand}
    '';
}
