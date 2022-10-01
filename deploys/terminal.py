from pyinfra.operations import brew, server

brew.packages(["iterm2"])

brew.tap("homebrew/cask-fonts")
brew.casks(["font-fira-code-nerd-font"])

server.shell(
    "defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string '~/config/dotfiles/iterm'"
)
server.shell(
    "defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true"
)
