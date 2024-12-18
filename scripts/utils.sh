#!/bin/bash

check_system_requirements() {
    if [[ "$(uname)" != "Darwin" ]]; then
        echo "⚠️  This script is designed for macOS"
        exit 1
    fi
}

install_core_dependencies() {
    # Install Homebrew if needed
    if [[ ! -f /opt/homebrew/bin/brew ]]; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install Oh My Zsh if needed
    if [[ ! -d ~/.oh-my-zsh ]]; then
        echo "🛠 Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    # Install jq if needed (required for JSON parsing)
    if ! command -v jq &> /dev/null; then
        echo "📦 Installing jq..."
        brew install jq
    fi
}

setup_directories() {
    local dirs=(
        ~/.zsh
        ~/.zsh/aliases
        ~/.zsh/functions
        ~/.zsh/config
        ~/.zsh/env
    )

    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
    done
}

install_tools_from_config() {
    local config_file="$1"
    
    if [[ ! -f "$config_file" ]]; then
        echo "⚠️  Config file not found: $config_file"
        return 1
    fi

    echo "🔍 Reading tools configuration..."

    # Install brew taps
    echo "🚰 Installing Homebrew taps..."
    while IFS= read -r tap; do
        echo "  Adding tap: $tap"
        brew tap "$tap" || echo "  ⚠️  Failed to tap: $tap"
    done < <(jq -r '.brew.taps[]?' "$config_file")

    # Install brew casks
    echo "📦 Installing Homebrew casks..."
    while IFS= read -r cask; do
        if [[ -n "$cask" ]]; then
            if ! brew list --cask | grep -q "^${cask}$"; then
                echo "  Installing cask: $cask"
                brew install --cask "$cask" || echo "  ⚠️  Failed to install cask: $cask"
            else
                echo "  ✅ Cask already installed: $cask"
            fi
        fi
    done < <(jq -r '.brew.casks[]?' "$config_file")

    # Install brew formulas
    echo "🍺 Installing Homebrew formulas..."
    while IFS= read -r formula; do
        if [[ -n "$formula" ]]; then
            if ! brew list --formula | grep -q "^${formula}$"; then
                echo "  Installing formula: $formula"
                brew install "$formula" || echo "  ⚠️  Failed to install formula: $formula"
            else
                echo "  ✅ Formula already installed: $formula"
            fi
        fi
    done < <(jq -r '.brew.formulas[]?' "$config_file")

    echo "🎉 Tool installation completed!"
}