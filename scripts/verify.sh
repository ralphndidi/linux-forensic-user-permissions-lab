#!/usr/bin/env bash
# Assert that every lab requirement is met. Exit non-zero on any failure.
set -uo pipefail
PASS=0; FAILED=0
check() { # check "description" command...
  local d="$1"; shift
  if "$@" >/dev/null 2>&1; then echo "PASS  $d"; PASS=$((PASS+1))
  else echo "FAIL  $d"; FAILED=$((FAILED+1)); fi
}
L=/home/forensic01/logs

check "forensic01 exists"                    id forensic01
check "forensic01 shell is /bin/bash"        test "$(getent passwd forensic01 | cut -d: -f7)" = "/bin/bash"
check "forensic01 home directory exists"     test -d /home/forensic01
check "forensic01 is in sudo group"          bash -c 'id -nG forensic01 | tr " " "\n" | grep -qx sudo'
check "logs directory exists"                test -d "$L"
check "sys_events.log has >= 20 lines"       test "$(wc -l < $L/sys_events.log)" -ge 20
check "log contains ERROR/WARNING/INFO"      bash -c "grep -q ERROR $L/sys_events.log && grep -q WARNING $L/sys_events.log && grep -q INFO $L/sys_events.log"
check "log contains user01 and root"         bash -c "grep -q user01 $L/sys_events.log && grep -q root $L/sys_events.log"
check "log contains timestamps"              bash -c "grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9:]{8}' $L/sys_events.log"
check "error_report.txt is not empty"        test -s "$L/error_report.txt"
check "confidential.txt exists"              test -e "$L/confidential.txt"
check "confidential.txt mode is 600"         test "$(stat -c %a $L/confidential.txt)" = "600"
check "confidential.txt owner is root"       test "$(stat -c %U $L/confidential.txt)" = "root"
check "forensic01 CANNOT read confidential"  bash -c "! runuser -u forensic01 -- cat $L/confidential.txt"
check "forensic01 CANNOT edit confidential"  bash -c "! runuser -u forensic01 -- bash -c 'echo x >> $L/confidential.txt'"
check "guest1 exists"                        id guest1
check "guest1 is in sudo group"              bash -c 'id -nG guest1 | tr " " "\n" | grep -qx sudo'
check "guest2 removed"                       bash -c '! id guest2'
check "guest2 home removed"                  test ! -d /home/guest2

echo "-----------------------------------"
echo "Passed: $PASS   Failed: $FAILED"
[[ $FAILED -eq 0 ]]
