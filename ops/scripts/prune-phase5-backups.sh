#!/usr/bin/env bash
# prune-phase5-backups.sh
# Retention pruning for phase 5 backups. DRY-RUN by default.
# Patterns are explicit - never deletes unlisted files (phase2 configs,
# secret txt files, compose backups are EXCLUDED from pruning).
# Usage: prune-phase5-backups.sh [--apply]
set -uo pipefail

ROOT=${MCT_STACK_ROOT:-/opt/mct-security-stack}
APPLY=0
[[ "${1:-}" == "--apply" ]] && APPLY=1

KEEP_DAYS_IRIS=${KEEP_DAYS_IRIS:-14}
KEEP_DAYS_MISP=${KEEP_DAYS_MISP:-14}
KEEP_DAYS_GREENBONE=${KEEP_DAYS_GREENBONE:-35}
KEEP_DAYS_SHUFFLE=${KEEP_DAYS_SHUFFLE:-56}

echo "== Backup retention prune ($([ $APPLY -eq 1 ] && echo APPLY || echo DRY-RUN)) =="

prune() {
  local label=$1 pattern=$2 keep_days=$3
  local removed=0 kept=0
  echo "--- $label (keep ${keep_days}d, pattern: $pattern) ---"
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    age_days=$(( ($(date +%s) - $(stat -c %Y "$f")) / 86400 ))
    if [ "$age_days" -gt "$keep_days" ]; then
      echo "  prune: $(basename "$f") (${age_days}d)"
      [ $APPLY -eq 1 ] && rm -f "$f"
      removed=$((removed+1))
    else
      kept=$((kept+1))
    fi
  done < <(find "$ROOT/ops/backups" -maxdepth 2 -type f \( -name "$pattern" -o -path "*/$pattern" \) 2>/dev/null | sort)
  echo "  kept: $kept, pruned: $removed"
}

# Explicit patterns only - phase2-config-*, *.txt secret files, *.bak compose
# backups are NEVER pruned by this script.
prune "IRIS DB dumps"      "iris-db-*.sql.gz"                 "$KEEP_DAYS_IRIS"
prune "MISP DB dumps"      "misp-db-*.sql.gz"                 "$KEEP_DAYS_MISP"
prune "Greenbone dumps"    "greenbone-gvmd-*.sql.gz"          "$KEEP_DAYS_GREENBONE"
prune "Shuffle exports"    "shuffle-workflows-*.json"         "$KEEP_DAYS_SHUFFLE"

echo
echo "Done ($([ $APPLY -eq 1 ] && echo applied || echo dry-run - re-run with --apply to delete))"
