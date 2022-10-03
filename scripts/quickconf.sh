#!/bin/bash

# @TODO check platform and arch based on uname; choose appropriate binaries
# @TODO detect current shell

QCPATH="$HOME/.quickconf"
PKGPATH="$QCPATH/pkg"
BINPATH="$QCPATH/bin"
CONFPATH="$QCPATH/config"
XDGPATH="$QCPATH/xdg"
XDG_CONFIG="$XDGPATH/config"
XDG_DATA="$XDGPATH/data"
XDG_RUNTIME="$XDGPATH/runtime"
XDG_STATE="$XDGPATH/state"

PREV_CWD=$(pwd)
QC_LINE_TAG="@@QC@@"

export PATH="$BINPATH:$PATH"

#######################################
# Inserts a line into a file if it is
# not present there. Prints a confirmation
# message if provided with.
#
# Arguments:
#   1: file to modify
#   2: line to insert
#   3 (opt): confirmation message
#######################################
add_line_to_file() {
    local file="$1"
    local line="$2"
    local message="$3"

    touch "$file"
    grep -qxF "$line" "$file" || ( ([ -z "$message" ] || gum confirm "$message") && echo "$line" >> "$file")
}

#######################################
# Deletes a line from a file if it is
# contained there.
#
# Arguments:
#   1: file to modify
#   2: line to delete
#######################################
delete_line_from_file() {
    local file="$1"
    local line="$2"

    sed --in-place "/$line/d" "$file"
}

#######################################
# Displays a spinner while running a
# long command.
#
# Arguments:
#   1: spinner title
#   2, ...: command to execute
#
# Examples:
#   longrun "Sleeping..." sleep 3
#######################################
longrun() {
    local title="$1"
    shift
    local cmd="$@"

    ( (gum spin --title "$title" -- $cmd) || (echo "$title" && $cmd) )
}

#######################################
# 1. Downloads a .tar.gz file from $pkg_url
#    to $PKGPATH/$pkg_name.tar.gz
# 2. Extracts it into $PKGPATH/$pkg_name
# 3. Links $PKGPATH/$pkg_name/$pkg_bin
#    to $BINPATH
#
# Globals:
#   PKGPATH
#   BINPATH
#
# Arguments:
#   1: pkg_url: download URL
#   2: pkg_name: save name
#   3: pkg_bin: binary location inside archive
#######################################
install() {
    local pkg_url="$1"
    local pkg_name="$2"
    local pkg_bin="$3"

    mkdir -p $BINPATH
    mkdir -p $PKGPATH
    mkdir -p "$PKGPATH/$pkg_name"

    if [ -z $(ls 2>/dev/null $PKGPATH/$pkg_name/$pkg_bin) ]; then
        longrun \
            "Downloading $pkg_name from $pkg_url" \
            curl -sL "$pkg_url" -o "$PKGPATH/$pkg_name.tar.gz"
        longrun \
            "Extracting $pkg_url" \
            tar -xzf "$PKGPATH/$pkg_name.tar.gz" -C "$PKGPATH/$pkg_name"
    fi

    echo "Linking $PKGPATH/$pkg_name/$pkg_bin"
    ln -sf $(ls $PKGPATH/$pkg_name/$pkg_bin) "$BINPATH"
}

#######################################
# Clones only specified paths of a git repo.
#
# Arguments:
#   1: repo url
#   2: local destination directory
#   3, ...: paths to clone
#######################################
git_sparse_clone() {
    local url="$1"
    local localdir="$2"
    shift 2

    mkdir -p "$localdir"
    cd "$localdir"

    git init
    git branch -m main
    git config pull.ff only
    git remote add -f origin "$url"

    git config core.sparseCheckout true

    for arg; do
        add_line_to_file ".git/info/sparse-checkout" "$arg"
    done

    git pull --depth=1 origin main
}

#######################################
# Installs the following packages:
#   - gum
#   - neovim
#   - starship
#   - fzf
#   - ripgrep
#######################################
install_tools() {
    (
        install \
            "https://github.com/charmbracelet/gum/releases/download/v0.6.0/gum_0.6.0_linux_x86_64.tar.gz" \
            "gum" \
            "gum"
    )

    (
        install \
            "https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.tar.gz" \
            "nvim" \
            "*/bin/nvim"
    )

    (
        install \
            "https://github.com/starship/starship/releases/download/v1.10.3/starship-x86_64-unknown-linux-gnu.tar.gz" \
            "starship" \
            "starship"
    )

    (
        install \
            "https://github.com/junegunn/fzf/releases/download/0.34.0/fzf-0.34.0-linux_amd64.tar.gz" \
            "fzf" \
            "fzf"
    )

    (
        install \
            "https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz" \
            "rg" \
            "*/rg"
    )
}

