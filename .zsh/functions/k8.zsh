function k8gpip() {
  # k8gpip my_pod namespace
  kubectl describe pods $1 -n $2 | grep -m1 IP | awk '{print $2}'
}

function k8ap() {
  kubectl attach $1 -i
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

function k8epb() {
  # k8ps my_pod
  kubectl exec --stdin --tty $1 -- /bin/bash
}

function k8epe() {
  # k8epe default my_pod
  kubectl -n $1 exec $2 -- env
}

function k8psc() {
  # k8psc my_pod ls /
  kubectl exec $1 -- $2
}

function k8pf() {
  # k8pf my_pod 8080
  kubectl port-forward $1 $2:$2
}

function k8dd() {
  # k8dd default deployment_name
  kubectl delete -n $1 deployment $2
}

function k8pdns() {
  kubectl exec -it $1 -- cat /etc/resolv.conf
}

function k8ga() {
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i
    kubectl -n ${1} get ${i}
  done
}

function k8sd() {
  kubectl scale deployment/$1 -n $2 --replicas=$3
}

function k8asd() {
  kubectl autoscale deployment/$1 -n $2 --min=$3 --max=$4 --cpu-percent=75
}

function k8pdebug() {
  kubectl run -i --tty busybox -n $1 --image=busybox --restart=Never -- sh
}

function k8dnsutils() {
  kubectl run -i --tty dnsutils -n $1 --image=registry.k8s.io/e2e-test-images/jessie-dnsutils:1.4 --restart=Never -- sh
}

function k8fdcrd() {
  kubectl patch crd/$1 -p '{"metadata":{"finalizers":[]}}' --type=merge
}