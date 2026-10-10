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

# Sync dotfiles into place first, so shell helpers are available immediately
"$SCRIPT_DIR/sync.sh"

# Install tools from enabled profiles (flags are forwarded to tools.sh, e.g. --dry-run)
echo "Looking for tool configs in: $DOTFILES_DIR/config/tools"
bash "$SCRIPT_DIR/tools.sh" install "$@"

# Install VS Code extensions when the 'code' CLI is available
if command -v code &> /dev/null; then
  bash "$SCRIPT_DIR/tools.sh" vscode "$@"
fi

echo "🎉 Installation complete! Please restart your terminal."
echo "   Manage profiles with: tools.sh list | enable <profile> | disable <profile> | status"
