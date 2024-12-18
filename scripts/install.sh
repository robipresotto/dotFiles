#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Check system requirements
check_system_requirements

# Install core dependencies
install_core_dependencies

# Setup directory structure
setup_directories

# Install tools from config
install_tools_from_config "$REPO_ROOT/config/tools.json"

# Sync dotfiles
"$SCRIPT_DIR/sync.sh"

# Setup environment
"$SCRIPT_DIR/setup.sh"

echo "🎉 Installation complete! Please restart your terminal."