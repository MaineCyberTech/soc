#!/usr/bin/env bash
# misp-cdb-diff-report.sh
# Compares MISP CDB exports (before/after) and reports IOC churn.
# Usage: misp-cdb-diff-report.sh [--prev FILE] [--new FILE]
# Prints counts and newly added values (IOCs are not secrets). Never prints MISP API keys.
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
TS=$(date +%Y%m%d-%H%M%S)
REPORT="$ROOT/ops/reports/misp-cdb-diff-$TS.md"
NEW="${2:-$ROOT/ops/cdb/misp-iocs}"
PREV="${1:-$ROOT/ops/cdb/misp-iocs.prev}"

mkdir -p "$ROOT/ops/reports"

if [[ ! -f "$PREV" ]]; then
  echo "No previous CDB snapshot at $PREV - treating as first run"
  cp "$NEW" "$PREV" 2>/dev/null || true
  PREV_EXISTS=0
else
  PREV_EXISTS=1
fi

{
  echo "# MISP CDB Diff Report - $TS"
  echo
  echo "New CDB: $NEW ($(wc -l < "$NEW" 2>/dev/null || echo 0) lines)"
  echo "Prev CDB: $PREV ($(wc -l < "$PREV" 2>/dev/null || echo 0) lines)"
  echo
  if [ "$PREV_EXISTS" -eq 1 ]; then
    ADDED=$(comm -13 <(sort "$PREV" 2>/dev/null) <(sort "$NEW" 2>/dev/null) | grep -c . || true)
    REMOVED=$(comm -23 <(sort "$PREV" 2>/dev/null) <(sort "$NEW" 2>/dev/null) | grep -c . || true)
    echo "## Churn"
    echo "- Added IOCs: $ADDED"
    echo "- Removed IOCs: $REMOVED"
    echo
    echo "## Newly added values"
    comm -13 <(sort "$PREV" 2>/dev/null) <(sort "$NEW" 2>/dev/null) | head -50
    echo
    echo "## Removed values"
    comm -23 <(sort "$PREV" 2>/dev/null) <(sort "$NEW" 2>/dev/null) | head -50
  fi
} > "$REPORT"

cp "$NEW" "$PREV"
echo "Wrote $REPORT (snapshot updated)"
