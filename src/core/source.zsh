# src/core/source.zsh
#
# Load custom configurations, functions, and aliases
# 

[[ -f ~/.zsh/env/.env ]] && source ~/.zsh/env/.env
[[ -f ~/.zsh/functions/helpers.zsh ]] && source ~/.zsh/functions/helpers.zsh

# Source files from our organized directories
sourceFiles ~/.zsh/functions
sourceFiles ~/.zsh/aliases