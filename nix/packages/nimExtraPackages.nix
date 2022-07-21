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
        rev = "20cd14ae0bc4e7e2ecb2585864887b9feb65a6d7";
        sha256 = "sha256-LbBJyVXbLN7BqjTPC4b+C68R80MoIC6KuP++j751XvM=";
      }))
    classy
    nimboost
  ];
}
