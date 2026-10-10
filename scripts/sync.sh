#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Source dotfiles path from config
CONFIG_FILE="$HOME/.config/dotfiles/config"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    REPO_ROOT="$DOTFILES_PATH"
fi

# Debug information
echo "Script directory: $SCRIPT_DIR"
echo "Repository root: $REPO_ROOT"

# Sync config files
sync_configs() {
    echo "Syncing configurations..."
    
    # Create required directories
    mkdir -p ~/.zsh/{aliases,functions,env}
    
    # Git configs
    echo "Syncing git configs..."
    cp "$REPO_ROOT/config/git/.gitconfig" ~/
    cp "$REPO_ROOT/config/git/.gitignore_global" ~/

    # Zsh configs
    echo "Syncing zsh configs..."
    cp "$REPO_ROOT/config/zsh/.zshrc" ~/
    
    # P10k: keep ~/.p10k.zsh as a symlink to the repo so config changes
    # are version-controlled (a one-time backup is kept if it's a regular file)
    if [[ -f ~/.p10k.zsh && ! -L ~/.p10k.zsh ]]; then
        backup="$HOME/.p10k.zsh.bak.$(date +%Y%m%d%H%M%S)"
        echo "Backing up existing p10k config to $backup"
        mv ~/.p10k.zsh "$backup"
    fi
    if [[ -L ~/.p10k.zsh && "$(readlink ~/.p10k.zsh)" == "$REPO_ROOT/config/zsh/.p10k.zsh" ]]; then
        echo "p10k config already linked. Skipping."
    else
        echo "Linking p10k config..."
        ln -sf "$REPO_ROOT/config/zsh/.p10k.zsh" ~/.p10k.zsh
    fi
    
    # Source files (rsync --delete keeps ~/.zsh in sync when files are removed/renamed)
    echo "Syncing source files..."
    cp "$REPO_ROOT/src/core/source.zsh" ~/.zsh/
    rsync -a --delete "$REPO_ROOT/src/aliases/" ~/.zsh/aliases/
    rsync -a --delete "$REPO_ROOT/src/functions/" ~/.zsh/functions/

    # Environment setup (if exists)
    if [[ -f "$REPO_ROOT/config/env/.env" ]]; then
        echo "Syncing environment file..."
        cp "$REPO_ROOT/config/env/.env" ~/.zsh/env/
    fi
}

# Execute the sync
sync_configs

# Run setup script for additional configurations
"$SCRIPT_DIR/setup.sh"

echo "Dotfiles synced successfully! 🚀"