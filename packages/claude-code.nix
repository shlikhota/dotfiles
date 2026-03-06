{ stdenvNoCC, fetchurl }:

let
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  version = "2.1.70";
  # Update these with: scripts/update-claude.sh
  sha256 = {
    "aarch64-darwin" = "sha256-hxiIAhyqpDNkKPEXVJMqVlXNlTumqByCqdamtgp+1u4=";
    "x86_64-darwin"  = "sha256-M4dV3OWlyZQZ83vo3UJEEMNfxHb32Mys2e1+8zuEc64=";
    "aarch64-linux"  = "sha256-JkxmnOR0C7SJawesARAZC89hjt3U+wBos/4s6YlzRoI=";
    "x86_64-linux"   = "sha256-HlwQEeyJnvDKnwgRwTw+1EQ3Qirtha9gDV/lB0b6rx0=";
  };
  platform = {
    "aarch64-darwin" = "darwin-arm64";
    "x86_64-darwin"  = "darwin-x64";
    "aarch64-linux"  = "linux-arm64";
    "x86_64-linux"   = "linux-x64";
  };
in
stdenvNoCC.mkDerivation {
  pname = "claude-code";
  inherit version;

  src = fetchurl {
    url = "${baseUrl}/${version}/${platform.${stdenvNoCC.hostPlatform.system}}/claude";
    sha256 = sha256.${stdenvNoCC.hostPlatform.system};
    executable = true;
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/claude
  '';

  meta = {
    description = "Claude Code CLI";
    homepage = "https://claude.ai";
    mainProgram = "claude";
    platforms = builtins.attrNames platform;
  };
}
