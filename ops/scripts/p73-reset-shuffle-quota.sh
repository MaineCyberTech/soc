#!/bin/sh
# Dev workaround for Shuffle's free-tier 25,000 app-run monthly quota.
#
# Shuffle (open-source/freemium) drops/queues executions once an org exceeds
# 25,000 app runs in a month. There is NO supported or undocumented env-var
# bypass (the only related knob is SHUFFLE_LICENSE, i.e. a paid key). The
# backend trusts the per-org counter stored in OpenSearch (org_statistics-000001),
# so zeroing it restores execution. This script does exactly that.
#
# This is NOT a substitute for a Shuffle license and should only be used in a
# non-production / dev environment. For sustained or production use, obtain a
# license. To run automatically, install a monthly (or more frequent) timer, e.g.:
#   0 3 1 * * /opt/mct-security-stack/ops/scripts/p73-reset-shuffle-quota.sh >> /var/log/shuffle-quota-reset.log 2>&1
#
# Safe to re-run: it only sets numeric counters to 0 (idempotent).

set -e

OS="${SHUFFLE_OPENSEARCH_URL:-http://172.20.0.1:9200}"
ORG="${SHUFFLE_ORG_ID:-264c0502-9136-4cfc-938b-390b97b861b8}"

curl -sk -X POST "$OS/org_statistics-000001/_update/$ORG" \
  -H 'Content-Type: application/json' \
  -d '{"doc":{"total_app_executions":0,"monthly_app_executions":0,"monthly_api_usage":0,"weekly_app_executions":0,"daily_app_executions":0,"total_api_calls":0,"monthly_workflow_executions":0}}' \
  && echo "Shuffle app-run quota counters reset for org $ORG"
