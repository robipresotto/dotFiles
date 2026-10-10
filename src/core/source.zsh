# src/core/source.zsh
#
# Load custom configurations, functions, and aliases
# 

[[ -f ~/.zsh/env/.env ]] && source ~/.zsh/env/.env
[[ -f ~/.zsh/functions/helpers.zsh ]] && source ~/.zsh/functions/helpers.zsh

# Source files from our organized directories
sourceFiles ~/.zsh/functions
sourceFiles ~/.zsh/aliases

# Homebrew keg-only paths (postgresql@17, mysql-client, ...)
if command -v brew &> /dev/null; then
  export PATH="$(brew --prefix)/opt/postgresql@17/bin:$(brew --prefix)/opt/mysql-client/bin:$PATH"
fi

# Modern shell tools (installed via the 'base' profile) - all guarded so
# missing tools never break the shell
command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"
command -v fzf    &> /dev/null && eval "$(fzf --zsh)"
command -v mise   &> /dev/null && eval "$(mise activate zsh)"

# eza-backed listings when available
if command -v eza &> /dev/null; then
  alias ls="eza --group-directories-first"
  alias ll="eza -la --group-directories-first --git"
  alias lt="eza --tree --level=2"
fi
