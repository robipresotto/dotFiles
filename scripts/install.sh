#!/bin/bash

set -e

# Get the absolute path of the dotfiles repository
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Debug info
echo "Script directory: $SCRIPT_DIR"
echo "Dotfiles directory: $DOTFILES_DIR"

# Create config directory and store path
CONFIG_DIR="$HOME/.config/dotfiles"
mkdir -p "$CONFIG_DIR"
echo "DOTFILES_PATH=\"$DOTFILES_DIR\"" > "$CONFIG_DIR/config"

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