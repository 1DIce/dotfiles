defaults write -g ApplePressAndHoldEnabled -bool false
# Remove prefiously set global default
defaults delete -g ApplePressAndHoldEnabled

# VIM keys
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.jetbrains.intellij ApplePressAndHoldEnabled -bool false
defaults write com.jetbrains.pycharm ApplePressAndHoldEnabled -bool false
defaults write com.jetbrains.goland ApplePressAndHoldEnabled -bool false
defaults write com.googlecode.iterm2 ApplePressAndHoldEnabled -bool false

# Show hidden files in finder
defaults write com.apple.finder AppleShowAllFiles true

# show path bar
defaults write com.apple.finder ShowPathbar -bool true

# show status bar
defaults write com.apple.finder ShowStatusBar -bool true

killall Finder;
