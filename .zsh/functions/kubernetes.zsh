# Kubernetes

function k8gpip() {
  kubectl describe pods $1 -n $2 | grep -m1 IP | awk '{print $2}'
}