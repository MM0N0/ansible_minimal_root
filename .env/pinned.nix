import (builtins.fetchGit {
  name = "fixed-project-revision";
  url = "https://github.com/NixOS/nixpkgs/";
  ref = "refs/heads/nixpkgs-23.05-darwin";
  rev = "4ecab3273592f27479a583fb6d975d4aba3486fe";
}) {}