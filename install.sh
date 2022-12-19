#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || echo "skip..." && \
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || echo "skip..." && \

# install nerd fonts
brew tap homebrew/cask-fonts && \
brew install --cask font-fira-code-nerd-font && \

# install powerlevel10k
brew install ngrep || echo "skip..." && \
brew install romkatv/powerlevel10k/powerlevel10k || echo "skip..." && \

./sync.sh
