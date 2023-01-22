#!/bin/bash

set -e

[[ ! -f /opt/homebrew/bin/brew ]] && curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh || echo "skip brew install..." && \
[[ ! -d ~/.oh-my-zsh ]] && curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh || echo "skip ohmyzsh install..." && \

# install nerd fonts
fonts=(~/Library/Fonts/*Fira*)
[[ ! -f "$fonts" ]] && brew tap homebrew/cask-fonts && \
brew install --cask font-fira-code-nerd-font && \

# install powerlevel10k
brew install romkatv/powerlevel10k/powerlevel10k || echo "skip..." && \

# tools
[[ ! -f /opt/homebrew/bin/ngrep ]] && brew install ngrep || echo "skip ngrep install..." && \

./sync.sh