#######################################
# 1. Clones the following paths from configuration repo:
#    a. dotfiles/nvim
#    b. dotfiles/starship
#    c. bin/inv
# 2. Creates a local XDG container and links config files there.
# 3. Links binaries from config to $BINPATH.
# 4. Creates an rc.sh startup file which:
#    a. aliases nvim to containerized nvim
#    b. aliases inv to containerized inv
#    c. adds $BINPATH to $PATH
#    d. initializes starship prompt
# 5. Adds sourcing rc.sh to .bashrc after confirmation.
# 6. Adds sourcing .bashrc to .bash_profile after confirmation.
#
# Globals:
#   XDG_CONFIG
#   XDG_DATA
#   XDG_RUNTIME
#   XDG_STATE
#   CONFPATH
#   BINPATH
#   QCPATH
#   QC_LINE_TAG
#   PREV_CWD
#######################################
set_configs() {
    git_sparse_clone "https://github.com/konodyuk/config.git" "$CONFPATH" "dotfiles/nvim" "dotfiles/starship" "bin/inv"
    mkdir -p "$XDG_CONFIG"
    mkdir -p "$XDG_DATA"
    mkdir -p "$XDG_RUNTIME"
    mkdir -p "$XDG_STATE"
    mkdir -p "$XDG_CONFIG/nvim"
    ln -sf $CONFPATH/dotfiles/nvim/* $XDG_CONFIG/nvim
    ln -sf $CONFPATH/dotfiles/starship/starship.toml $XDG_CONFIG/starship.toml

    ln -sf $CONFPATH/bin/* $BINPATH

    cat << EOF > $QCPATH/rc.sh
        XDG_ENV="XDG_CONFIG_HOME=$XDG_CONFIG XDG_DATA_HOME=$XDG_DATA XDG_RUNTIME_DIR=$XDG_RUNTIME XDG_STATE_HOME=$XDG_STATE"
        alias nvim="\$XDG_ENV nvim"
        alias inv="\$XDG_ENV inv"

        PATH="$BINPATH:\$PATH"

        eval "\$(XDG_CONFIG_HOME=$XDG_CONFIG starship init bash)"
EOF

    add_line_to_file \
        "$HOME/.bashrc" \
        "source $QCPATH/rc.sh || true # QuickConf line, do not edit $QC_LINE_TAG" \
        'Enable starship prompt and installed binaries? `~/.bashrc` will be modified'

    add_line_to_file \
        "$HOME/.bash_profile" \
        "source $QCPATH/.bashrc || true # QuickConf line, do not edit $QC_LINE_TAG" \
        'Enable the configuration in login shell (e.g. SSH)? `~/.bash_profile` will be modified'

    # gum confirm "Apply changes to the current shell?" && cd "$PREV_CWD" && bash
    echo 'Successfully installed. Run `bash` to apply changes.'
}

#######################################
# 1. Deletes sourcing rc.sh from .bashrc.
# 2. Deletes sourcing .bashrc from .bash_profile.
# 3. Deletes $QCPATH container.
#
# Globals:
#   QC_LINE_TAG
#   QCPATH
#######################################
uninstall() {
    delete_line_from_file \
        "$HOME/.bashrc" \
        "$QC_LINE_TAG"

    delete_line_from_file \
        "$HOME/.bash_profile" \
        "$QC_LINE_TAG"

    longrun "Removing files..." rm -rf $QCPATH

    # bash
    echo 'Successfully uninstalled. Run `bash` to apply changes.'
}

#######################################
# Runs installation or uninstallation.
#
# Arguments:
#   1: command: 'install' (default) or 'uninstall'
#######################################
main() {
    local command=${1:-"install"}

    if [ "$command" = 'install' ]; then
        install_tools
        set_configs
        return
    fi

    if [ "$command" = 'uninstall' ]; then
        uninstall
        return
    fi

    echo "Unknown command: $command"
}

main "$@"
