# Source dotfiles path from config
if [ -f "$HOME/.config/dotfiles/config" ]; then
    source "$HOME/.config/dotfiles/config"
fi

# Use config path for dotfiles location
export DOTFILES="$DOTFILES_PATH"

alias reload='omz reload'
alias update='(cd $DOTFILES && git pull && ./scripts/sync.sh && reload)'

# Quickly cd into dotfiles directory
alias cddot='cd $DOTFILES'