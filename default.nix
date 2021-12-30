{ pkgs ? import <nixpkgs> {} }:

with pkgs;

{
  fetchdarcs = { url, rev ? null, context ? null, patch ? null, sha256 ? "" }:
    stdenvNoCC.mkDerivation {
      name = "fetchdarcs";
      builder = ./builder.sh;
      nativeBuildInputs = [ cacert darcs ];

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash = sha256;

      inherit url rev context patch;
    };
  nix-prefetch-darcs = stdenv.mkDerivation {
    name = "nix-prefetch-darcs";
    version = "0.0.1";
    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ darcs gnused nix ];
    src = ./.;
    dontUnpack = true;
    preferLocalBuild = true;
    installPhase = ''
      install -vD ${src} $out/bin/$name
      wrapProgram $out/bin/$name \
        --prefix PATH : ${lib.makeBinPath buildInputs} \
        --set HOME /homeless-shelter
    '';
  };
}
