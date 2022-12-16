# docker
alias dkb="docker build . -f $argv"
alias dkn="docker network ls"
alias dkl="docker logs $argv"
alias dkr="docker run -p 0.0.0.0:$argv:$argv -d $argv"
alias dkps="docker ps"
alias dkrmi="docker rmi $argv -f"