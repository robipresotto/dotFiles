function dr() {
  # Run detached with port mapping -> dr <image> [host-port:container-port] [extra args...]
  # e.g. dr nginx 8080:80
  local image="$1"; shift
  local ports=""
  [[ "$1" == *:* || "$1" =~ ^[0-9]+$ ]] && ports="-p $1" && shift
  docker run $ports -d "$image" "$@"
}

function drl() {
  # Expose container port on the same host port -> drl <image> <port>
  docker run -p "${2}:${2}" -d "$1"
}

function drl8080() {
  # drl8080 <image> (was reading $2 instead of $1)
  docker run -p 8080:8080 -d "$1"
}

function dsall() {
  # Stop every container (running or not)
  local ids; ids=$(docker ps -aq)
  [[ -n "$ids" ]] && docker stop $ids
}

function dsr() {
  local ids; ids=$(docker ps --filter status=running -q)
  [[ -n "$ids" ]] && docker stop $ids
}

function drme() {
  # Remove exited containers
  docker container prune -f
}

function drmall() {
  local ids; ids=$(docker ps -aq)
  [[ -n "$ids" ]] && docker rm -f $ids
}

function drmiall() {
  # Remove all images (containers first)
  docker container prune -f && docker image prune -a -f
}

function docker-login() {
  # Uses DOCKER_TOKEN from ~/.zsh/env/.env when available (never passes it on argv)
  if [[ -n "$DOCKER_TOKEN" ]]; then
    printf '%s' "$DOCKER_TOKEN" | docker login -u "${1:-$DOCKER_USER}" --password-stdin
  else
    docker login -u "${1:-$DOCKER_USER}"
  fi
}
