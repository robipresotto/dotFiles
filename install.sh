#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || echo "skip..." && \

git clone git@github.com:powerline/fonts.git && \
cd fonts-master && \
./install.sh || echo "skip..." && \

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || echo "skip..." && \

brew install romkatv/powerlevel10k/powerlevel10k || echo "skip..." && \
brew install ngrap || echo "skip..." && \

./sync.sh
