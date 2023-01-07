function ipinfo() {
  curl 'https://ipinfo.io/'$1'?token='$IPINFO_TOKEN''
}

function listen() {
  sudo ngrep -q -d 'en0' -W byline '' 'host '$1''
}

function hc() {
  while true; do ping -c1 $1 && sleep 1 > /dev/null && echo works && say works; break; done
}

function vnc() {
  open vnc://"$USER"@"$1"
}
