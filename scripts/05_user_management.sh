#!/usr/bin/env bash
# Part 4: create, modify and delete temporary users.
set -euo pipefail
# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_root

step "Part 4.1 - Create guest1 and guest2"
for u in guest1 guest2; do
  if id "$u" >/dev/null 2>&1; then
    info "$u already exists - skipping"
  else
    useradd -m -s /bin/bash "$u"
  fi
done
id guest1; id guest2

step "Part 4.2 - Add guest1 to the sudo group"
usermod -aG sudo guest1
id guest1

step "Part 4.3 - Delete guest2 including home directory"
userdel -r guest2
id guest2 2>&1 || info "guest2 no longer exists (expected)"
ls -ld /home/guest2 2>&1 || info "/home/guest2 removed (expected)"
