from pyinfra.operations import brew, server

brew.packages(["iterm2"], name="Install iTerm")

brew.tap("homebrew/cask-fonts")
brew.casks(["font-fira-code-nerd-font"], name="Install nerdfont")

server.shell(
    "defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string '~/config/dotfiles/iterm'",
    name="Set custom folder for iTerm preferences",
)
server.shell(
    "defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true",
    name="Enable custom folder",
)
