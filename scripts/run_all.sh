#!/usr/bin/env bash
# Run the full lab end-to-end and save the transcript to evidence/.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$DIR")"
mkdir -p "$ROOT/evidence"

{
  "$DIR/01_user_setup.sh"
  "$DIR/02_create_logs.sh"
  "$DIR/03_log_analysis.sh"
  "$DIR/04_permissions.sh"
  "$DIR/05_user_management.sh"
} 2>&1 | tee "$ROOT/evidence/lab_run.log"

# Collect evidence files (root can read them even after chown)
cp /home/forensic01/logs/sys_events.log   "$ROOT/evidence/" 2>/dev/null || true
cp /home/forensic01/logs/error_report.txt "$ROOT/evidence/" 2>/dev/null || true
ls -l /home/forensic01/logs/ > "$ROOT/evidence/ls_logs.txt"
echo "Evidence saved to $ROOT/evidence/"
