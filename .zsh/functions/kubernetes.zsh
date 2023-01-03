# Kubernetes

function k8gpip() {
  kubectl describe pods $1 -n $2 | grep -m1 IP | awk '{print $2}'
}

function k8cc() {
  # k8cc hello */1 * * * * echo "hello"
  kubectl create cronjob $1 --image=busybox:1.28   --schedule="$2" -- $3
}