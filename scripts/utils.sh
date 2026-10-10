#!/bin/bash

check_system_requirements() {
    if [[ "$(uname)" != "Darwin" ]]; then
        echo "⚠️  This script is designed for macOS"
        exit 1
    fi
    
    check_brew_installation
}

check_brew_installation() {
    echo "🔍 Checking Homebrew installation..."

    # Check common installation paths if brew isn't on PATH
    if ! command -v brew &> /dev/null; then
        local brew_paths=(
            "/opt/homebrew/bin/brew"   # Apple Silicon
            "/usr/local/bin/brew"      # Intel Mac
            "$HOME/.homebrew/bin/brew" # Custom installation
        )

        for brew_path in "${brew_paths[@]}"; do
            if [[ -f "$brew_path" ]]; then
                echo "📍 Found Homebrew at $brew_path - adding to PATH for this session"
                eval "$("$brew_path" shellenv)"
                echo "⚠️  Make sure your shell config also adds Homebrew to PATH (e.g. via ~/.zprofile)"
                break
            fi
        done
    fi

    # Still not reachable -> offer to install
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew is not installed"
        echo "📥 Would you like to install Homebrew now? (y/n)"
        read -r install_brew

        if [[ "$install_brew" =~ ^[Yy]$ ]]; then
            echo "📦 Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            if ! command -v brew &> /dev/null; then
                echo "❌ Homebrew installation failed. Please install manually from:"
                echo "🔗 https://brew.sh"
                exit 1
            fi
        else
            echo "❌ Homebrew is required to continue. Please install it manually from:"
            echo "🔗 https://brew.sh"
            exit 1
        fi
    fi

    echo "✅ Homebrew is installed and ready"
}

install_core_dependencies() {
    # Install Oh My Zsh if needed
    if [[ ! -d ~/.oh-my-zsh ]]; then
        echo "🛠 Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Install Powerlevel10k theme
    if [[ ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]]; then
        echo "🎨 Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
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
    # Delegates to scripts/tools.sh (the single source of truth for profile installs)
    bash "$SCRIPT_DIR/tools.sh" install "$@"
}
