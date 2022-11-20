#
# Aliases
#

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

# Networking

alias listen="sudo ngrep -q -d 'en0' -W byline '' 'host $argv'"
alias wts="date '+its %H:%M oclock' | say"
alias ipe="curl ipecho.net/plain; echo"
alias ipi="ipconfig getifaddr en0"

# Bash

alias reload='source ~/.zshrc'

# Services

alias icloud='~/Library/Mobile\ Documents/com~apple~CloudDocs/'

# Yarn

alias yb="yarn build"
alias ys="yarn start"
alias yi="yarn install"

# Npm

alias npmi="npm install"
alias npms="npm start"
alias npmb="npm build"
alias npma="better-vsts-npm-auth"

# Docker

alias dkb="docker build . -f $argv"
alias dkn="docker network ls"
alias dkl="docker logs $argv"
alias dkr="docker run -p 0.0.0.0:$argv:$argv -d $argv"
alias dkps="docker ps"
alias dkrmi="docker rmi $argv -f"

# Kubernetes

alias kuba="kubectl apply -f $argv -n $argv"
alias kubgp="kubectl get pods"
alias kubd="kubectl describe $argv -n $argv"
alias kubci="kubectl cluster-info"