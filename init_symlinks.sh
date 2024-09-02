#!/usr/bin/env bash

DOTFILES_REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Symlink repository itself to ~/.dotfiles
DOTFILES_SYMLINK="$HOME/.dotfiles"
COMMON_SYMLINK_DIR="$DOTFILES_SYMLINK/common"
MACOS_SYMLINK_DIR="$DOTFILES_SYMLINK/macos"

OS_TYPE="$(uname -s)"

# sanity check: ensure in root of of repo
[[ -e "./common" ]] && [[ -e ".git" ]] || {
    echo >&2 "Error: Could not find $COMMON_SYMLINK_DIR, or not inside a git repository"
    echo >&2 "Expected to be in the root of dotfiles git repository."
    exit 255
}

symlink_repository_to_dotfiles() {
    if [[ -e "$DOTFILES_SYMLINK" ]]; then
        if [[ ! -L "$DOTFILES_SYMLINK" ]]; then
            echo "$DOTFILES_SYMLINK exists and is not a symlink. Please manually resolve"
            exit 1
        fi
        real_path=$(readlink -f "$DOTFILES_SYMLINK")

        if [[ "$DOTFILES_REPO_DIR" != "$real_path" ]]; then
            echo >&2 "Error: $DOTFILES_SYMLINK symlink already exists, but resolves to different directory $real_path"
            exit 1
        fi

        echo "OK: Symlinks already exists $DOTFILES_REPO_DIR > $DOTFILES_SYMLINK"
    else
        echo "$DOTFILES_SYMLINK does not exist already, creating..."
        ln -s "$DOTFILES_REPO_DIR" "$DOTFILES_SYMLINK"

        [[ -L "$DOTFILES_SYMLINK" ]] && echo "OK: Symlink created" || {
            echo >&2 "Error: Could not create symlink"
            exit 1
        }
    fi
}

prompt_for_existing_file() {
    local target="$1"
    local directory
    local filename
    local backup_filename

    echo
    echo "$target already exists. What would you like to do?"
    select choice in "Back up (rename) and overwrite" "Overwrite without backup (only if symlink)" "Skip" "Abort"; do
        case $choice in
        "Back up (rename) and overwrite")
            directory=$(dirname "$target")
            filename=$(basename "$target")
            filename_without_leading_dot_if_present=${filename#.}

            backup_filename="${directory}/.predotfiles_symlink.${filename_without_leading_dot_if_present}"

            mv "$target" "$backup_filename"
            echo "Backed up $target to $BACKUP_DIR/"
            return 0
            ;;
         "Overwrite without backup (only if symlink)")
            if [[ -L "$target" ]]; then
                echo "Overwriting existing symlink: $target"
                rm "$target"
                return 0
            else
                echo >&2 "Error: $target is not a symlink. Cannot overwrite without backup." && exit 3
            fi
            ;;
        "Skip")
            echo "Skipping $target"
            return 1
            ;;
        "Abort")
            echo "Aborting setup!"
            exit 1
            ;;
        esac
    done
}

check_already_symlinked_ok() {
    local source="$1"
    local target="$2"
    local real_path

    if [[ -L "$target" ]]; then
        real_path=$(readlink "$target")

        if [[ "$real_path" == "$source" ]]; then
            echo "OK: Symlink already exists $target -> $source"
            return 0
        else
            echo "Warning: $target is a symlink, but it points to $real_path instead of $source"
            return 1
        fi
    else
        return 1
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"
    local real_path

    # remove broken symlinks
    if [[ ! -e "$target" ]] && [[ -L "$target" ]]; then
        echo "Warning: Unlinking broken symlink $target"
        unlink "$target"
    fi

    if [[ -e "$target" ]]; then
        if check_already_symlinked_ok "$source" "$target"; then
            # nothing to do - symlink already OK
            return
        fi

        prompt_for_existing_file "$target" || return
    fi

    ln -s "$source" "$target"
    echo "OK: Symlink created: $target -> $source"
}

