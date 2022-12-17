#!/bin/bash

set -e

[[ -f ~/.zsh/.env ]] && source ~/.zsh/.env

# GitEnv
git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"
