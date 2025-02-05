#!/usr/bin/env bash

colima_installed=false

declare -A recommended_cli_tools=(
    [nvm]="https://github.com/nvm-sh/nvm|A tool to switch between (and download) different node versions"
    [universal-ctags]="https://github.com/universal-ctags/ctags|A maintained ctags implementation (required for 'vim-tagbar' plugin to work)"
    [ripgrep]="https://github.com/BurntSushi/ripgrep|Very quick recursive search which respects .gitignore"
    [bat]="https://github.com/sharkdp/bat|A cat clone with syntax highlighting and custom theme support"
    [neovim]="https://github.com/neovim/neovim|Vim-fork focused on extensability and usability"
    [delta]="https://github.com/dandavison/delta|A syntax-highlighting pager for git, diff, grep and blame output (supports custom themes, same as bat)"
    [hexyl]="https://github.com/sharkdp/hexyl|A modern CLI hex viewer written in Rust"
    [btop]="https://github.com/aristocratos/btop|A fancy system resource monitor tool which suppors custom themes"
    [jq]="https://github.com/jqlang/jq|A very powerful CLI JSON processor"
    [tmux]="https://github.com/tmux/tmux|The most popular terminal multiplexer"
    [kubernetes-cli]="https://github.com/kubernetes/kubectl|kubectl - Kubernetes command-line interface"
    [openshift-cli]="https://github.com/openshift/oc|The OpenShift command-line interface"
    [stern]="https://github.com/stern/stern|Multi pod and container log tailing for kubernetes"
    [pgcli]="https://github.com/dbcli/pgcli|Postgres CLI with autocompletion and syntax highlighting"
)

declare -A required_cli_tools_zsh_integrated=(
    [zoxide]="https://github.com/ajeetdsouza/zoxide|A smarter 'cd' command which remembers your most frequent directories"
    [fzf]="https://github.com/junegunn/fzf|CLI fuzzy finder"
    [oh-my-posh]="https://github.com/JanDeDobbeleer/oh-my-posh|Prompt renderer, replacing powerlevel10k which is in life support"
)

declare -A recommended_cli_tools_zshrc_integrated=(
    [eza]="https://github.com/eza-community/eza|Modern replacement for ls"
    [fd]="https://github.com/sharkdp/fd|A modern, simple, fast and user-friendly alternative to 'find'"
    [navi]="https://github.com/denisidoro/navi|Interactive cheatsheet tool for the terminal, included as a ZSH widget (CTRL+G)"
)

declare -A recommended_gui_apps=(
    [alacritty]="https://github.com/alacritty/alacritty|A fast, cross-platform, OpenGL terminal emulator"
    [alfred]="https://www.alfredapp.com|A productivity app that boosts your efficiency with hotkeys, keywords, text expansion, and more"
    [alt-tab]="https://alt-tab-macos.netlify.app|A macOS utility that lets you switch between open apps and windows using Alt-Tab like in Windows"
    [firefox@developer-edition]="https://www.mozilla.org/en-US/firefox/developer|A version of Firefox tailored for web developers"
    [obsidian]="https://obsidian.md|A powerful knowledge base that works on local Markdown files"
    [karabiner-elements]="https://karabiner-elements.pqrs.org|A powerful keyboard customizer for macOS. Useful for mapping Caps Lock into a HyperKey (Ctrl+Shift+Option+Cmd) and making Windows keyboards mac-friendly by switching key positions."
    [jetbrains-toolbox]="https://www.jetbrains.com/toolbox-app|An all-in-one tool to manage your JetBrains IDEs"
    [sublime-text]="https://www.sublimetext.com|A sophisticated text editor for code, markup, and prose"
    [visual-studio-code]="https://code.visualstudio.com|A lightweight but powerful source code editor"
    [bruno]="https://github.com/usebruno/bruno|An open-source, offline Postman alternative"
)

