#!/usr/bin/env bash
# Remove everything the lab created. Safe to re-run.
set -uo pipefail
if [[ ${EUID} -ne 0 ]]; then echo "Run as root: sudo $0"; exit 1; fi
for u in forensic01 guest1 guest2; do
  if id "$u" >/dev/null 2>&1; then userdel -r "$u" 2>/dev/null && echo "Removed $u"; fi
done
rm -rf "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/evidence"
echo "Cleanup complete."
