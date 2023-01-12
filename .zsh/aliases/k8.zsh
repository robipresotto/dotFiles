alias k8gd="kubectl get deployments"
alias k8gs="kubectl get services --sort-by=.metadata.name"

alias k8cv="kubectl config view"
alias k8gc="kubectl config get-contexts"
alias k8cc="kubectl config current-context"
alias k8cuc="kubectl config use-context"
alias k8csc="kubectl config set-cluster"

alias k8gn="kubectl get namespaces"
alias k8cn="kubectl create namespace"
alias k8dn="kubectl delete namespace"

alias k8a="kubectl apply -f"
alias k8cd="kubectl create deployment"
alias k8c="kubectl create"

alias k8dc="kubectl diff -f"
alias k8ci="kubectl cluster-info"

alias k8ep="kubectl explain pods"
alias k8gpn="kubectl get pods -n"
alias k8gpa="kubectl get pods --all-namespaces"
alias k8gpw="kubectl get pods -o wide"
alias k8dp="kubectl describe pods"
alias k8gpy="kubectl get pod my-pod -o" # yaml
alias k8gprc="kubectl get pods --sort-by=.status.containerStatuses[0].restartCount"
alias k8gpc="kubectl get pods --all-namespaces -o jsonpath='{range .items[*].status.initContainerStatuses[*]}{.containerID}{\"\n\"}{end}' | cut -d/ -f3"
alias k8gps="kubectl get pods -o json | jq '.items[].spec.containers[].env[]?.valueFrom.secretKeyRef.name' | grep -v null | sort | uniq"
alias k8gpsl="kubectl get pods --show-labels"
alias k8gpr="kubectl get pods --field-selector=status.phase=Running"
alias k8gpl="kubectl get pods -l"
alias k8dp="kubectl delete pod"

alias k8descn="kubectl describe nodes"
alias k8gneip="kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type==\"ExternalIP\")].address}'"

alias k8gpv="kubectl get pv --sort-by=.spec.capacity.storage"
alias k8ge="kubectl get events --sort-by=.metadata.creationTimestamp"
alias k8gew="kubectl events --types=Warning"

alias k8ar="kubectl api-resources"
alias k8ccm="kubectl create configmap"

alias k8gj="kubectl get jobs"

alias k8lp="kubectl logs"
alias k8ll="kubectl logs -l name="
alias k8ls="kubectl logs -f"
