# Basic minikube commands
alias mk="minikube"
alias mks="mk start"
alias mkx="mk stop"
alias mkt="mk status"
alias mkp="mk pause"
alias mku="mk unpause"
alias mkd="mk delete"

# Profile related commands
alias mkdp="mkd --profile"
alias mkpfl="mk profile list"

# Dashboard and options
alias mkdb="mk dashboard"
alias mko="mk options"

# Logs and images
alias mkl="mk logs"
alias mki="mk image load"

# Addons
alias mkem="mk addons enable metrics-server"
alias mkelb="mk addons enable metallb"
alias mkclb="mk addons configure metallb"
alias mkelv="mk addons enable logviewer"

# Configuration
alias mkcm="mk config set memory"
alias mkcc="mk config set cpus"
alias mkcv="mk config view"

# IP and SSH
alias mkip="mk ip"
alias mksh="mk ssh-host"
alias mkssk="mk ssh-key"

# Version and update
alias mkv="mk version"
alias mkup="mk update"

# Service URL
alias mkurl="mk service --url"

# Kubectl context
alias mkctx="mk kubectl config use-context"
alias mkctxl="mk kubectl config get-contexts"

# Node related commands
alias mknl="mk node list"
alias mkns="mk node start"
alias mknx="mk node stop"
alias mknr="mk node restart"
alias mknc="mk node config"
alias mknsh="mk node ssh"