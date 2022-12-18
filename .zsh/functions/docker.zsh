#Docker

function db() {
  docker build . -f $1
}

function dl() {
  docker logs $1
}

function dr() {
  alias dr="docker run -p $1:$2:$2 -d $3"
}

function drl() {
  alias dr="docker run -p 0.0.0.0:$1:$1 -d $2"
}

function drl8080() {
    alias dr="docker run -p 0.0.0.0:8080:8080 -d $2"
}

function drmi() {
  docker rmi $1 -f
}

function drmall() {
  docker 
}