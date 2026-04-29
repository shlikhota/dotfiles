{ stdenvNoCC, fetchurl, system }:

let
  version = "2.1.121";

  # Native binary hashes per platform
  hashes = {
    aarch64-darwin = "sha512-QQEOsxmRUf45PGS88RsiijU1De9DP7tcwxgaYdpwLtD1IMQZFSW3KwsOpLeYUIlvsAKfxB3O/CklEEr3kAAzXg==";
    x86_64-darwin = "sha512-Rv4OICdfJjIbFyjs6L1d8TOFh+f0UwL9f5iAG0/lcwybzvcvgL8Nr5thAfah3Xc2ElHq+8vwGChjz0MonHO+Ww==";
    aarch64-linux = "sha512-c8d1OrPUHnU8wkxyfemN9p0dGhvlVxgftDAcWxXJ66mz6xmC0IFpdVdVDrMNSqtfLgXrDy/XUT3QS3RsFbDgMQ==";
    x86_64-linux = "sha512-vTvPoq0to7KKEiOZ+2nyo4nlcNlVeLqo1kgAkbRd1i7ytC2KiqgLbZ2GbTtGhe2M4uWWgurKEf9CWIt6SCnYkw==";
  };

  platformMap = {
    aarch64-darwin = "darwin-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-linux = "linux-arm64";
    x86_64-linux = "linux-x64";
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
    platforms = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
  };
}
