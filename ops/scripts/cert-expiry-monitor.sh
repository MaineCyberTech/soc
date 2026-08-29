#!/usr/bin/env bash
# cert-expiry-monitor.sh - report TLS cert days-to-expiry and alert if near expiry
# Usage: cert-expiry-monitor.sh [CERT_PATH] [WARN_DAYS]
set -euo pipefail
CERT="${1:-/www/certs/iris_dev_cert.pem}"
WARN="${2:-30}"
if [ ! -r "$CERT" ]; then echo "ERROR: cannot read $CERT"; exit 2; fi
END=$(openssl x509 -in "$CERT" -noout -enddate | cut -d= -f2)
END_EPOCH=$(date -d "$END" +%s)
NOW=$(date +%s)
DAYS=$(( (END_EPOCH - NOW) / 86400 ))
SUBJ=$(openssl x509 -in "$CERT" -noout -subject | cut -d= -f2-)
echo "cert=$CERT subject=$SUBJ days_to_expiry=$DAYS warn_threshold=$WARN"
if [ "$DAYS" -lt "$WARN" ]; then
  echo "ALERT: certificate expires in $DAYS days (below $WARN-day threshold)"
  exit 1
fi
echo "OK: certificate valid for $DAYS days"
exit 0
