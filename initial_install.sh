#!/usr/bin/env bash
# Except for the darwin_install_essentials below, nothing is installed without explicit reply=y

os=$(uname -s)
echo "Detected OS: $os"

# Ensure either mac with homebrew pre-installed or 'apt' available
check_os_supported_and_ready() {
    if [[ "$os" == "Darwin" ]]; then
        if ! command -v brew &>/dev/null; then
            >&2 echo "Could not locate 'brew' in path - please refer to https://brew.sh for installation"
            return 1
        fi
    else
        if ! command -v apt-get &>/dev/null; then
            >&2 echo "Only Debian (and Debian based distributions using 'apt') are supported"
            return 1
        fi
    fi
}

# MacOS comes prebundled with outdated FreeBSD based CLI tools - install GNU ones + VIM
darwin_install_essentials() {
    echo "Ensuring essential GNU libraries are installed..."

    if ! brew list coreutils &>/dev/null; then
        echo "Installing GNU coreutils..."
        brew install coreutils
    else
        echo "GNU coreutils is already installed."
    fi

    if ! brew list diffutils &>/dev/null; then
        echo "Installing GNU diffutils..."
        brew install diffutils
    else
        echo "GNU diffutils is already installed."
    fi

    if ! brew list bash &>/dev/null; then
        echo "Installing updated version of bash..."
        brew install bash
    else
        echo "Updated version of bash is already installed."
    fi

    if ! brew list git &>/dev/null; then
        echo "Installing git..."
        brew install git
    else
        echo "Git is already installed."
    fi

    if ! brew list vim &>/dev/null; then
        echo "Installing vim..."
        brew install vim
    else
        echo "Vim is already installed."
    fi
}

check_os_supported_and_ready || {
    echo >&2 'Could not bootstrap. Exiting'
    exit 2
}

if [[ "$os" == "Darwin" ]]; then
    # https://stackoverflow.com/questions/15371925/how-to-check-if-xcode-command-line-tools-are-installed
    # returns error code 2 if not installed
    xcode-select -p &> /dev/null && echo "XCode developer tools already installed." || {
        echo "Installing XCode developer tools"
        xcode-select --install
    }

    darwin_install_essentials

    echo "Essential tools are installed. Proceeding with MacOS specifics..."
    ./macos/initial_install.sh
else
    echo "Proceeding via 'apt'..."
    echo >&2 "Not yet supported"
    exit 2
fi
