# Terraform / OpenTofu
alias t='terraform'
alias ti='t init -upgrade'
alias tfp='t plan'
alias tfa='t apply'
alias tfaa='t apply -auto-approve'
alias tff='t fmt -recursive'
alias tfs='t show'
alias tfo='t output'
alias td='t destroy'
alias tof='tofu'

# Secrets & signing
alias sopsd='sops -d'
alias sev='sops -e'
alias cv='cosign verify'

# Scanning
alias tri='trivy'
alias trim='trivy image'
alias trif='trivy fs .'
alias gru='grype'

# Docker image inspection
alias dv='dive'

# Load testing
alias k6run='k6 run'
