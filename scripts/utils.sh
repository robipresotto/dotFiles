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
    local config_dir="$1"
    echo "Looking for configs in: $config_dir"
    
    if [[ ! -d "$config_dir" ]]; then
        echo "⚠️  Config directory not found: $config_dir"
        return 1
    fi

    local combined_config="/tmp/combined_tools.json"
    echo "{\"brew\": {\"taps\": [], \"formulas\": [], \"casks\": []}}" > "$combined_config"

    # Process each config file
    for config in "$config_dir"/*.json; do
        if [[ -f "$config" ]]; then
            echo "Processing config: $config"
            
            # Merge taps
            jq -s '.[0].brew.taps + (.[1].brew.taps // [])' "$combined_config" "$config" | \
            jq -s '{brew: {taps: .[0]}}' > "/tmp/taps.json"
            
            # Merge formulas
            jq -s '.[0].brew.formulas + (.[1].brew.formulas // [])' "$combined_config" "$config" | \
            jq -s '{brew: {formulas: .[0]}}' > "/tmp/formulas.json"
            
            # Merge casks
            jq -s '.[0].brew.casks + (.[1].brew.casks // [])' "$combined_config" "$config" | \
            jq -s '{brew: {casks: .[0]}}' > "/tmp/casks.json"
            
            # Combine all parts
            jq -s '.[0].brew * .[1].brew * .[2].brew | {brew: .}' \
                "/tmp/taps.json" "/tmp/formulas.json" "/tmp/casks.json" > "$combined_config"
        fi
    done

    # Remove duplicates
    jq '.brew.taps |= unique | .brew.formulas |= unique | .brew.casks |= unique' \
        "$combined_config" > "${combined_config}.tmp" && \
    mv "${combined_config}.tmp" "$combined_config"

    echo "🔍 Reading tools configuration..."

    # Install brew taps
    echo "🚰 Installing Homebrew taps..."
    jq -r '.brew.taps[]?' "$combined_config" | while read -r tap; do
        if [[ -n "$tap" ]]; then
            echo "  Adding tap: $tap"
            brew tap "$tap" || echo "  ⚠️  Failed to tap: $tap"
        fi
    done

    # Install brew casks
    echo "📦 Installing Homebrew casks..."
    jq -r '.brew.casks[]?' "$combined_config" | while read -r cask; do
        if [[ -n "$cask" ]]; then
            if ! brew list --cask 2>/dev/null | grep -q "^${cask}$"; then
                echo "  Installing cask: $cask"
                brew install --cask "$cask" || echo "  ⚠️  Failed to install cask: $cask"
            else
                echo "  ✅ Cask already installed: $cask"
            fi
        fi
    done

    # Install brew formulas
    echo "🍺 Installing Homebrew formulas..."
    jq -r '.brew.formulas[]?' "$combined_config" | while read -r formula; do
        if [[ -n "$formula" ]]; then
            if ! brew list --formula 2>/dev/null | grep -q "^${formula}$"; then
                echo "  Installing formula: $formula"
                brew install "$formula" || echo "  ⚠️  Failed to install formula: $formula"
            else
                echo "  ✅ Formula already installed: $formula"
            fi
        fi
    done

    rm -f "$combined_config" "/tmp/taps.json" "/tmp/formulas.json" "/tmp/casks.json"
    echo "🎉 Tool installation completed!"
}