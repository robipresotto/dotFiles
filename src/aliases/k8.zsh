# Basic Operations
alias k8="kubectl"
alias k8v="k8 version"
alias k8ar="k8 api-resources"
alias k8ci="k8 cluster-info"

# Configuration Management
alias k8cv="k8 config view"
alias k8gc="k8 config get-contexts"
alias k8cc="k8 config current-context"
alias k8cuc="k8 config use-context"
alias k8csc="k8 config set-cluster"

# Namespace Operations
alias k8gn="k8 get namespaces"
alias k8cn="k8 create namespace"
alias k8dn="k8 delete namespace"

# Resource Management
alias k8g="k8 get"
alias k8c="k8 create"
alias k8d="k8 delete"
alias k8a="k8 apply"
alias k8dc="k8 diff -f"

# Pod Operations
alias k8gp="k8 get pods"
alias k8gpw="k8 get pods -o wide"
alias k8gpa="k8 get pods --all-namespaces"
alias k8gpn="k8 get pods -n"
alias k8gpsl="k8 get pods --show-labels"
alias k8gpr="k8 get pods --field-selector=status.phase=Running"
alias k8dp="k8 delete pod"
alias k8descp="k8 describe pods"
alias k8ep="k8 explain pods"

# Advanced Pod Queries
alias k8gprc="k8 get pods --sort-by=.status.containerStatuses[0].restartCount"
alias k8gpc="k8 get pods --all-namespaces -o jsonpath='{range .items[*].status.initContainerStatuses[*]}{.containerID}{\"\n\"}{end}' | cut -d/ -f3"
alias k8gps="k8 get pods -o json | jq '.items[].spec.containers[].env[]?.valueFrom.secretKeyRef.name' | grep -v null | sort | uniq"

# Deployment Operations
alias k8gd="k8 get deployments"
alias k8gda="k8 get deployments --all-namespaces"
alias k8cd="k8 create deployment"

# Service Operations
alias k8gs="k8 get services --sort-by=.metadata.name"
alias k8gsa="k8gs --all-namespaces"
alias k8gsvc="k8 get svc -A"

# Logging and Debugging
alias k8l="k8 logs"
alias k8ll="k8 logs -l name="
alias k8lp="k8 logs -f"
alias k8epb="k8 exec -it"

# Node Operations
alias k8descn="k8 describe nodes"
alias k8gneip="k8 get nodes -o jsonpath='{.items[*].status.addresses[?(@.type==\"ExternalIP\")].address}'"
alias k8gmsc="k8 get node minikube -o jsonpath='{.status.capacity}'"

# Storage Operations
alias k8gpv="k8 get pv --sort-by=.spec.capacity.storage"

# Event Monitoring
alias k8ge="k8 get events --sort-by=.metadata.creationTimestamp"
alias k8gew="k8 events --types=Warning"

# RBAC Operations
alias k8gcr="k8 get clusterroles"
alias k8gcrb="k8 get clusterrolebinding"
alias k8dcr="k8 delete clusterroles"
alias k8dcrb="k8 delete clusterrolebinding"

# ConfigMap Operations
alias k8ccm="k8 create configmap"
alias k8dcm="k8 delete configmap"
alias k8desccm="k8 describe configmap"

# Job Operations
alias k8gj="k8 get jobs"
alias k8dj="k8 delete jobs"

# Rollout Management
alias k8rr="k8 rollout restart"
alias k8rs="k8 rollout status"
alias k8rrs="k8 rollout resume"
alias k8rp="k8 rollout pause"
alias k8rh="k8 rollout history"
alias k8ru="k8 rollout undo"

# Scaling Operations
alias k8s="k8 scale"

# Dashboard Access
alias k8p="k8 proxy | browser http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"