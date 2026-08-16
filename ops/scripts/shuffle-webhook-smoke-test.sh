#!/usr/bin/env bash
# shuffle-webhook-smoke-test.sh
# Safe webhook smoke test. Dry-run default (no calls). With SHUFFLE_WEBHOOK_URL
# env, POSTs a safe static payload (RFC5737 test IP, no secrets).
# Usage:
#   shuffle-webhook-smoke-test.sh --dry-run          (default, safe)
#   SHUFFLE_WEBHOOK_URL=<url> shuffle-webhook-smoke-test.sh
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
TS=$(date +%Y%m%d-%H%M%S)
OUT="$ROOT/ops/reports/shuffle-webhook-smoke-test-$TS.md"
MODE="${1:---dry-run}"
if [ -n "${SHUFFLE_WEBHOOK_URL:-}" ] && [ "$MODE" = "--dry-run" ]; then
  MODE="live"
fi
mkdir -p "$ROOT/ops/reports"

URL="${SHUFFLE_WEBHOOK_URL:-}"

PAYLOAD='{"source":"shuffle-webhook-smoke-test","rule_id":"121000","rule_level":12,"rule_description":"safe smoke test","agent_name":"smoke","srcip":"203.0.113.99","timestamp":"'"$TS"'"}'

{
  echo "# Shuffle Webhook Smoke Test - $TS"
  echo
  echo "Mode: $MODE"
  echo
  if [ "$MODE" = "--dry-run" ]; then
    echo "## Result: DRY-RUN (no webhook called)"
    echo
    echo "To run a live safe test:"
    echo '  SHUFFLE_WEBHOOK_URL=http://127.0.0.1:3001/api/v1/hooks/webhook_<id> \\'
    echo '    /opt/mct-security-stack/ops/scripts/shuffle-webhook-smoke-test.sh'
    echo
    echo "Payload would be: $PAYLOAD"
  elif [ -z "$URL" ]; then
    echo "## Result: NO URL - set SHUFFLE_WEBHOOK_URL to run a live test"
  else
    code=$(curl -s -o /tmp/opencode/webhook-resp.txt -w '%{http_code}' -m 10 -X POST \
      "$URL" -H 'Content-Type: application/json' -d "$PAYLOAD" 2>/dev/null || echo 000)
    resp=$(head -c 200 /tmp/opencode/webhook-resp.txt 2>/dev/null)
    echo "## Result: HTTP $code"
    echo
    echo "Response: $resp"
    echo
    if [ "$code" = "200" ]; then
      echo "PASS: webhook accepted (200). Check Shuffle UI -> Runs for execution."
    else
      echo "CHECK: HTTP $code - verify in Shuffle UI (400 may mean schema mismatch, 404 wrong URL, 5xx backend issue)."
    fi
  fi
} > "$OUT"
echo "Wrote $OUT"
