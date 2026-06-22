{ stdenvNoCC, fetchurl, makeWrapper }:

let
  version = "0.30.10";
  # Update with: scripts/update-ollama.sh
  hash = "sha256-rYpNKRjtCUgLgWBBlXBgK09J5IyeN5LvtgHA9UYZ5I4=";
in
stdenvNoCC.mkDerivation {
  pname = "ollama";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ollama/ollama/releases/download/v${version}/ollama-darwin.tgz";
    inherit hash;
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib/ollama $out/bin
    cp -r . $out/lib/ollama/
    ln -s $out/lib/ollama/ollama $out/bin/ollama
  '';

  meta = {
    description = "Get up and running with large language models locally";
    homepage = "https://ollama.com";
    mainProgram = "ollama";
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
}
