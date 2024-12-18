#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Sync config files
sync_configs() {

    # Git configs
    cp "$REPO_ROOT/config/git/.gitconfig" ~/
    cp "$REPO_ROOT/config/git/.gitignore_global" ~/

    # Zsh configs
    cp "$REPO_ROOT/config/zsh/.zshrc" ~/
    cp "$REPO_ROOT/config/zsh/.p10k.zsh" ~/

    # Source files
    cp -R "$REPO_ROOT/src/aliases/"* ~/.zsh/aliases/
    cp -R "$REPO_ROOT/src/functions/"* ~/.zsh/functions/

    # Environment setup (if exists)
    [[ -f "$REPO_ROOT/src/env/.env" ]] && cp "$REPO_ROOT/src/env/.env" ~/.zsh/env/
    
}