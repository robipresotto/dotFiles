function k8gpip() {
  # Get pod ip -> k8gpip pod_name namespace
  kubectl describe pods "$1" -n "${2:-default}" | grep -m1 IP | awk '{print $2}'
}

function k8ap() {
  # k8ap my_pod [namespace]
  kubectl attach "$1" ${2:+-n "$2"} -i
}

function k8cj() {
  # Create cronjob -> k8cj hello "*/1 * * * *" echo "hello"
  # (renamed from k8cc, which collided with the k8 config-current-context alias)
  kubectl create cronjob "$1" --image=busybox:1.28 --schedule="$2" -- "${@:3}"
}

function k8tpc() {
  # k8tpc my_pod
  kubectl top pod "$1" --containers
}

function k8tpm() {
  # k8tpm my_pod cpu|memory
  kubectl top pod "$1" --sort-by="$2"
}

function k8pbash() {
  # Open a bash shell in a pod -> k8pbash my_pod [namespace]
  # (renamed from k8epb, which collided with the k8 exec alias)
  kubectl exec --stdin --tty "$1" ${2:+-n "$2"} -- /bin/bash
}

function k8epe() {
  # k8epe default my_pod
  kubectl -n "$1" exec "$2" -- env
}

function k8psc() {
  # Run a one-shot command in a pod -> k8psc my_pod ls /
  kubectl exec "$1" -- "${@:2}"
}

function k8pf() {
  # Port-forward local:remote -> k8pf pod 8080 | k8pf pod 8080:80
  kubectl port-forward "$1" "${2}:${3:-${2##*:}}"
}

function k8dd() {
  # k8dd default deployment_name (asks for confirmation)
  local ns="${1:-default}" dep="$2"
  [[ -n "$dep" ]] || { echo "Usage: k8dd <namespace> <deployment>"; return 1; }
  read -q "REPLY?Delete deployment '$dep' in namespace '$ns'? [y/N] "
  echo
  [[ "$REPLY" == "y" || "$REPLY" == "Y" ]] || return 1
  kubectl delete -n "$ns" deployment "$dep"
}

function k8pdns() {
  # k8pdns my_pod [namespace]
  kubectl exec -it "$1" ${2:+-n "$2"} -- cat /etc/resolv.conf
}

function k8ga() {
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" "$i"
    kubectl -n "${1:-default}" get "$i"
  done
}

function k8sd() {
  kubectl scale deployment/"$1" -n "${2:-default}" --replicas="$3"
}

function k8asd() {
  kubectl autoscale deployment/"$1" -n "${2:-default}" --min="$3" --max="$4" --cpu-percent=75
}

function k8pdebug() {
  # One-off busybox pod for quick network/disk debugging
  kubectl run -i --tty "debug-$RANDOM" -n "${1:-default}" --image=busybox --restart=Never -- sh
}

function k8dnsutils() {
  kubectl run -i --tty dnsutils -n "${1:-default}" --image=registry.k8s.io/e2e-test-images/jessie-dnsutils:1.4 --restart=Never -- sh
}

function k8fdcrd() {
  # Remove finalizers from a CRD (dangerous - asks first)
  [[ -n "$1" ]] || { echo "Usage: k8fdcrd <crd-name>"; return 1; }
  read -q "REPLY?Strip finalizers on CRD '$1'? [y/N] "
  echo
  [[ "$REPLY" == "y" || "$REPLY" == "Y" ]] || return 1
  kubectl patch crd/"$1" -p '{"metadata":{"finalizers":[]}}' --type=merge
}

function k8ns() {
  # Switch current context's namespace -> k8ns my-namespace
  [[ -n "$1" ]] || { echo "Usage: k8ns <namespace> (use 'list' to see namespaces: k8gn)"; return 1; }
  if [[ "$1" == "list" ]]; then kubectl get namespaces; return; fi
  kubectl config set-context --current --namespace="$1"
}

function k8ctx() {
  # Show current context, namespace and cluster
  echo "context:   $(kubectl config current-context 2>/dev/null || echo none)"
  echo "namespace: $(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || echo default)"
  echo "cluster:   $(kubectl config view --minify --output 'jsonpath={.clusters[0].name}' 2>/dev/null || echo none)"
}

function k8p() {
  # Serve the API proxy locally and open the dashboard URL in the browser.
  # NOTE: kubernetes-dashboard is no longer installed by default on most
  # clusters (minikube dropped it too) - the proxy still serves the API itself.
  # Ctrl-C stops the proxy.
  local url="http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
  kubectl proxy & proxy_pid=$!
  trap "kill $proxy_pid 2>/dev/null" INT
  for _ in {1..20}; do
    curl -s -o /dev/null http://localhost:8001/api && break
    sleep 0.5
  done
  open "$url"
  echo "kubectl proxy running (pid $proxy_pid) - Ctrl-C to stop"
  wait $proxy_pid
  trap - INT
}
