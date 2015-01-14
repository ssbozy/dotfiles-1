#!/bin/sh

# Selectively copied from https://gist.github.com/brandonb927/3195465


# Hide spotlight icon
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

# Expand the save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
 
# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
 
# Disable smart quotes and smart dashes? (y/n)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disabling press-and-hold for special keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
 
# Enabling full keyboard access for all controls (enable Tab in modal dialogs, menu windows, etc.)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable auto-correct? (y/n)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Show hidden files in Finder by default? (y/n)
defaults write com.apple.Finder AppleShowAllFiles -bool true

# Show dotfiles in Finder by default? (y/n)
defaults write com.apple.finder AppleShowAllFiles TRUE

# Show all filename extensions in Finder by default? (y/n)
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar in Finder by default? (y/n)
defaults write com.apple.finder ShowStatusBar -bool true

# Display full POSIX path as Finder window title? (y/n)
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension? (y/n)
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creation of .DS_Store files on network volumes? (y/n)
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Allowing text selection in Quick Look/Preview in Finder by default
defaults write com.apple.finder QLEnableTextSelection -bool true

# Privacy: Don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Enabling Safari's debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
 
# Enabling the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

# Adding a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
 
# Disabling the annoying backswipe in Chrome
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Transmission
# Use `~/Downloads/Incomplete` to store incomplete downloads
mkdir -p ~/Downloads/Incomplete
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Incomplete"
# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true
# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false
