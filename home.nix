{ config, pkgs, lib, catppuccin, user, ...}:

let
    dotfiles = ./.;
in
{
    users.users.${user} = {
      home = "/Users/${user}";
      isHidden = false;
      shell = pkgs.fish;
    };

    homebrew = {
      enable = true;
      onActivation = { autoUpdate = false; upgrade = true; cleanup = "zap"; };
      brews = [  "keyboardSwitcher" "mole" ];
      # caskArgs.no_quarantine = true;
      casks = [
        {name = "ghostty@tip"; greedy = false; }
        {name = "cocoapods"; greedy = true; }
        {name = "shortcat"; greedy = true; }
        {name = "discord"; greedy = true; }
        {name = "telegram"; greedy = false; }
        {name = "zoom"; greedy = true; }
        # {name = "iina"; greedy = true; }
        {name = "raycast"; greedy = false; }
        {name = "ungoogled-chromium"; greedy = false; }
        {name = "zed"; greedy = false; }
      ];
      # $ nix shell nixpkgs#mas
      # $ mas search <app name>
      masApps = {
        "FSNotes" = 1277179284;
      };
      taps = [
        "homebrew/core"
        "homebrew/cask"
        "homebrew/bundle"
        "lutzifer/homebrew-tap"
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      verbose = true;
      # Let home-manager adopt pre-existing files (e.g. ~/.homebrew/trust.json
      # created out-of-band) by backing them up instead of refusing to clobber.
      backupFileExtension = "backup";

      users.${user} = {pkgs, config, lib, ...}:{
        imports = [ catppuccin.homeModules.catppuccin ];
        xdg.enable = true;
        xdg.configHome = "${config.home.homeDirectory}/.config";
        home = {
          enableNixpkgsReleaseCheck = false;
          stateVersion = "26.05";
          packages = with pkgs; [
            cowsay
            qmk
            nginx-language-server
          ];
          sessionVariables.SHELL = "fish";
          file = lib.mkMerge [
            { ".config/hello".text = "hello world"; }
            # Homebrew 6.0 tap-trust: the darwin activation runs `brew bundle`
            # without XDG_CONFIG_HOME, so it reads trust from ~/.homebrew/trust.json
            # rather than ~/.config/homebrew/trust.json. Pre-trust the third-party tap.
            { ".homebrew/trust.json".text = builtins.toJSON {
                trustedformulae = [ "lutzifer/tap/keyboardswitcher" ];
                trustedtaps = [ "lutzifer/tap" ];
              };
            }
            { ".hushlogin".text = ""; }
            { "Library/LaunchAgents/environment.plist".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/environment.plist"; }
            { ".config/bat".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/bat"; }
            { ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/git"; }
            { ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/ghostty"; }
            { ".config/kanata".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/kanata"; }
            { ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/nvim"; }
            { ".config/zed".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/zed"; }
          ];
        };
        programs = {
          fish = {
            enable = true;
            shellInit = ''
              set -g fish_key_bindings fish_vi_key_bindings
            '';
            functions.hey = ''
              set prompt $argv[1]
              if not isatty stdin
                set context "$(cat)"
                claude --print (printf '%s\n\n%s' "$context" "$prompt")
              else if test (count $argv) -ge 2
                set context "$(cat $argv[2])"
                claude --print (printf '%s\n\n%s' "$context" "$prompt")
              else
                claude --print "$prompt"
              end
            '';
            shellAliases = {
              ga = "git add";
              gaa = "git add --all";
              gb = "git branch";
              gc = "git commit";
              gcb = "git checkout -b";
              gcmsg = "git commit -m";
              gco = "git checkout";
              gcp = "git cherry-pick";
              gd = "git diff";
              gdiff = "git diff";
              gds = "git diff --staged";
              gf = "git fetch";
              gfa = "git fetch --all --prune";
              gl = "git pull";
              glog = "git log --oneline --decorate --graph";
              glol = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'";
              gp = "git push";
              gpsup = "git push --set-upstream origin HEAD";
              gsb = "git status -sb";
              gs = "git status";
              gt = "git tag";
            };
          };
          direnv = {
            enable = true;
            nix-direnv.enable = true;
            silent = true;
          };
          fzf.enable = true;
          home-manager.enable = true;
          k9s.enable = true;
          starship.enable = true;
          yazi.enable = true;
        };
        catppuccin = {
          enable = true;
          flavor = "frappe";
        };
      };
    };
}