check_zsh_up_to_date() {
    local zsh_version_homebrew
    local installed_zsh_version
    installed_zsh_version=$(zsh --version | grep -o -E '[0-9.]+' | head -n 1)
    zsh_version_homebrew=$(brew info zsh | head -n 1 | grep -o -E '[0-9.]+')

    if [[ "$zsh_version_homebrew" != "$installed_zsh_version" ]]; then
        echo >&2 "Warning: Pre-installed zsh version=${installed_zsh_version} is out of date. Homebrew provides version=${zsh_version_homebrew}"
        echo
        read -p "Would you like to proceed? (y/n)" proceed_yes_no

        if [[ $proceed_yes_no != "y" ]]; then
            echo "Exiting because proceed != 'y'"
            exit 1
        fi
    fi
}

prompt_install_colima_docker() {
    local install_colima_docker
    echo "See Colima on GitHub: https://github.com/abiosoft/colima"
    echo
    read -p "Would you like to install Colima and Docker runtime (no Docker Desktop)? (y/n): " install_colima_docker

    if [[ "$install_colima_docker" == "y" ]]; then
        echo "Installing Colima and Docker runtime..."
        brew install --formula colima docker docker-compose
        colima_installed=true
    else
        echo "Skipping Colima and Docker installation."
    fi
}

post_install_colima_docker_prompt() {
    echo "Successfully installed colima (using Docker runtime)"
    echo "You can start colima using 'colima start --edit'."
    echo "The --edit flag is optional, but is encouraged as it allows you to customize the resources of the VM (default resources might be high for some setups)"
}

prompt_install_required_cli_tools_zshrc_integrated() {
    echo "The following CLI tools are required for .zshrc to work and will be installed:"

    local tools_for_install=()
    local all_tools_installed=true

    for tool in "${!required_cli_tools_zsh_integrated[@]}"; do
        IFS="|" read -r url description <<< "${required_cli_tools_zsh_integrated[$tool]}"
        if ! brew ls "$tool" &> /dev/null; then
            all_tools_installed=false
            echo "$tool: $description"
            echo "See GitHub repository: $url"
            echo

            tools_for_install+=("$tool")
        else
            echo "$tool already installed. Skipping..."
        fi
    done

    if $all_tools_installed; then
        echo "All required tools are already installed. Proceeding..."
        return 0
    fi


    read -p "Would you like to proceed with installing these required tools? (y/n): " proceed_yes_no
    if [[ "$proceed_yes_no" != "y" ]]; then
        echo "Exiting because proceed != 'y'"
        exit 1
    fi

    for tool in "${tools_for_install[@]}"; do
        brew install --formula "$tool"
    done

    echo "oh-my-posh is designed to Nerd Fonts, and therefore a Nerd Font is required. Without it, icons might not be displayed correctly."
    read -p "Would you like to install 'font-meslo-lg-nerd-font'? (y/n):" install_font

    if [[ "$install_font" == "y" ]]; then
        brew install --cask font-meslo-lg-nerd-font
    else
        echo "Skipping installation of 'font-meslo-lg-nerd-font'."
        echo "Icons will NOT render correctly until a NerdFont is installed and configured in the terminal"
    fi
}

prompt_install_recommended_cli_tools_zshrc_integrated() {
    echo "The following ZSH tools are recommended and integrated with .zshrc:"
    for tool in "${!recommended_cli_tools_zshrc_integrated[@]}"; do
        IFS="|" read -r url description <<< "${recommended_cli_tools_zshrc_integrated[$tool]}"
        echo "$tool: $description"
        echo "See GitHub repository: $url"

        echo
        brew ls "$tool" &>/dev/null && echo "$tool already installed. Skipping..." || {
            read -p "Would you like to install $tool? (y/n): " install_tool
            if [[ "$install_tool" == "y" ]]; then
                brew install --formula "$tool"
            else
                echo "Skipping $tool installation."
            fi
        }
    done
}

