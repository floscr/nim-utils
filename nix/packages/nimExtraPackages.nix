{ pkgs, nimpkgs, ... }:

with pkgs;
{
  fusion =
    (fetchFromGitHub
      ({
        owner = "nim-lang";
        repo = "fusion";
        rev = "v1.1";
        sha256 = "9tn0NTXHhlpoefmlsSkoNZlCjGE8JB3eXtYcm/9Mr0I=";
      }));
  nimfp = with nimpkgs; [
    (pkgs.fetchFromGitHub
      ({
        owner = "floscr";
        repo = "nimfp";
        rev = "1966bc290062b11cf8e620a2117087eeb27f83c5";
        sha256 = "sha256-RbWuN6q6q6ElyS8TSyGctrGmgl8DdCxOvG1dwDJG1+g=";
      }))
    classy
    nimboost
  ];
}
