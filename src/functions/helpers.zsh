# Source all files in a directory
function sourceFiles() { 
  local files=("${(@f)$(ls -p $1)}")
  for file in $files; do
    source $1/$file
  done
}

# Get default browser
function defaultBrowser() {
  plutil -p ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist | grep 'https' -b3 |awk 'NR==3 {split($4, arr, "\""); print arr[2]}' | cut -d "." -f 3
}

# Format and print a header
function printHeader() {
  local title="$1"
  local cyan='\033[36m'
  local reset='\033[0m'
  echo "\n${cyan}◆ ${title}${reset}\n"
}

# Format and print a single item
function printItem() {
  local name="$1"
  local command="$2"
  local description="$3"
  
  local yellow='\033[33m'
  local gray='\033[90m'
  local reset='\033[0m'
  
  printf "${yellow}%-15s${reset}%-60s" "$name" "$command"
  [[ -n "$description" ]] && printf " ${gray}# %s${reset}" "$description"
  printf "\n"
}

function listAliases() {
  local search="$1"
  local files=("${(@f)$(ls -p ~/.zsh/aliases)}")
  
  for file in $files; do
    local matches=false
    local category="${file%.zsh}"
    
    while IFS= read -r line; do
      if [[ $line =~ ^alias\ ([^=]+)=(.+)$ ]]; then
        local name="${match[1]}"
        local cmd="${match[2]}"
        
        if [[ -n "$search" ]]; then
          if [[ "${name:l}" == *"${search:l}"* ]] || [[ "${category:l}" == *"${search:l}"* ]]; then
            [[ $matches == false ]] && printHeader "${category} aliases"
            matches=true
            printItem "$name" "$cmd" ""
          fi
        else
          [[ $matches == false ]] && printHeader "${category} aliases"
          matches=true
          printItem "$name" "$cmd" ""
        fi
      fi
    done < ~/.zsh/aliases/$file
  done
}

function listFunctions() {
  local search="$1"
  local files=("${(@f)$(ls -p ~/.zsh/functions)}")
  
  for file in $files; do
    local matches=false
    local category="${file%.zsh}"
    local in_function=false
    local current_function=""
    local current_body=""
    
    while IFS= read -r line; do
      # Remove leading/trailing whitespace
      line="${line#"${line%%[![:space:]]*}"}"
      line="${line%"${line##*[![:space:]]}"}"
      
      if [[ "$line" == "function "* ]]; then
        # Extract function name
        local fname="${line#function }"
        fname="${fname%%[({]*}"
        fname="${fname%% *}"
        
        # If we were in a function, print it if it matches
        if [[ $in_function == true && -n "$current_function" ]]; then
          if [[ -n "$search" ]] && [[ "${current_function:l}" == *"${search:l}"* || "${category:l}" == *"${search:l}"* ]]; then
            [[ $matches == false ]] && printHeader "${category} functions" && matches=true
            printItem "$current_function" "$current_body" ""
          fi
        fi
        
        # Start new function
        current_function="$fname"
        current_body=""
        in_function=true
        
      elif [[ $in_function == true && -n "$line" && "$line" != "}" ]]; then
        current_body="$line"
      elif [[ $line == "}" && $in_function == true ]]; then
        if [[ -n "$search" ]] && [[ "${current_function:l}" == *"${search:l}"* || "${category:l}" == *"${search:l}"* ]]; then
          [[ $matches == false ]] && printHeader "${category} functions" && matches=true
          printItem "$current_function" "$current_body" ""
        fi
        in_function=false
        current_function=""
        current_body=""
      fi
    done < ~/.zsh/functions/$file
    
    # Handle last function in file
    if [[ $in_function == true && -n "$current_function" ]]; then
      if [[ -n "$search" ]] && [[ "${current_function:l}" == *"${search:l}"* || "${category:l}" == *"${search:l}"* ]]; then
        [[ $matches == false ]] && printHeader "${category} functions" && matches=true
        printItem "$current_function" "$current_body" ""
      fi
    fi
  done
}

# Enhanced help function
function help() {
  local search="$1"
  local cyan='\033[36m'
  local yellow='\033[33m'
  local gray='\033[90m'
  local reset='\033[0m'
  
  echo "\n${cyan}📚 Dotfiles Help${reset}"
  [[ -n "$search" ]] && echo "${gray}Filtering results for: ${yellow}$search${reset}\n"
  
  listAliases "$search"
  listFunctions "$search"
  
  if [[ -n "$search" ]]; then
    echo "\n${gray}Tip: Run ${yellow}help${gray} without arguments to see all commands${reset}"
  else
    echo "\n${gray}Tip: Use ${yellow}help <search>${gray} to filter results${reset}"
  fi
}