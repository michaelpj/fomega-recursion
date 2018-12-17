{
  pkgs ? (import <nixpkgs> {}),
  stdenv ? pkgs.stdenv,
  texlive ? pkgs.texlive,
  biber ? pkgs.biber,
  ghostscript ? pkgs.ghostscript
}:

let
  tex = texlive.combine {
    # more than we need at the moment, but doesn't cost much to include it
    inherit (texlive)
    scheme-small
    collection-bibtexextra
    collection-latex
    collection-latexextra
    collection-luatex
    collection-fontsextra
    collection-fontsrecommended
    collection-mathscience
    acmart
    bibtex biblatex
    latexmk;
  };
in
stdenv.mkDerivation {
  name = "fomega-recursion";
  buildInputs = [ tex biber ghostscript ];
  src = pkgs.lib.sourceFilesBySuffices ./. [ ".tex" ".bib" ];
  buildPhase = "latexmk -view=pdf fomega-recursion";
  installPhase = "install -Dt $out *.pdf";
}

