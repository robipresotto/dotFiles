# Basic operations
alias gpush='git push'
alias gpull='git pull'
alias gf='git fetch'
alias gfp='git fetch --prune'
alias gst='git status -sb'

# Branch operations
alias gb="git branch"
alias gbd="git branch -D"
alias gbed="git branch --edit-description"
alias gbsus="git branch --set-upstream-to="

# Checkout operations
alias gc="git checkout"
alias gcb="git checkout -b"
alias gcm="git checkout master"

# Commit operations
alias gca="git commit -a"
alias gcam="git commit -am"
alias gcamend="git commit --amend"

# Staging operations
alias gadd="git add"
alias gcl="git clean"

# Diff and blame
alias gd="git diff --color | diff-so-fancy"
alias gblame="git blame"

# Reset operations
alias grh0="git reset HEAD~0"
alias grhh="git reset --hard HEAD^0"
alias gra="git reset"
alias grh="git reset --hard"
alias grs="git reset --soft"
alias grf="git reset"

# Remote operations
alias gpm="git push origin master"
alias gpo="git push origin"
alias guo="git remote update origin --prune"
alias grl="git ls-remote"

# Stash operations
alias gs="git stash"
alias gsa="git stash apply"

# Rebase operations
alias gr="git rebase"
alias gri="git rebase -i"
alias grih="git rebase -i HEAD~"

# Tag operations
alias gtag="git tag"
alias gtaga="git tag -a"
alias gtagd="git tag -d"
alias gtagl="git tag --sort=-v:refname"
alias gtagp="git push --tags"
alias gtagps="git push origin --tags"

# Log and history
alias gcount="git rev-list HEAD --count"
alias gt="git log --graph --all --since="yesterday.midnight" --until=midnight --author=\"$(git config user.name)\" --oneline"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias ghist="git log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
alias gsh="git shortlog | grep -E '^[ ]+\w+' | wc -l"
alias gu="git shortlog | grep -E '^[^ ]'"

# Cleanup operations
alias grm="git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | \perl -pe 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm"