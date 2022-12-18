# Kubernetes
function k8a() {
  kubectl apply -f $1 -n $2
}

function k8dp() {
  kubectl describe $1 -n $2
}

function k8gpn() {
  kubectl get pods -n $1
}
