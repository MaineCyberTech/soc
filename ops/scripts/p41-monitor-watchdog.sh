#!/usr/bin/env bash
# p41-monitor-watchdog.sh (Phase 41 hardening, report phase41-39)
# Missed-schedule detector for ALERT-39-01 delivery monitor (p39-iris-delivery-check.sh).
# Compares age of shuffle-delivery-monitor.log mtime against a 20-minute staleness
# threshold (monitor cadence is */15). On stall: writes one ALERT line to a DEDICATED
# watchdog log (NOT the monitored log - appending there would refresh its mtime and
# mask the stall), repeated at most once per hour per continuous stall episode.
# Never prints tokens. Exit 0 always (watchdog must never fail a cron slot noisily).
# Test overrides: MCT_MONITOR_LOG=<path> MCT_WATCHDOG_LOG=<path> p41-monitor-watchdog.sh [--verbose]
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
LOG=${MCT_MONITOR_LOG:-$ROOT/ops/reports/shuffle-delivery-monitor.log}
WATCHLOG=${MCT_WATCHDOG_LOG:-$ROOT/ops/reports/p41-monitor-watchdog.log}
STATE=/tmp/opencode/p41-mon-watchdog.state
THRESHOLD_S=1200      # 20 minutes: >1 missed */15 slot
REPEAT_S=3600         # re-alert at most hourly during a continuous stall
VERBOSE=${1:-}

[ -f "$LOG" ] || { echo "$(date -u +%FT%TZ) ALERT-MON-WATCHDOG: monitor log missing at $LOG" >> "$WATCHLOG"; exit 0; }

now=$(date +%s)
mtime=$(stat -c %Y "$LOG" 2>/dev/null || echo "$now")
age=$((now - mtime))

if [ "$age" -le "$THRESHOLD_S" ]; then
  rm -f "$STATE"
  [ -n "$VERBOSE" ] && echo "OK: monitor log fresh (age=${age}s <= ${THRESHOLD_S}s)"
  exit 0
fi

last_alert=0
[ -f "$STATE" ] && last_alert=$(cat "$STATE" 2>/dev/null || echo 0)
if [ $((now - last_alert)) -ge "$REPEAT_S" ]; then
  echo "$(date -u +%FT%TZ) ALERT-MON-WATCHDOG: delivery-monitor log STALE age=${age}s (threshold ${THRESHOLD_S}s) - cron slot(s) likely missed" >> "$WATCHLOG"
  echo "$now" > "$STATE"
  [ -n "$VERBOSE" ] && echo "ALERT written to $WATCHLOG (stale age=${age}s)"
else
  [ -n "$VERBOSE" ] && echo "stale already alerted this episode (age=${age}s)"
fi
exit 0