# Zsh setup (include oh-my-posh theme + zinit snippt, optionally navi zinit snippet)
setup_zsh_symlinks() {
    echo "Setting up Zsh configuration..."

    declare -A ZSH_SYMLINKS=(
        ["$COMMON_SYMLINK_DIR/zsh/zshrc"]="$HOME/.zshrc"
        ["$COMMON_SYMLINK_DIR/ohmyposh/theme.toml"]="$HOME/.config/ohmyposh/theme.toml"
        ["$COMMON_SYMLINK_DIR/zsh/ohmyposh.zsh"]="$HOME/.config/zsh/ohmyposh.zsh" # zinit snippet wrapper
    )

    for source in "${!ZSH_SYMLINKS[@]}"; do
        target="${ZSH_SYMLINKS[$source]}"
        create_symlink "$source" "$target"
    done

    read -p "Do you want to include Navi widget in the Zsh setup? (y/n): " include_navi
    if [[ "$include_navi" == "y" ]]; then
        create_symlink "$COMMON_SYMLINK_DIR/zsh/navi.zsh" "$HOME/.config/zsh/navi.zsh"
    fi
}

symlink_standalone_components() {
    declare -A SYMLINKS=(
        ["$COMMON_SYMLINK_DIR/alacritty/alacritty.toml"]="$HOME/.config/alacritty/alacritty.toml"
        ["$COMMON_SYMLINK_DIR/pgcli/config"]="$HOME/.config/pgcli/config"
        ["$COMMON_SYMLINK_DIR/tmux/tmux.config"]="$HOME/.tmux.conf"
        ["$COMMON_SYMLINK_DIR/bat/config"]="$HOME/.config/bat/config"
        ["$COMMON_SYMLINK_DIR/vim/vimrc"]="$HOME/.vimrc"
    )

    if [[ "$OS_TYPE" == "Darwin" ]]; then
        SYMLINKS["$MACOS_SYMLINK_DIR/yabai/yabairc"]="$HOME/.config/yabai/yabairc"
        SYMLINKS["$MACOS_SYMLINK_DIR/skhd/skhdrc"]="$HOME/.config/skhd/skhdrc"
    fi

    for source in "${!SYMLINKS[@]}"; do
        target="${SYMLINKS[$source]}"
        if [[ ! -e "$target" ]]; then
            read -p "Do you want to create the symlink for $target? (y/n) " choice
            if [[ "$choice" == "y" ]]; then
                target_dir=$(dirname "$target")

                if [[ ! -d "$target_dir" ]]; then
                    echo "Warning: Directory did not exist, creating: $target_dir"
                    mkdir -p "$target_dir"
                fi

                create_symlink "$source" "$target"
            else
                echo "Skipping $target."
            fi
        fi
        create_symlink "$source" "$target"
    done
}


symlink_bin_scripts() {
    declare -A BIN_SCRIPTS=(
        ["$COMMON_SYMLINK_DIR/bin/uptime_human_readable"]="Displays system uptime in a human-readable format|Integrated in tmux configuration"
        ["$COMMON_SYMLINK_DIR/bin/yabai_get_focused_window_label"]="Fetches the focused window label title|Integrated in tmux configuration"
    )

    echo "Setting up symlinks for bin scripts..."
    mkdir -p "$HOME/bin" # Ensure directory exists

    for source in "${!BIN_SCRIPTS[@]}"; do
        target="$HOME/bin/$(basename "$source")"

        echo ""
        IFS='|' read -r description additional_info <<< "${BIN_SCRIPTS[$source]}"
        description=$(echo "$description" | xargs)

        echo "Script: $(basename "$source")"
        echo "Description: $description"
        echo "Additional Info: $additional_info"

        read -p "Would you like to symlink this script? (y/n): " choice
        if [[ "$choice" == "y" ]]; then
            create_symlink "$source" "$target"
        else
            echo "Skipping $source"
        fi
    done
}

echo "Starting dotfiles symlink setup..."

symlink_repository_to_dotfiles
echo ""

read -p "Do you want to set up Zsh (including Oh My Posh, and optionally navi)? (y/n): " symlink_zsh
[[ "$symlink_zsh" == "y" ]] && setup_zsh_symlinks || echo "Skipping Zsh setup..."
echo ""

symlink_standalone_components

read -p "Do you want to set up symlinks for bin scripts (some of these might be utilized in configuraiton files)? (y/n): " symlink_bin
[[ "$symlink_bin" == "y" ]] && symlink_bin_scripts || echo "Skipping bin scripts symlink setup..."
echo ""

echo "OK: Dotfiles setup complete"

exit 0

