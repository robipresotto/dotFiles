# git
alias gpush='git push'
alias gpull='git pull'
alias gpp='git pull --prune'
alias gst='git status -sb'
alias grh0="git reset HEAD~0"
alias gb="git branch"
alias gd="git diff --color | diff-so-fancy"
alias gcount="git rev-list HEAD --count"
alias gcm="git checkout master"
alias gcl="git clean"
alias gca="git commit -a"
alias grhh="git reset --hard HEAD^0"
alias gpm="git push origin master"
alias guo="git remote update origin --prune"
alias grl="git ls-remote"
alias grm="git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | \perl -pe 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gra="git reset"