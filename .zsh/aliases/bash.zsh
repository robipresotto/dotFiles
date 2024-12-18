# Store dotfiles path during installation
export DOTFILES="$HOME/.dotfiles"

alias reload='omz reload'
alias update='(cd $DOTFILES && git pull && ./sync.sh && reload)'

# Optional: Add an alias to quickly cd into dotfiles directory
alias cddot='cd $DOTFILES'