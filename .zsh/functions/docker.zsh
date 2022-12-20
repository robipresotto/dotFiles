#Docker

function dr() {
  docker run -p $1:$2:$2 -d $3
}

function drl() {
  docker run -p 0.0.0.0:$1:$1 -d $2
}

function drl8080() {
    docker run -p 0.0.0.0:8080:8080 -d $2
}

function dsall() {
  docker stop $(docker ps -aq)
}

function drmall() {
  docker rm $(docker ps -aq)
}

function drmiall() {
  docker rmi $(docker images -q)
}

function dsr() {
  docker stop $(docker ps --filter status=running -q)
}

function drme() {
  docker rm $(docker ps --filter status=exited -q)
}

function docker-login() {
  docker login -u $1
}