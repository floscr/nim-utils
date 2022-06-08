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
        rev = "a158a4524a813c315ede19ca22d5983f92c00608";
        sha256 = "sha256-FIbs8I5CWlw6eM2UwNIkWGBddFYuSBA2gYmdJ04Smm0=";
      }))
    classy
    nimboost
  ];
}
