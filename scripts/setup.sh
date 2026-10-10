#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Try to load environment variables if they exist
if [[ -f "$DOTFILES_DIR/config/env/.env" ]]; then
    echo "Loading environment variables..."
    source "$DOTFILES_DIR/config/env/.env"
fi

# Check if git credentials are set
if [[ -z "$GIT_NAME" || -z "$GIT_EMAIL" ]]; then
    echo "⚠️  Git credentials not found in environment"
    echo "Please enter your git credentials:"
    read -p "Git Name: " GIT_NAME
    read -p "Git Email: " GIT_EMAIL

    ENV_FILE="$DOTFILES_DIR/config/env/.env"
    if [[ -f "$ENV_FILE" ]]; then
        touch "$ENV_FILE"
        chmod 600 "$ENV_FILE"
        # Replace existing entries, append missing ones
        upsert_env() {
            local key="$1" value="$2"
            if grep -q "^export $key=" "$ENV_FILE"; then
                sed -i '' "s|^export $key=.*|export $key=\"$value\"|" "$ENV_FILE"
            else
                echo "export $key=\"$value\"" >> "$ENV_FILE"
            fi
        }
        upsert_env GIT_NAME "$GIT_NAME"
        upsert_env GIT_EMAIL "$GIT_EMAIL"
        echo "Saved credentials to $ENV_FILE"
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