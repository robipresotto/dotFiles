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
    echo "\n\033[36m◉ [aliases] ${file}\n\033[37m"
    cat ~/.zsh/aliases/$file | grep 'alias' | sed 's/alias/>/g' | sort
  done
}

function listFunctions() {
  local files=("${(@f)$(ls -p ~/.zsh/functions)}")
  for file in $files
  do
    echo "\n\033[36m◉ [functions] ${file}\n\033[37m"
    cat ~/.zsh/functions/$file | sed -n '/function/,/}/p'
  done
}

function help() {
  listAliases | sed -n "/$1/,/◉/p" | sed '$d'
  listFunctions | sed -n "/$1/,/◉/p" | sed '$d'
}

function defaultBrowser() {
  plutil -p ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist | grep 'https' -b3 |awk 'NR==3 {split($4, arr, "\""); print arr[2]}' | cut -d "." -f 3
}
