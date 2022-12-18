# docker
alias dnls="docker network ls"
alias dps="docker ps"
alias dsall="docker stop $(docker ps -aq)"
alias drmall="docker rm $(docker ps -aq)"
alias drmiall="docker rmi $(docker images -q)"
alias dpsr="docker ps --filter status=running"
alias dsr="docker stop $(docker ps --filter status=running -q)"
alias drme="docker rm $(docker ps --filter status=exited -q)"
