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
    
    # Sync p10k config only if not already present
    if [[ ! -f ~/.p10k.zsh ]]; then
        echo "Syncing p10k config..."
        cp "$REPO_ROOT/config/zsh/.p10k.zsh" ~/
    else
        echo "p10k config already exists. Skipping sync."
    fi
    
    # Source files
    echo "Syncing source files..."
    cp "$REPO_ROOT/src/core/source.zsh" ~/.zsh/
    cp -R "$REPO_ROOT/src/aliases/"* ~/.zsh/aliases/
    cp -R "$REPO_ROOT/src/functions/"* ~/.zsh/functions/

    # Environment setup (if exists)
    if [[ -f "$REPO_ROOT/src/env/.env" ]]; then
        echo "Syncing environment file..."
        cp "$REPO_ROOT/src/env/.env" ~/.zsh/env/
    fi
}

# Execute the sync
sync_configs

# Run setup script for additional configurations
"$SCRIPT_DIR/setup.sh"

echo "Dotfiles synced successfully! 🚀"