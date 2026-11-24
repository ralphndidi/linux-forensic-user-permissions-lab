#!/usr/bin/env bash
# Part 2: grep, piping/redirection, head/tail, cat.
set -euo pipefail
# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_root

step "Part 2 - Log filtering & analysis as ${LAB_USER}"

runuser -l "${LAB_USER}" -c 'bash -s' <<'USERSIDE'
set -euo pipefail
cd /home/forensic01/logs

echo; echo "### 2.1 grep: all ERROR lines"
grep "ERROR" sys_events.log

echo; echo "### 2.1 grep: lines mentioning root or user01"
grep -E "root|user01" sys_events.log

echo; echo "### 2.2 Pipe grep results to less (-F exits if it fits one screen)"
grep "ERROR" sys_events.log | less -FRX
grep -E "root|user01" sys_events.log | less -FRX

echo; echo "### 2.2 Redirect results to error_report.txt"
grep "ERROR" sys_events.log > error_report.txt
grep -E "root|user01" sys_events.log >> error_report.txt
echo "error_report.txt now has $(wc -l < error_report.txt) lines"

echo; echo "### 2.3 First 5 lines (head)"
head -n 5 sys_events.log
echo; echo "### 2.3 Last 5 lines (tail)"
tail -n 5 sys_events.log

echo; echo "### 2.4 Full log (cat)"
cat sys_events.log
USERSIDE
