{ stdenvNoCC, fetchurl, nodejs_22, makeWrapper }:

let
  version = "2.1.70";
  # Update with: scripts/update-claude.sh
  hash = "sha512-wbpEAfQSVfwAAYGnBgWjlLaKl59UKhOnj0RK6pCd1RexqVj2wJpcxOVKH3lVWuazp9ysAJej/wOwkVcU3opCPg==";
in
stdenvNoCC.mkDerivation {
  pname = "claude-code";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    inherit hash;
  };

  # npm tarballs extract into a "package/" subdirectory
  sourceRoot = "package";

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib/claude-code $out/bin
    cp -r . $out/lib/claude-code/
    makeWrapper ${nodejs_22}/bin/node $out/bin/claude \
      --add-flags "$out/lib/claude-code/cli.js"
  '';

  meta = {
    description = "Claude Code CLI";
    homepage = "https://claude.ai";
    mainProgram = "claude";
    platforms = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
  };
}
