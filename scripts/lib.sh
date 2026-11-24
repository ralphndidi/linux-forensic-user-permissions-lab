#!/usr/bin/env bash
# Shared helpers for the lab scripts. Source this file; do not execute it.

LAB_USER="${LAB_USER:-forensic01}"
LAB_HOME="/home/${LAB_USER}"

info()  { printf '\n\033[1;34m[INFO]\033[0m %s\n' "$*"; }
step()  { printf '\n\033[1;32m=== %s ===\033[0m\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m %s\n' "$*" >&2; }
fail()  { printf '\033[1;31m[FAIL]\033[0m %s\n' "$*" >&2; exit 1; }

require_root() {
  [[ ${EUID} -eq 0 ]] || fail "Run as root:  sudo $0"
}

# Use sudo for privileged commands when it is installed (mirrors the lab text).
SUDO=""
if command -v sudo >/dev/null 2>&1; then SUDO="sudo"; fi

# Run a one-line command as the lab user, in a login shell (HOME is set).
run_as_lab() {
  runuser -l "${LAB_USER}" -c "$1"
}
