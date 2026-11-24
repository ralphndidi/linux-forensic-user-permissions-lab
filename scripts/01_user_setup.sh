#!/usr/bin/env bash
# Part 1 (steps 1-2): create forensic01, add to sudo, set a password.
set -euo pipefail
# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_root

step "Part 1.1 - Create user ${LAB_USER}"
if id "${LAB_USER}" >/dev/null 2>&1; then
  info "User ${LAB_USER} already exists - skipping useradd"
else
  useradd -m -s /bin/bash "${LAB_USER}"
fi

usermod -aG sudo "${LAB_USER}"

# Password: LAB_PASSWORD in automation, interactive prompt on a terminal,
# or a random throw-away password as a last resort.
if [[ -n "${LAB_PASSWORD:-}" ]]; then
  echo "${LAB_USER}:${LAB_PASSWORD}" | chpasswd
  info "Password set from LAB_PASSWORD"
elif [[ -t 0 ]]; then
  passwd "${LAB_USER}"
else
  echo "${LAB_USER}:$(head -c 18 /dev/urandom | base64)" | chpasswd
  warn "No LAB_PASSWORD and no TTY - set a random throw-away password"
fi

step "Verification"
id "${LAB_USER}"
getent passwd "${LAB_USER}"

step "Part 1.2 - Switch to ${LAB_USER} (interactive: 'su - ${LAB_USER}')"
run_as_lab 'whoami && pwd'
