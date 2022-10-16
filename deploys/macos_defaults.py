from pyinfra.operations import server

# ref: https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.macos#L148
server.shell(
    [
        "defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true",
        "defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144",
    ],
    name="Enable zoom with Ctrl+Scroll",
    _sudo=True,
)

# ref: https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.macos#L157
server.shell(
    [
        "defaults write NSGlobalDomain KeyRepeat -int 1",
        "defaults write NSGlobalDomain InitialKeyRepeat -int 10",
    ],
    name="Set fast key repetition",
    _sudo=True,
)

# ref: https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.macos#L436
server.shell(
    [
        "defaults write com.apple.dock wvous-br-corner -int 10",
        "defaults write com.apple.dock wvous-br-modifier -int 0",
    ],
    name="Hot corner: bottom right -> display sleep",
    _sudo=True,
)

# ref: https://github.com/mathiasbynens/dotfiles/blob/66ba9b3cc0ca1b29f04b8e39f84e5b034fdb24b6/.macos#L191
server.shell(
    [
        "pmset -a displaysleep 15",
    ],
    name="Display: sleep after 15 minutes",
    _sudo=True,
)

server.shell(
    [
        "defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0",
    ],
    name="Disable system beeps",
    _sudo=True,
)
