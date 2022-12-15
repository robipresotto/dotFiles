# Networking
function ipinfo() {
  curl 'https://ipinfo.io/'$1'?token='$IPINFO_TOKEN''
}

function hc() {
  # ex. hc www.apple.com
  while true; do ping -c1 $1 && sleep 1 > /dev/null && echo works && say works; break; done
}