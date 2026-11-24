#!/usr/bin/env bash
# Part 1 (step 3): create ~/logs and sys_events.log using echo and cat.
set -euo pipefail
# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_root

step "Part 1.3 - Create logs directory and sys_events.log as ${LAB_USER}"

# Everything between the USERSIDE markers runs as forensic01.
runuser -l "${LAB_USER}" -c 'bash -s' <<'USERSIDE'
set -euo pipefail
mkdir -p /home/forensic01/logs
cd /home/forensic01/logs

# First lines with echo (> creates/overwrites, >> appends)
echo "2025-03-10 08:00:01 INFO  [system] Boot sequence completed" > sys_events.log
echo "2025-03-10 08:01:15 INFO  [sshd] Accepted password for user01 from 192.168.1.10" >> sys_events.log
echo "2025-03-10 08:02:42 WARNING [disk] Disk usage at 85% on /dev/sda1" >> sys_events.log
echo "2025-03-10 08:05:09 ERROR [sshd] Failed password for root from 203.0.113.45" >> sys_events.log
echo "2025-03-10 08:05:31 ERROR [sshd] Failed password for root from 203.0.113.45" >> sys_events.log

# Remaining lines with cat and a here-document
cat >> sys_events.log <<'LOGS'
2025-03-10 08:07:00 INFO  [cron] root ran /usr/local/bin/backup.sh
2025-03-10 08:10:12 WARNING [memory] Memory usage above 75%
2025-03-10 08:12:44 INFO  [sudo] user01 : TTY=pts/0 ; COMMAND=/bin/ls /root
2025-03-10 08:15:03 ERROR [kernel] I/O error on device sdb, sector 4096
2025-03-10 08:18:27 INFO  [systemd] Started Daily apt download activities
2025-03-10 08:20:55 WARNING [auth] Multiple failed logins for user01
2025-03-10 08:22:10 INFO  [sshd] Accepted publickey for root from 10.0.0.5
2025-03-10 08:25:36 ERROR [apache2] Segmentation fault (core dumped)
2025-03-10 08:30:00 INFO  [cron] user01 ran /home/user01/cleanup.sh
2025-03-10 08:33:48 WARNING [network] Interface eth0 packet loss detected
2025-03-10 08:36:21 INFO  [useradd] New user created: guest_test
2025-03-10 08:40:02 ERROR [mysql] Connection refused for user01@localhost
2025-03-10 08:42:19 INFO  [sudo] root : session opened for user root
2025-03-10 08:45:57 WARNING [fail2ban] Banned IP 203.0.113.45
2025-03-10 08:50:33 INFO  [system] Scheduled maintenance started
LOGS

echo "--- Lines written: $(wc -l < sys_events.log) ---"
ls -l /home/forensic01/logs/
USERSIDE
