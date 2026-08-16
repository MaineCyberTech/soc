#!/usr/bin/env bash
# Placeholder: create a test alert in DFIR-IRIS from a payload file.
# Usage: iris-create-test-alert.sh integrations/payload-contracts/wazuh-high-severity.json
set -euo pipefail

IRIS_URL="${IRIS_URL:-http://127.0.0.1:8000}"
IRIS_API_KEY="${IRIS_API_KEY:-}"

PAYLOAD="${1:?usage: $0 <payload-json-file>}"

if [[ -z "$IRIS_API_KEY" ]]; then
  echo "Set IRIS_API_KEY in environment (do not hardcode)." >&2
  exit 1
fi

curl -sk -X POST "${IRIS_URL}/api/alert" \
  -H "Authorization: Bearer ${IRIS_API_KEY}" \
  -H "Content-Type: application/json" \
  -d @"${PAYLOAD}" \
  -w '\nHTTP %{http_code}\n'
