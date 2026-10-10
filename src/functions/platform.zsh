# Platform engineering helpers (oliasoft / k8s / multi-cloud)

function ctx() {
  # One-glance view of the current cloud + cluster context
  echo "── kube ─────────────────────────"
  kubectl config current-context 2>/dev/null || echo "  (no kubectl context)"
  echo "── gcloud ───────────────────────"
  if command -v gcloud &> /dev/null; then
    gcloud config list --format 'value(core.project)' 2>/dev/null | sed '/^$/d; s/^/  project: /'
  else
    echo "  (gcloud not installed - enable with: tools.sh enable cloud)"
  fi
  echo "── aws ──────────────────────────"
  if command -v aws &> /dev/null; then
    echo "  account: $(aws sts get-caller-identity --query Account --output text 2>/dev/null || echo 'not authenticated')"
  else
    echo "  (aws cli not installed)"
  fi
}

function gke-auth() {
  # Fetch GKE credentials -> gke-auth <cluster> [project] [zone|region]
  [[ -n "$1" ]] || { echo "Usage: gke-auth <cluster> [project] [zone]"; return 1; }
  local project="${2:-$GCP_PROJECT}" zone="${3:-$GCP_LOCATION}"
  [[ -n "$project" ]] || { echo "No project given and GCP_PROJECT not set (~/.zsh/env/.env)"; return 1; }
  [[ -n "$zone" ]] || { echo "No zone/region given and GCP_LOCATION not set (~/.zsh/env/.env)"; return 1; }
  gcloud container clusters get-credentials "$1" --project "$project" --zone "$zone"
}

function gke-list() {
  # List GKE clusters in a project -> gke-list [project]
  gcloud container clusters list --project "${1:-$GCP_PROJECT}"
}

function aks-cred() {
  # Fetch AKS credentials -> aks-cred <cluster> <resource-group>
  [[ -n "$1" && -n "$2" ]] || { echo "Usage: aks-cred <cluster> <resource-group>"; return 1; }
  az aks get-credentials --name "$1" --resource-group "$2" --overwrite-existing
}

function eks-cred() {
  # Fetch EKS credentials -> eks-cred <cluster> [aws-profile]
  [[ -n "$1" ]] || { echo "Usage: eks-cred <cluster> [aws-profile]"; return 1; }
  AWS_PROFILE="${2:-$AWS_PROFILE}" aws eks update-kubeconfig --name "$1"
}

function portused() {
  # Who listens on a port -> portused 8080
  [[ -n "$1" ]] || { echo "Usage: portused <port>"; return 1; }
  lsof -nP -iTCP:"$1" -sTCP:LISTEN
}

function b64e() {
  # Base64 encode -> b64e 'text' | b64e < file
  printf '%s' "${*}" | base64
}

function b64d() {
  # Base64 decode -> b64d 'ZXhw' | b64d < file
  if [[ $# -gt 0 ]]; then printf '%s' "${*}" | base64 --decode; else base64 --decode; fi
  echo
}

function whoami-aws() {
  # Show current AWS identity
  aws sts get-caller-identity
}

function vault-login() {
  # Login to a vault server -> vault-login https://vault.example.com
  [[ -n "$1" ]] || { echo "Usage: vault-login <vault-url> [auth-method]"; return 1; }
  export VAULT_ADDR="$1"
  vault login "${2:-}"
}
