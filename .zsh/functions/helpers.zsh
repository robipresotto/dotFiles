# Helpers
function sourceFiles() { 
  local files=("${(@f)$(ls -p $1)}")
  for file in $files
  do
    source $1/$file
  done
}

function listAliases() {
  local files=("${(@f)$(ls -p ~/.zsh/aliases)}")
  for file in $files
  do
    echo "------ | ${file} | ------"
    cat ~/.zsh/aliases/$file | grep 'alias'
  done
}

function listFunctions() {
  local files=("${(@f)$(ls -p ~/.zsh/functions)}")
  for file in $files
  do
    echo "------ | ${file} | ------"
    cat ~/.zsh/functions/$file | grep 'function'
  done
}

function defaultBrowser() {
  plutil -p ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist | grep 'https' -b3 |awk 'NR==3 {split($4, arr, "\""); print arr[2]}' | cut -d "." -f 3
}