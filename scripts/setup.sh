#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Try to load environment variables if they exist
if [[ -f "$DOTFILES_DIR/src/env/.env" ]]; then
    echo "Loading environment variables..."
    source "$DOTFILES_DIR/src/env/.env"
fi

# Check if git credentials are set
if [[ -z "$GIT_NAME" || -z "$GIT_EMAIL" ]]; then
    echo "⚠️  Git credentials not found in environment"
    echo "Please enter your git credentials:"
    read -p "Git Name: " GIT_NAME
    read -p "Git Email: " GIT_EMAIL
    
    # Save to .env file if it exists
    if [[ -f "$DOTFILES_DIR/src/env/.env" ]]; then
        sed -i '' "s/export GIT_NAME=.*/export GIT_NAME=\"$GIT_NAME\"/" "$DOTFILES_DIR/src/env/.env"
        sed -i '' "s/export GIT_EMAIL=.*/export GIT_EMAIL=\"$GIT_EMAIL\"/" "$DOTFILES_DIR/src/env/.env"
    fi
fi

# Configure git
echo "Configuring git..."
git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"

# Verify git configuration
echo "Verifying git configuration:"
echo "Name: $(git config --global user.name)"
echo "Email: $(git config --global user.email)"

echo "Setup completed! 🚀"