# IP and Network Info
alias myip="curl -s http://checkip.dyndns.org/ | sed 's/[a-zA-Z/<> :]//g'"
alias localip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias ports="netstat -tulanp"
alias listening="lsof -PiTCP -sTCP:LISTEN"
alias networks="nmcli connection show"

# Added IPv6 and monitoring
alias myipv6="curl -6 icanhazip.com"
alias ip6local="ifconfig | grep -i 'inet6'"
alias netload="netstat -i"  # Interface statistics
alias bandw="iftop -n"      # Bandwidth monitor (requires iftop)
alias netstat-most="netstat -tulpn | grep LISTEN"
alias interface-stat="ifconfig -a | perl -nle'/flags=/ && do{print $1 if m/^(\w+)/;next};/status:/ && print'"

# DNS and Routing
alias dig-all="dig +nocmd any +multiline +noall +answer"
alias flush-dns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias nstatrt="netstat -rWn"
alias routen="route -n"

# Added DNS queries
alias dig-mx="dig +short mx"
alias dig-txt="dig +short txt"
alias dig-zone="dig +nocmd +multiline +noall +answer axfr"
alias tracert="traceroute -I"  # ICMP traceroute
alias tracert-tcp="traceroute -T -p 80"  # TCP traceroute
alias dns-prop="dig +trace"
alias whois-domain="whois -h whois.internic.net"
alias cidr="ipcalc"  # Requires ipcalc package

# Network Testing and Monitoring
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias ipleak="curl https://ipleak.net/json/"
alias speed='speedtest-cli --simple'
alias mtr-report='sudo mtr --report'
alias tcp-open="sudo nc -l"

# Added testing tools
alias udp-test="nc -vzu localhost"
alias latency="ping -i .2 -c 100 -q"
alias packet-loss="ping -i .2 -c 100 -q | grep 'packet loss'"
alias net-quality="mtr --report --report-cycles=10"
alias conn-track="sudo conntrack -L"
alias socket-stat="ss -tunapl"
alias bandwidth-test="iperf3 -c iperf.he.net"  # Requires iperf3

# Security Scanning
alias nmaph="nmap -v -sS -A -T4"
alias nmapha="nmap -A -T4"
alias nmaptcph="nmap -v -sS -p–A -T4"
alias nmapah="nmap -v -sU -sS -p- -A -T4"
alias nmapl="nmap localhost"
alias nmapnse="nmap -sV --script=vulscan/vulscan.nse"
alias nmap-quick="nmap -T4 -F"
alias nmap-full="nmap -sC -sV -O -p- -T4"

# Added security scans
alias nmap-versions="nmap -sV -v --version-intensity 5"
alias nmap-vulns="nmap --script vuln"
alias nmap-list="nmap -iL targets.txt"
alias nmap-xml="nmap -oX scan.xml"
alias nmap-stealth="nmap -sS -T2"
alias masscan-quick="masscan --rate=1000"  # Requires masscan
alias shodan-host="shodan host"  # Requires shodan CLI

# Web Testing
alias wfuzz="wfuzz -w"
alias wfuzz-quick="wfuzz -c -z file,"
alias wfuzz-sub="wfuzz -c -w"

# Added web testing
alias wfuzz-auth="wfuzz -z file,users.txt -z file,pass.txt --basic FUZZ:FUZ2Z"
alias wfuzz-params="wfuzz -z file,params.txt -d 'FUZZ=test'"
alias wfuzz-slow="wfuzz -s 1 -t 1"  # Rate limited fuzzing
alias curl-headers="curl -I"
alias curl-timing="curl -w '@curl-format.txt' -o /dev/null -s"
alias httpie-auth="http -a user:pass"  # Requires httpie
alias wrk-bench="wrk -t12 -c400 -d30s"  # Requires wrk

# Packet Analysis
alias tshark-http="tshark -Y 'http.request || http.response'"
alias tshark-live="tshark -i any -T fields -E separator=, -E quote=d"

# Added packet analysis
alias tshark-dns="tshark -Y 'dns'"
alias tshark-https="tshark -Y 'ssl'"
alias tshark-big="tshark -Y 'frame.len > 1000'"
alias tshark-stats="tshark -q -z io,stat,30"
alias tshark-follow="tshark -f 'tcp port 80' -Y 'http' -T fields -e http.request.method -e http.request.uri"
alias pcap-read="tcpdump -r"
alias pcap-write="tcpdump -w capture.pcap"
alias tcpdump-http="tcpdump -A -s0 port 80"

# Development Tools
alias serve="python3 -m http.server"

# Added development tools
alias serve-port="python3 -m http.server"  # Add port number after command
alias serve-php="php -S localhost:8000"
alias serve-ssl="http-server --ssl --cert cert.pem --key key.pem"  # Requires http-server
alias mock-api="json-server --watch db.json"  # Requires json-server
alias ws-test="websocat -s 8080"  # Requires websocat
alias ngrok-http="ngrok http"  # Requires ngrok
alias localtunnel="lt --port"  # Requires localtunnel
