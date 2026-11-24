#!/usr/bin/env bash
# Part 3: chmod, chown, and observing the effect.
set -euo pipefail
# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_root

step "Part 3.1 - Create confidential.txt and set 600 (rw- --- ---)"
runuser -l "${LAB_USER}" -c 'bash -s' <<'USERSIDE'
set -euo pipefail
cd /home/forensic01/logs
echo "Top secret forensic notes" > confidential.txt
chmod 600 confidential.txt
ls -l confidential.txt
USERSIDE

step "Part 3.2 - Change owner to root (sudo chown)"
${SUDO} chown root:root "${LAB_HOME}/logs/confidential.txt"
ls -l "${LAB_HOME}/logs/confidential.txt"

step "Part 3.3 - Observe: forensic01 tries to read and edit the file"
set +e
echo "\$ cat confidential.txt"
run_as_lab 'cat ~/logs/confidential.txt'
echo "(exit code: $?)"
echo "\$ echo 'edit' >> confidential.txt"
run_as_lab "echo 'edit' >> ~/logs/confidential.txt"
echo "(exit code: $?)"
set -e

info "Both attempts should say 'Permission denied': owner is now root, mode 600."
