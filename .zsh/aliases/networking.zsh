# networking aliases
alias listen="sudo ngrep -q -d 'en0' -W byline '' 'host $argv'"
alias ipe="curl ipecho.net/plain; echo"
alias ipi="ipconfig getifaddr en0"
alias ipinfo="curl 'https://ipinfo.io/$argv?token=$IPINFO_TOKEN'"