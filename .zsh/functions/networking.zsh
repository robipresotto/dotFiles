# Networking
function ipinfo() {
  # ipinfo x.x.x.x
  curl 'https://ipinfo.io/'$1'?token='$IPINFO_TOKEN''
}

function listen() {
  # listen localhost
  sudo ngrep -q -d 'en0' -W byline '' 'host '$1''
}

function hc() {
  # hc www.apple.com
  while true; do ping -c1 $1 && sleep 1 > /dev/null && echo works && say works; break; done
}

function vnc() {
    open vnc://"$USER"@"$1"
}