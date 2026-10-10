# DotFiles 🫶🏻
Modern dotfiles management with easy installation and customization.

## 🌟 Features
- **Tool profiles** in `config/tools/*.json` with per-profile enable/disable flags
- `tools.sh` CLI: list / enable / disable / install / status / vscode
- Organized aliases and functions by category (`k8s`, `docker`, `git`, `networking`, `platform`, ...)
- Platform-engineering tooling: Terraform/OpenTofu, kustomize, helmfile, flux, argocd, vault, sops, trivy, ...
- Secure environment variable management (`config/env/.env`, git-ignored)
- Easy synchronization with home directory

## 🔧 Installation
```bash
git clone https://github.com/robipresotto/dotFiles.git
cd dotFiles
./scripts/install.sh                 # installs everything from enabled profiles
./scripts/install.sh --dry-run       # preview what would be installed
```
Then set "FiraCode Nerd Font" as your terminal font (cask `font-fira-code-nerd-font`, in `config/tools/base.json`).

## 📦 Tool profiles
Each file in `config/tools` is a profile with an `enabled` flag; only enabled profiles are installed.

| Profile      | Contents                                                            | Default   |
|--------------|---------------------------------------------------------------------|-----------|
| `base`       | shell essentials (jq, fzf, eza, zoxide, tmux, git, nerd font, ...)  | enabled   |
| `kubernetes` | kubectl, helm, kustomize, helmfile, flux, argocd, k9s, stern, ...    | enabled   |
| `cloud`      | aws/az/gcloud CLIs, aws-vault                                        | enabled   |
| `platform`   | terraform, opentofu, vault, packer, ansible, sops, trivy, cosign..  | enabled   |
| `networking` | nmap, mtr, iperf3, k6, tcpdump, ngrep, ...                            | enabled   |
| `dev`        | node, gh, shellcheck, pre-commit, VS Code, LM Studio                  | enabled   |
| `database`   | postgres, mysql-client, mongosh, redis, mycli                         | enabled   |
| `bio`        | samtools, bcftools, igv, ... (previous job)                           | disabled  |

Manage them from the shell (after install, `tools` is a function):
```bash
tools list              # see profiles and package counts
tools disable bio       # keep it around but stop installing it
tools enable platform
tools install --dry-run # preview
tools status            # what is installed vs missing per profile
tools vscode            # install extensions from config/vscode/extensions.txt
```
Or directly: `scripts/tools.sh <command>`.

### Adding a tool
Just edit the right profile:
```json
{
  "enabled": true,
  "brew": {
    "taps": ["fluxcd/tap"],
    "formulas": ["kubernetes-cli"],
    "casks": ["lens"]
  }
}
```
Tapped formulas use their full name (`fluxcd/tap/flux`). Run `tools install` afterwards.

> Heads-up on brew naming: `kubectl` is installed by the formula `kubernetes-cli`,
> `kubens` comes with `kubectx`, and the Flux CLI is `fluxcd/tap/flux`
> (homebrew-core's `flux` is InfluxData's language, not FluxCD).

### Environment Variables
1. Copy the template: `cp config/env/.env.example config/env/.env`
2. Edit with your values (git credentials, tokens, `GCP_PROJECT`, ...):
```bash
IPINFO_TOKEN=xxx
GIT_EMAIL=xxx
GIT_NAME=xxx
```

## 🔄 Updates
```bash
update            # git pull + sync + reload
update_tools      # brew update/upgrade + install enabled profiles
```

## 🆘 Help
```bash
help           # all aliases & functions
help k8        # filter by category/name
```
