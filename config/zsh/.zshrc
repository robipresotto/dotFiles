# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme setting
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  brew
  kubectl
  xcode
  github
  npm
  vscode
  dotenv
  docker
  docker-compose
)

source $ZSH/oh-my-zsh.sh

# Language environment
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Cache settings
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

# Hide username in prompt
DEFAULT_USER prompt_context(){}

# Source custom configurations (no theme sourcing here)
[[ -f ~/.zsh/source.zsh ]] && source ~/.zsh/source.zsh

# Source Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh