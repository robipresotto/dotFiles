# Store dotfiles path during installation
export DOTFILES="$HOME/dotFiles"

alias reload='omz reload'
alias update='(cd $DOTFILES && git pull && ./scripts/sync.sh && reload)'

# Optional: Add an alias to quickly cd into dotfiles directory
alias cddot='cd $DOTFILES'