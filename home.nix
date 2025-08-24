{ config, pkgs, lib, catppuccin, user, ...}:

let
in
{
    users.users.${user} = {
      home = "/Users/${user}";
      isHidden = false;
      shell = pkgs.fish;
    };

    homebrew = {
      enable = true;
      onActivation = { autoUpdate = false; upgrade = false; cleanup = "zap"; };
      brews = [  "keyboardSwitcher" ];
      caskArgs.no_quarantine = true;
      casks = [
        {name = "homebrew/cask/docker"; greedy = true; }
        {name = "ghostty"; greedy = true; }
        {name = "shortcat"; greedy = false; }
        {name = "discord"; greedy = true; }
        {name = "telegram"; greedy = true; }
        {name = "zoom"; greedy = true; }
        {name = "iina"; greedy = true; }
        {name = "raycast"; greedy = true; }
        {name = "google-chrome"; greedy = true; }
        {name = "zed"; greedy = true; }
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
        "lutzifer/tap"
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      verbose = true;

      users.${user} = {pkgs, config, lib, ...}:{
        imports = [ catppuccin.homeModules.catppuccin ];
        xdg.enable = true;
        xdg.configHome = "/Users/${user}/.config";
        home = {
          enableNixpkgsReleaseCheck = false;
          stateVersion = "25.05";
          packages = with pkgs; [
            cowsay
            neofetch
            qmk
            nginx-language-server
          ];
          sessionVariables.SHELL = "fish";
          file = lib.mkMerge [
            { ".config/hello".text = "hello world"; }
            { "Library/LaunchAgents/environment.plist".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/environment.plist"; }
            { ".config/bat".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/bat"; }
            { ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/git"; }
            { ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/ghostty"; }
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
            shellAliases = {
              ga = "git add";
              gc = "git commit";
              gco = "git checkout";
              gcp = "git cherry-pick";
              gdiff = "git diff";
              gp = "git push";
              gs = "git status";
              gt = "git tag";
            };
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
