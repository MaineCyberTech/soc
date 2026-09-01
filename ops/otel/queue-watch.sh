#!/bin/sh
# Phase-80 OTel queue byte-budget alert monitor.
# Measures the on-disk persistent queue size and alerts (exit 1) when it exceeds
# the configured ALERT_THRESHOLD_BYTES. The byte ceiling / filesystem budget for the
# queue is 16 MiB (16777216) enforced via a size-limited queue filesystem; this alert
# fires at 50% (8 MiB) so operators are warned before the bound is reached.
set -e
QDIR=/opt/mct-security-stack/data/otel-file-storage
ALERT_THRESHOLD_BYTES=8388608
# Measure with a root container because the queue dir is 0750/uid 10001.
DU=$(docker run --rm -v "$QDIR:/data" alpine sh -c 'du -sb /data 2>/dev/null | cut -f1' || echo 0)
DU=${DU:-0}
if [ "$DU" -gt "$ALERT_THRESHOLD_BYTES" ]; then
  echo "ALERT: OTel persistent queue size=${DU} bytes exceeds threshold=${ALERT_THRESHOLD_BYTES} bytes"
  exit 1
fi
echo "OK: OTel persistent queue size=${DU} bytes (threshold=${ALERT_THRESHOLD_BYTES} bytes)"
exit 0
