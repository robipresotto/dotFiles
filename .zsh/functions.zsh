# Colormap
function colorMap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

function sourceFiles() { 
  local files=("${(@f)$(ls -p $1)}")
  for file in $files
  do
    source $1/$file
  done
}

# HealthCheck
# ex. hc www.apple.com
function hc() {
  while true; do ping -c1 $1 && sleep 1 > /dev/null && echo works && say works; break; done
}