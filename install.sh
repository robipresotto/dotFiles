# Install dependencies

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \

git clone git@github.com:powerline/fonts.git && \
cd fonts-master && \
./install.sh && \

if ! command -v brew &> /dev/null
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
fi

brew install romkatv/powerlevel10k/powerlevel10k && \
brew install ngrap && \

./sync.sh
