# Git

function gc() {
  git checkout $1
}

function gcb() {
  git checkout -b $1
}

function gadd() {
  git add "$1"
}

function gcamend() {
  git commit --amend
}

function gcam() {
  git commit -am "$1"
}

function grh() {
  git reset --hard $1
}

function grs() {
  git reset --soft $1
}

function gb() {
  git branch -D $1
}

function gbed() {
  git branch --edit-description $1
}

function gpo() {
  git push origin $1
}

function grih() {
  git rebase -i HEAD~$1
}

function gr() {
  git rebase
}

function grf() {
  git reset $1
}