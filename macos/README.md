# macOS Configuration Files

![Tiled view](https://i.imgur.com/n6kSVy6.png)

This directory contains my personal configuration files and scripts for macOS. The tools and configurations are optimized for my workflow, focusing on tiling window management, custom keyboard mappings, and productivity enhancements.

## Overview

### `initial_install.sh`
This script installs the essential tools and apps I use on macOS. It is safe to run multiple times, skipping already installed tools or updating outdated ones. You'll be prompted before installing non-essential tools like window managers or GUI apps.

Run the script from the root of the dotfiles repo. Do not run it directly from the `macos` directory.

#### Breakdown:
- **Required CLI Tools for ZSH**: Includes tools necessary for `.zshrc`, like `fzf`, `oh-my-posh`, and `zoxide`.
- **Recommended CLI Tools** and **GUI Apps**: Improve the terminal and overall productivity experience with tools like `ripgrep`, `bat`, `tmux`, and apps like `Alacritty`, `Obsidian`, and `Alfred`.
- See the script for a full list of tools.

### Configuration Files
- **karabiner/karabiner.json**: Keyboard mappings via [Karabiner-Elements](https://karabiner-elements.pqrs.org), including Caps Lock as a HyperKey.
- **yabai/yabairc**: Configuration for [Yabai](https://github.com/koekeishiya/yabai), a macOS tiling window manager.
- **skhd/skhdrc**: Hotkey daemon config for [SKHD](https://github.com/koekeishiya/skhd) to control window management shortcuts.

## Installation

1. **Run the Installation Script**: From the root of the dotfiles repo, run `initial_install.sh` to install necessary and optional tools.
2. **Set Up Symlinks**: Use `init_symlinks.sh` from the root directory to create symlinks for these configuration files.
