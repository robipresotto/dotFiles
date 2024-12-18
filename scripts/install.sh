#!/bin/bash

set -e

# Get the absolute path of the dotfiles repository
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Debug info
echo "Script directory: $SCRIPT_DIR"
echo "Dotfiles directory: $DOTFILES_DIR"

# Create symlink to standardize location
echo "Setting up dotfiles in ~/.dotfiles..."
if [ -e "$HOME/.dotfiles" ]; then
    echo "Removing existing .dotfiles symlink..."
    rm "$HOME/.dotfiles"
fi
ln -s "$DOTFILES_DIR" "$HOME/.dotfiles"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Check system requirements
check_system_requirements

# Install core dependencies
install_core_dependencies

# Setup directory structure
setup_directories

# Install tools from config
echo "Looking for tool configs in: $DOTFILES_DIR/config/tools"
install_tools_from_config "$DOTFILES_DIR/config/tools"

# Sync dotfiles
"$SCRIPT_DIR/sync.sh"

echo "🎉 Installation complete! Please restart your terminal."