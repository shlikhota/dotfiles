{ stdenvNoCC, fetchurl, makeWrapper }:

let
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  version = "2.1.50";
  # Update these with: scripts/update-claude.sh
  sha256 = {
    "aarch64-darwin" = "sha256-o3YoYfTQZLQNfbTnkY8ccoFIw44Xeek3C/WU1mYMPrQ=";
    "x86_64-darwin"  = "sha256-IhWBjG4qT6BJfuiKGfjYSrPwuynMQVCjCqd19Xuisyw=";
    "aarch64-linux"  = "sha256-TissnbL5eRjV7cla4d4D0jCma5TV+jGlfMZzdC7Griw=";
    "x86_64-linux"   = "sha256-dAQnORl8WKAB8fZ0FMDYlWYnnu8uOTlSgIcrg9QxfTg=";
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
