{ user, ... }:

{
  # https://daiderd.com/nix-darwin/manual/index.html
  system.defaults = {
    controlcenter = {
      BatteryShowPercentage = false;
      Sound = true;
      Bluetooth = true;
    };
    dock = {
      autohide = true;
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
        "/System/Applications/App Store.app/"
      ];
    };
    finder = {
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      AppleShowAllFiles = true;
      ShowStatusBar = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
      # "icnv" = Icon view, "Nlsv" = List view, "clmv" = Column View, "Flwv" = Gallery View The default is icnv.
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
      _HIHideMenuBar = true;
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
      location = "/Users/${user}/Documents/";
      type = "png";
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
    WindowManager.EnableStandardClickToShowDesktop = false;
  };

  # Login items and preference activation
  system.activationScripts.postActivation.text = ''
    echo "Configuring login items..."
    sudo -u "${user}" bash -c '
      for app in "Raycast" "Shortcat"; do
        exists=$(osascript -e "tell application \"System Events\" to get the name of every login item" 2>/dev/null | grep -c "$app" || true)
        if [ "$exists" -eq 0 ]; then
          osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"/Applications/$app.app\", hidden:false}" &>/dev/null
          echo "  added login item: $app"
        else
          echo "  login item already exists: $app"
        fi
      done
    '

    # Input sources and keyboard settings (use defaults write to merge, not replace domain)
    sudo -u "${user}" defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string "com.apple.keylayout.US"
    sudo -u "${user}" defaults write com.apple.HIToolbox AppleDictationAutoEnable -int 0
    sudo -u "${user}" defaults write com.apple.HIToolbox AppleEnabledInputSources '
      <array>
        <dict>
          <key>InputSourceKind</key><string>Keyboard Layout</string>
          <key>KeyboardLayout ID</key><integer>0</integer>
          <key>KeyboardLayout Name</key><string>U.S.</string>
        </dict>
        <dict>
          <key>InputSourceKind</key><string>Keyboard Layout</string>
          <key>KeyboardLayout ID</key><integer>19456</integer>
          <key>KeyboardLayout Name</key><string>Russian</string>
        </dict>
        <dict>
          <key>InputSourceKind</key><string>Keyboard Layout</string>
          <key>KeyboardLayout ID</key><integer>30778</integer>
          <key>KeyboardLayout Name</key><string>Czech-QWERTY</string>
        </dict>
        <dict>
          <key>Bundle ID</key><string>com.apple.CharacterPaletteIM</string>
          <key>InputSourceKind</key><string>Non Keyboard Input Method</string>
        </dict>
        <dict>
          <key>Bundle ID</key><string>com.apple.PressAndHold</string>
          <key>InputSourceKind</key><string>Non Keyboard Input Method</string>
        </dict>
      </array>'
    sudo -u "${user}" defaults write com.apple.HIToolbox AppleInputSourceHistory '
      <array>
        <dict>
          <key>InputSourceKind</key><string>Keyboard Layout</string>
          <key>KeyboardLayout ID</key><integer>0</integer>
          <key>KeyboardLayout Name</key><string>U.S.</string>
        </dict>
      </array>'
    sudo -u "${user}" defaults write com.apple.HIToolbox AppleSelectedInputSources '
      <array>
        <dict>
          <key>InputSourceKind</key><string>Keyboard Layout</string>
          <key>KeyboardLayout ID</key><integer>0</integer>
          <key>KeyboardLayout Name</key><string>U.S.</string>
        </dict>
      </array>'

    # Disable Spotlight shortcut (Cmd+Space) so Raycast can use it
    sudo -u "${user}" defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "64" '
      <dict>
        <key>enabled</key><false/>
        <key>value</key><dict>
          <key>parameters</key>
          <array>
            <integer>65535</integer>
            <integer>49</integer>
            <integer>1048576</integer>
          </array>
          <key>type</key><string>standard</string>
        </dict>
      </dict>'
    # Disable dictation shortcut (double-press Globe/Fn key)
    sudo -u "${user}" defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "164" '
      <dict>
        <key>enabled</key><false/>
        <key>value</key><dict>
          <key>parameters</key>
          <array>
            <integer>65535</integer>
            <integer>65535</integer>
            <integer>0</integer>
          </array>
          <key>type</key><string>standard</string>
        </dict>
      </dict>'

    # Trackpad: tap to click + three-finger drag (currentHost domain required for runtime effect)
    sudo -u "${user}" defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    sudo -u "${user}" defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerDragGesture -bool true

    sudo -u "${user}" /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
