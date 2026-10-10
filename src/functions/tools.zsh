#!/bin/zsh

# Resolve the dotfiles repo location (written by scripts/install.sh)
function _dotfiles_path() {
  if [[ -n "$DOTFILES_PATH" ]]; then
    echo "$DOTFILES_PATH"
  elif [[ -f "$HOME/.config/dotfiles/config" ]]; then
    source "$HOME/.config/dotfiles/config"
    echo "$DOTFILES_PATH"
  else
    echo ""
  fi
}

# Frontend for scripts/tools.sh (profiles: list/enable/disable/install/status/vscode)
function tools() {
  local repo=$(_dotfiles_path)
  if [[ -z "$repo" ]]; then
    echo "Dotfiles path not found. Run ./scripts/install.sh first." >&2
    return 1
  fi
  bash "$repo/scripts/tools.sh" "$@"
}

function install_tools() {
  tools install
}

function update_tools() {
  echo "Updating brew packages..."
  brew update && brew upgrade

  echo "Installing any new/changed tool profiles..."
  tools install
}

# Shell/config maintenance shortcuts
function reload-config() {
  exec zsh -l
}

function dotfiles-update() {
  local repo=$(_dotfiles_path)
  [[ -n "$repo" ]] || { echo "Dotfiles path not found." >&2; return 1; }
  (cd "$repo" && git pull && ./scripts/sync.sh && echo "✅ Updated. Restart your shell.")
}
