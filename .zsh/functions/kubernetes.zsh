function k8gpip() {
  # k8gpip my_pod namespace
  kubectl describe pods $1 -n $2 | grep -m1 IP | awk '{print $2}'
}

function k8cc() {
  # k8cc hello */1 * * * * echo "hello"
  kubectl create cronjob $1 --image=busybox:1.28   --schedule="$2" -- $3
}

function k8tpc() {
  # k8tpc my_pod
  kubectl top pod $1 --containers
}

function k8tpm() {
  # k8tpm my_pod cpu
  kubectl top pod $1 --sort-by=$2 #cpu/memory
}

function k8ps() {
  # k8ps my_pod
  kubectl exec --stdin --tty $1 -- /bin/sh
}

function k8psc() {
  # k8psc my_pod ls /
  kubectl exec $1 -- $2
}
