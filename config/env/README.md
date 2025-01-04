# Environment Configuration 🔒

This directory contains sensitive configuration files that shouldn't be committed to the repository.

## Setup

1. Copy the template file:
```bash
cp .env.example .env
```

2. Edit `.env` with your personal values:
```bash
vi .env
```

## Available Environment Variables

### Git Configuration
- `GIT_EMAIL`: Your git commit email
- `GIT_NAME`: Your git commit name

### API Tokens
- `IPINFO_TOKEN`: Token for ipinfo.io API (used by networking functions)
- `DOCKER_TOKEN`: Docker Hub access token (used for docker login)

## Security Notes
- Never commit `.env` file to the repository
- Keep your tokens secure and rotate them periodically
- The `.gitignore` is configured to ignore `.env` files

## Loading Mechanism
The environment variables are loaded automatically by:
1. `source.zsh` which sources this file
2. `env.plugins.zsh` which loads environment per directory

## Troubleshooting
If your environment variables aren't loading:
1. Check if `.env` file exists in this directory
2. Verify file permissions are correct: `chmod 600 .env`
3. Make sure the file is properly sourced in your `.zshrc`
4. Run `reload` to reload your shell configuration