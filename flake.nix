{
  description = "System flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix/release-25.05";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    kbs-tap = {
      url = "github:lutzifer/homebrew-tap";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, home-manager, nix-homebrew, catppuccin, ... }:
  let
    system = "aarch64-darwin";
    user = "evgenii";

    allowUnfreePackages = [ "claude-code" ];
    nixConfig = {
      allowUnfree = true;
      allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) allowUnfreePackages;
    };

    systemConfiguration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      nix = {
        settings.experimental-features = [ "nix-command" "flakes" ];
        gc = { automatic = true; options = "--delete-older-than 14d"; };
        optimise.automatic = true;
      };

      programs = {
        zsh.enable = true;
        fish.enable = true;
      };

      environment.variables = {
        EDITOR = "nvim";
      };

      environment.systemPackages = with pkgs; [
        bat
        unstable.claude-code
        unstable.codex
        colima
        docker
        fd
        fish
        fzf
        git
        go
        unstable.golangci-lint
        unstable.gopls
        jq
        kubectl
        k9s
        neovim
        nixd
        ollama
        ripgrep
        speedtest-cli
        starship
        sshs
        yazi
      ];

      fonts = {
        packages = with pkgs; [
          nerd-fonts.jetbrains-mono
        ];
      };

      system = {
        stateVersion = 5;
        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;
        primaryUser = user;
      };
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."home" = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit catppuccin user; };
      modules = [
        {
          nixpkgs = {
            # main package set from stable
            pkgs = import nixpkgs { inherit system; config = nixConfig; };
            # overlay adds unstable under pkgs.unstable
            overlays = [
              (final: prev: {
                unstable = import nixpkgs-unstable { inherit system; config = nixConfig; };
              })
            ];
          };
        }
        home-manager.darwinModules.home-manager
        systemConfiguration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            inherit user;
            enable = true;
            mutableTaps = false;
            autoMigrate = true;
            taps = {
              "homebrew/homebrew-core" = inputs.homebrew-core;
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
              "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
              "lutzifer/homebrew-tap" = inputs.kbs-tap;
            };
          };
        }
        ./darwin-defaults.nix
        ./home.nix
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."home".pkgs;
  };
}
