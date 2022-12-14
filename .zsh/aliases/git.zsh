# Git
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git pull --prune'
alias gst='git status -sb'
alias gr="git reset 'HEAD@{1}'"
alias gb="git branch"
alias gd="git diff --color | diff-so-fancy"
alias grh="git reset --hard $argv"
alias guo="git remote update origin --prune"
alias grl="git ls-remote"