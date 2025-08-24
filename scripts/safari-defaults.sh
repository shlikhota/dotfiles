defaults -currentHost write com.apple.Safari ShowOverlayStatusBar -bool true
defaults -currentHost write com.apple.Safari AlwaysRestoreSessionAtLaunch -bool true
defaults -currentHost write com.apple.Safari UniversalSearchEnabled -bool false
defaults -currentHost write com.apple.Safari SuppressSearchSuggestions -bool true
defaults -currentHost write com.apple.Safari ShowFullURLInSmartSearchField -bool true
defaults -currentHost write com.apple.Safari.SandboxBroker HomePage -string ""
defaults -currentHost write com.apple.Safari HomePage -string ""
1 - empty page, 2 - same page, 3 - bookmarks
defaults -currentHost write com.apple.Safari NewWindowBehavior 1
defaults -currentHost write com.apple.Safari NewTabBehavior 1
defaults -currentHost write com.apple.Safari AutoOpenSafeDownloads -bool false
defaults -currentHost write com.apple.Safari DebugSnapshotsUpdatePolicy -2
defaults -currentHost write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults -currentHost write com.apple.Safari IncludeDevelopMenu -bool true
defaults -currentHost write com.apple.Safari WebKitDeveloperExtras -bool true
defaults -currentHost write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults -currentHost write com.apple.Safari 'WebKitPreferences.developerExtrasEnabled' -bool true
defaults -currentHost write com.apple.Safari 'com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled' -bool true
defaults -currentHost write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
defaults -currentHost write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
defaults -currentHost write com.apple.Safari WebKitJavaEnabled -bool false
defaults -currentHost write com.apple.Safari 'com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled' -bool false
defaults -currentHost write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
defaults -currentHost write com.apple.Safari StatusMenuVisible -bool true
defaults -currentHost write com.apple.Safari NSQuitAlwaysKeepsWindows -bool true
