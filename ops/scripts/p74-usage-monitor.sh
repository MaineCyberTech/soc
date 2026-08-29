#!/bin/sh
# Read-only Shuffle app-run usage monitor (P74 acceptance #4).
# Queries org_statistics (no mutation); reports usage / remaining_capacity /
# projected_exhaustion and emits WARNING/CRITICAL at configured thresholds.
# Does NOT reset the counter (counter mutation is forbidden by the Phase 74 overlay).
set +e
ES="http://172.20.0.1:9200"
IDX="org_statistics-000001"
ORG="264c0502-9136-4cfc-938b-390b97b861b8"
LIMIT=25000
WARN=5000
CRIT=1000

DOC=$(curl -s "$ES/$IDX/_doc/$ORG" 2>/dev/null)
if [ -z "$DOC" ]; then
  echo "$(date -u +%FT%TZ) USAGE-MONITOR-ERROR: cannot reach $ES/$IDX"
  exit 2
fi
MONTHLY=$(printf '%s' "$DOC" | python3 -c "import sys,json;d=json.load(sys.stdin);s=d.get('_source') or (d.get('hits',{}).get('hits',[{}])[0].get('_source',{}));print(s.get('monthly_app_executions',0) if s else 0)" 2>/dev/null)
USED=${MONTHLY:-0}
REMAIN=$((LIMIT - USED))
if [ "$REMAIN" -lt 0 ]; then REMAIN=0; fi

# Projection: rough days-to-exhaustion assuming prior-month volume (~25.4k) recurring.
if [ "$USED" -gt 0 ]; then
  DAYS=$(( (REMAIN * 30) / (USED > 0 ? USED : 1) ))
else
  DAYS=999
fi

if [ "$REMAIN" -le "$CRIT" ]; then
  LEVEL=CRITICAL
elif [ "$REMAIN" -le "$WARN" ]; then
  LEVEL=WARNING
else
  LEVEL=OK
fi

echo "$(date -u +%FT%TZ) SHUFFLE-APP-RUN usage=$USED/$LIMIT remaining=$REMAIN projected_days_to_exhaustion=$DAYS level=$LEVEL"
if [ "$LEVEL" = "CRITICAL" ]; then
  echo "  ACTION: obtain a Shuffle license or enable quota-safe degradation (counter reset is forbidden)."
  exit 1
fi
exit 0
