{
  description = "LaTeX devshell with texliveBasic, and latexmk";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        mylatex = pkgs.texliveBasic.withPackages (ps: with ps;
          [
            latexmk
          ]);
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            mylatex
          ];
        };
      });
}
