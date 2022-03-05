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
        rev = "527d06ded4f95e0392c1035ad4816af22d2b7edd";
        sha256 = "sha256-4EzwK8FPbDxeSjw0x8iYTgF6YJvOXZ69zPc19fkTX7s=";
      }))
    classy
    nimboost
  ];
}
