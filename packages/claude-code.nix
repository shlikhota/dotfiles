{ stdenvNoCC, fetchurl, system }:

let
  version = "2.1.121";

  # Native binary hashes per platform
  hashes = {
    aarch64-darwin = "sha512-QQEOsxmRUf45PGS88RsiijU1De9DP7tcwxgaYdpwLtD1IMQZFSW3KwsOpLeYUIlvsAKfxB3O/CklEEr3kAAzXg==";
  };

  platformMap = {
    aarch64-darwin = "darwin-arm64";
  };

  platform = platformMap.${system} or (throw "Unsupported system: ${system}");
  hash = hashes.${system} or (throw "No hash for system: ${system}");
in
stdenvNoCC.mkDerivation {
  pname = "claude-code";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code-${platform}/-/claude-code-${platform}-${version}.tgz";
    inherit hash;
  };

  sourceRoot = "package";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 claude $out/bin/claude
  '';

  meta = {
    description = "Claude Code CLI";
    homepage = "https://claude.ai";
    mainProgram = "claude";
    platforms = [ "aarch64-darwin" ];
  };
}
