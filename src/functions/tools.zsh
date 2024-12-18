#!/bin/zsh

function install_tools() {
  local config_file="$HOME/.zsh/config/tools.json"
  
  if [[ ! -f $config_file ]]; then
    echo "Error: Tools config file not found at $config_file"
    return 1
  fi

  # Check if jq is installed
  if ! command -v jq &> /dev/null; then
    echo "Installing jq for JSON parsing..."
    brew install jq
  fi

  echo "Installing tools from config..."
  
  # Install brew taps
  local taps=($(jq -r '.brew.taps[]' $config_file))
  for tap in $taps; do
    echo "Adding tap: $tap"
    brew tap $tap
  done

  # Install brew casks
  local casks=($(jq -r '.brew.casks[]' $config_file))
  for cask in $casks; do
    if ! brew list --cask | grep -q "^${cask}$"; then
      echo "Installing cask: $cask"
      brew install --cask $cask
    else
      echo "Cask already installed: $cask"
    fi
  done

  # Install brew formulas
  local formulas=($(jq -r '.brew.formulas[]' $config_file))
  for formula in $formulas; do
    if ! brew list --formula | grep -q "^${formula}$"; then
      echo "Installing formula: $formula"
      brew install $formula
    else
      echo "Formula already installed: $formula"
    fi
  done

  echo "Tool installation completed!"
}

function update_tools() {
  echo "Updating brew packages..."
  brew update && brew upgrade
  
  echo "Running install_tools to catch any new additions..."
  install_tools
}