{ stdenvNoCC, fetchurl, system }:

let
  version = "2.1.170";

  # Native binary hashes per platform
  hashes = {
    aarch64-darwin = "sha512-lnBfVVTO+Wk31IAh5KDOY+Cuu1vIHC3N3UjHY9SEroDat8XKqjFtckY50jPi50m5x0oWkeQiyDl4nPstgdkNwQ==";
    x86_64-darwin = "sha512-w2lZwSsKDVqrY8O6N65SSP309JJleWrUx9tltW2SIGaPRLybtrZf7q6KxDz3I/gEMBhpwnC2MHXYMU0sw6JXzg==";
    aarch64-linux = "sha512-J2682NcqJbDouDcmR8VeVDAB4UxWryDMUZfPYdvbwiG3sM6SyupBHPuXgwIEcaT1M1jlpBiWRdJ4ActHF5Drng==";
    x86_64-linux = "sha512-SSQ6TsGbZJSC1s6R5pxlTZPq1bilSpoTR8JANOq8ALUkbRVhgVSl0PiSSNSnc3zNdDCA1iA3ywLmAuISuhlvKA==";
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
