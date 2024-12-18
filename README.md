# DotFiles 🫶🏻
Modern dotfiles management with easy installation and customization.

## 🌟 Features
- Automated tool installation via configuration
- Organized aliases and functions by category
- Kubernetes, Docker, and Git tooling
- Secure environment variable management
- Easy synchronization with home directory

## 🔧 Installation
```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
./scripts/install.sh
```

## 📝 Configuration
### Tools
Add new tools in `config/tools.json`:
```json
{
  "brew": {
    "taps": [...],
    "casks": [...],
    "formulas": [...]
  }
}
```

### Environment Variables
1. Copy the template: `cp src/env/.env.example src/env/.env`
2. Edit with your values:
```bash
IPINFO_TOKEN=xxx
GIT_EMAIL=xxx
GIT_NAME=xxx
```

## 🔄 Updates
```bash
update
```

## 🆘 Help
```bash
help category  # e.g., help k8
```