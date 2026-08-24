#!/usr/bin/env bash
set -euo pipefail
ROOT=${ROOT:-/opt/mct-security-stack}; OUT=${OUT:-$ROOT/ops/reports/p30-infrastructure-audit-$(date +%Y%m%d-%H%M%S).txt}; mkdir -p "$(dirname "$OUT")"
{
 echo '# host'; uname -a; uptime; free -h; df -hT; df -ih; ip -brief addr 2>/dev/null || true; ip route 2>/dev/null || true
 echo '# docker'; docker ps -a 2>/dev/null || true; docker system df 2>/dev/null || true; docker network ls 2>/dev/null || true; docker volume ls 2>/dev/null || true
 echo '# services'; systemctl --failed 2>/dev/null || true; systemctl list-timers --all 2>/dev/null || true
 echo '# cron'; crontab -l 2>/dev/null || true; find /etc/cron.d /etc/cron.* -maxdepth 2 -type f -print 2>/dev/null || true
 echo '# listeners'; ss -lntup 2>/dev/null || true
 echo '# compose'; find /opt -type f \( -name 'docker-compose*.yml' -o -name 'compose*.yaml' \) 2>/dev/null | sort
} > "$OUT"; echo "Wrote $OUT"
