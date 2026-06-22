{ stdenvNoCC, fetchurl, system }:

let
  version = "2.1.185";

  # Native binary hashes per platform
  hashes = {
    aarch64-darwin = "sha512-wmz4Sil/m4iP/N2kYjzxwPMd42iOe6c9N+knpoAeqy9wITAnEL1SnllGwvm3OcVUTwiJ8tOrefUswnMHVXMXsw==";
    x86_64-darwin = "sha512-0ugRcohzNWj66meFATJxEoHR1/TTYuLvA344IUUdeSl/ZQ4vQ8W3nQamsA2kjLJEaBYdEKDZBWgUTvR13Wkf3Q==";
    aarch64-linux = "sha512-z/HIA74aQ2PKs0XqgI6G1mykAXrlbuOSun/EIcHRRm0sy1hA75H9fkGCR0d/DvKRq3+P2ehcXzGxlpmHmQCj0A==";
    x86_64-linux = "sha512-5EXH6o7UHthMKMdCHr+RkhmE4lc6+FM+muKpmQJlgNtfD2c5piXZxZ4lYNa2Sso7G8OVTSiBRYhKRykk6ZoK1A==";
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