prompt_install_recommended_cli_tools() {
    echo "The following CLI tools are recommended:"
    for tool in "${!recommended_cli_tools[@]}"; do
        IFS="|" read -r url description <<< "${recommended_cli_tools[$tool]}"
        echo "$tool: $description"
        echo "See GitHub repository: $url"

        echo
        brew ls "$tool" &>/dev/null && echo "$tool already installed. Skipping..." || {
            read -p "Would you like to install $tool? (y/n): " install_tool

            if [[ "$install_tool" == "y" ]]; then
                brew install --formula "$tool"
            else
                echo "Skipping $tool installation."
            fi
        }
    done
}

prompt_install_security_tools() {
    if profiles status -type enrollment | grep -q "Enrolled"; then
        echo "This Mac is managed by an MDM (Mobile Device Management). Skipping Lulu installation."
        echo
        return 1
    fi

    echo "Lulu is a free, open source macOS firewall that blocks unknown outgoing connections."
    echo "This is only recommended for personal use".
    echo "You can visit the GitHub repository here: https://github.com/objective-see/LuLu"
    echo

    brew ls lulu &>/dev/null && echo "Lulu already installed. Skipping..." || {
        read -p "Would you like to install LuLu? (y/n): " install_app

        if [[ "$install_app" == "y" ]]; then
            brew install --cask lulu
        else
            echo "Skipping LuLu installation."
        fi
    }
}

prompt_install_sdkman() {
    echo "sdkman is a tool to seamlessly switch between (and install) different JVM based SDKs."
    echo
    brew ls sdkman-cli &>/dev/null && echo "sdkman is already installed. Skipping..." || {
        read -p "Would you like to install sdkman? (y/n): " install_tool

        if [[ "$install_tool" == "y" ]]; then
            brew tap sdkman/tap && brew install sdkman-cli
        fi
    }
}

prompt_install_tiling_window_manager() {
    echo "This will install the AeroSpace tiling window manager, and JankyBorders to draw active window borders."
    echo "AeroSpace is a window management that extends the built in window manager of macOS."
    echo "It is very important that you read on GitHub if you decide to install"
    echo "See the GitHub repository here: https://github.com/nikitabobko/AeroSpace"
    echo "And also: https://github.com/FelixKratz/JankyBorders"
    echo

    brew ls aerospace &>/dev/null &>/dev/null && echo "AeroSpace already installed. Skipping..." || {
        read -p "Would you like to install window management tools (y/n)? " install_window_tools

        if [[ "$install_window_tools" == "y" ]]; then
            brew install --cask nikitabobko/tap/aerospace
            brew install FelixKratz/formulae/borders
        else
            echo "Skipping window management tools."
        fi
    }
}

prompt_install_recommended_gui_apps() {
    echo "The following GUI applications are recommended (not necessarily all at once):"
    for tool in "${!recommended_gui_apps[@]}"; do
        IFS="|" read -r url description <<< "${recommended_gui_apps[$tool]}"
        echo "$tool: $description"
        echo "See official website: $url"

        echo
        brew ls "$tool" &>/dev/null && echo "$tool already installed. Skipping..." || {
            read -p "Would you like to install $tool via brew? (y/n): " install_app

            if [[ "$install_app" == "y" ]]; then
                brew install --cask "$tool"
            else
                echo "Skipping $tool installation."
            fi
        }
    done
}

check_zsh_up_to_date # I can't ever remember manually installing zsh, and it's currently up to date - so this is mostly out of curiosity

brew ls colima &>/dev/null && echo "Colima already installed, skipping." || prompt_install_colima_docker

prompt_install_required_cli_tools_zshrc_integrated
prompt_install_recommended_cli_tools_zshrc_integrated
prompt_install_sdkman
prompt_install_recommended_cli_tools

prompt_install_security_tools
prompt_install_tiling_window_manager

prompt_install_recommended_gui_apps

$colima_installed && post_install_colima_docker_prompt

