{
  description = "System flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    catppuccin.url = "github:catppuccin/nix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
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

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, kbs-tap, catppuccin, ... }:
  let
    user = "evgenii";

    systemConfiguration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;
      programs.fish.enable = true;

      environment.variables = {
        EDITOR = "nvim";
      };

      environment.systemPackages =
        [
          pkgs.bat
          pkgs.fd
          pkgs.fish
          pkgs.fzf
          pkgs.git
          pkgs.go
          pkgs.golangci-lint
          pkgs.gopls
          pkgs.jq
          pkgs.k9s
          pkgs.neovim
          pkgs.nixd
          pkgs.ollama
          pkgs.ripgrep
          pkgs.speedtest-cli
          pkgs.starship
          pkgs.sshs
          pkgs.yazi
        ];

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];

      system = {
        stateVersion = 5;
        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;
        primaryUser = "evgenii";
        # https://daiderd.com/nix-darwin/manual/index.html
        defaults = {
          controlcenter = {
            BatteryShowPercentage = false;
            Sound = true;
            Bluetooth = true;
          };
          dock = {
            autohide = false;
            show-recents = false;
            launchanim = true;
            orientation = "bottom";
            tilesize = 48;
            # run screensaver on bottom left corner
            wvous-bl-corner = 5;
            persistent-apps = [
              "/System/Applications/Calendar.app/"
              "/Applications/Safari.app/"
              "/Applications/Zed.app/"
              "/Applications/Ghostty.app/"
              "/Applications/Telegram.app/"
              "/Applications/Raycast.app/"
              "/System/Applications/App\ Store.app/"
            ];
          };
          finder = {
            _FXShowPosixPathInTitle = true;
            _FXSortFoldersFirst = true;
            AppleShowAllFiles = true;
            ShowStatusBar = true;
            ShowPathbar = true;
            FXEnableExtensionChangeWarning = false;
            # “icnv” = Icon view, “Nlsv” = List view, “clmv” = Column View, “Flwv” = Gallery View The default is icnv.
            FXPreferredViewStyle = "Nlsv";
            NewWindowTarget = "Home";
          };
          loginwindow.GuestEnabled = false;
          menuExtraClock = {
            IsAnalog = false;
            Show24Hour = true;
            ShowDate = 2;
            ShowSeconds = true;
          };
          NSGlobalDomain = {
            AppleICUForce24HourTime = true;
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            AppleShowScrollBars = "Always";
            # 120, 90, 60, 30, 12, 6, 2
            KeyRepeat = 2;
            # 120, 94, 68, 35, 25, 15
            InitialKeyRepeat = 15;
            NSAutomaticCapitalizationEnabled = false;
            NSAutomaticDashSubstitutionEnabled = false;
            NSAutomaticPeriodSubstitutionEnabled = false;
            NSAutomaticQuoteSubstitutionEnabled = false;
            NSAutomaticSpellingCorrectionEnabled = false;
            NSNavPanelExpandedStateForSaveMode = true;
            NSNavPanelExpandedStateForSaveMode2 = true;
            PMPrintingExpandedStateForPrint = true;
            PMPrintingExpandedStateForPrint2 = true;
          };
          CustomSystemPreferences = {
            "com.apple.DiskUtility" = {
              "DUDebugMenuEnabled" = true;
              "advanced-image-options" = true;
            };
            "com.apple.ImageCapture".disableHotPlug = true;
            "com.apple.mail".DisableInlineAttachmentViewing = true;
            "com.apple.SoftwareUpdate" = {
              "AutomaticCheckEnabled" = true;
              "ScheduleFrequency" = 1; # weekly
              "AutomaticDownload" = 1;
              "CriticalUpdateInstall" = 1;
            };
            "com.apple.print.PrintingPrefs" = {
              "Quit When Finished" = true;
            };
            "com.apple.desktopservices" = {
              "DSDontWriteNetworkStores" = true;
              "DSDontWriteUSBStores" = true;
            };
          };
          screencapture = {
            location = "~/Documents/";
            type = "png";
          };
          trackpad = {
            Clicking = true;
            TrackpadThreeFingerDrag = true;
          };
          WindowManager.EnableStandardClickToShowDesktop = false;
        };
        activationScripts.postActivation.text = ''
            echo "Do you want to apply Safari configurations? (requires Full Disk Access)"
            read -r -p "Continue? (y/n) " -n 1 REPLY
            printf "\n"
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
              sudo -u ${user} defaults -currentHost write com.apple.Safari ShowOverlayStatusBar -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari AlwaysRestoreSessionAtLaunch -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari UniversalSearchEnabled -bool false
              sudo -u ${user} defaults -currentHost write com.apple.Safari SuppressSearchSuggestions -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari ShowFullURLInSmartSearchField -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari.SandboxBroker HomePage -string ""
              sudo -u ${user} defaults -currentHost write com.apple.Safari HomePage -string ""
              # 0 - homepage, 1 - empty page, 2 - same page, 3 - bookmarks
              sudo -u ${user} defaults -currentHost write com.apple.Safari NewWindowBehavior 1
              sudo -u ${user} defaults -currentHost write com.apple.Safari NewTabBehavior 1
              sudo -u ${user} defaults -currentHost write com.apple.Safari AutoOpenSafeDownloads -bool false
              sudo -u ${user} defaults -currentHost write com.apple.Safari DebugSnapshotsUpdatePolicy -2
              sudo -u ${user} defaults -currentHost write com.apple.Safari IncludeInternalDebugMenu -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari IncludeDevelopMenu -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari WebKitDeveloperExtras -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari 'WebKitPreferences.developerExtrasEnabled' -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari 'com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled' -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
              sudo -u ${user} defaults -currentHost write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari WebKitJavaEnabled -bool false
              sudo -u ${user} defaults -currentHost write com.apple.Safari 'com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled' -bool false
              sudo -u ${user} defaults -currentHost write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari StatusMenuVisible -bool true
              sudo -u ${user} defaults -currentHost write com.apple.Safari NSQuitAlwaysKeepsWindows -bool true
              echo "Safari defaults were applied"
            fi

            echo "Do you want to turn on asking password immediately after locking the screen (requires admin's permission)"
            read -r -p "Continue? (y/n) " -n 1 REPLY
            printf "\n"
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
              sudo -u ${user} sysadminctl -screenLock immediate -password -
            fi
        '';
      };
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."home" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = inputs;
      modules = [
        home-manager.darwinModules.home-manager
        systemConfiguration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            inherit user;
            enable = true;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
              "lutzifer/homebrew-tap" = kbs-tap;
            };
            mutableTaps = false;
            autoMigrate = true;
          };
        }
        ./home.nix
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."home".pkgs;
  };
}
