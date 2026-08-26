#!/usr/bin/env bash
# p40-field-growth-check.sh — mapped-field growth guardrail (Phase 40, G40-07)
#
# Purpose : deep-count leaf fields on today's wazuh-archives index and compare
#           against the P39-approved thresholds (soft 1400 WARN / hard 1800 CRIT
#           vs effective limit 2000). Appends one line to the monitor log and a
#           trend-state row for daily-growth math. Never prints secret values.
# Owner   : MCT SOC (per phase40-11)
# Run     : ops/scripts/p40-field-growth-check.sh [index-name]
# Exit    : 0 = OK, 1 = WARN (>= soft), 2 = CRIT (>= hard), 3 = error
# Refs    : phase39-26 §7, phase39-28 §5, phase40-11

set -euo pipefail

CREDS=/opt/wazuh-docker/multi-node/ops/creds.env
URL=https://127.0.0.1:9200
SOFT=${P40_SOFT:-1400}
HARD=${P40_HARD:-1800}
LIMIT=2000
LOG=/opt/mct-security-stack/ops/reports/p40-field-growth.log
STATE=/opt/mct-security-stack/ops/evidence/p40-field-growth-state.tsv

[ -r "$CREDS" ] || { echo "ERROR: creds env not readable at $CREDS" >&2; exit 3; }
set -a; . "$CREDS"; set +a
: "${WAZUH_ADMIN_PASSWORD:?WAZUH_ADMIN_PASSWORD not set in creds env}"

IDX="${1:-wazuh-archives-4.x-$(date -u +%Y.%m.%d)}"

MAP_JSON=$(curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" "${URL}/${IDX}/_mapping") || { echo "ERROR: mapping fetch failed" >&2; exit 3; }

read -r COUNT BRANCHES < <(printf '%s' "$MAP_JSON" | python3 -c '
import json,sys
m=json.load(sys.stdin)
leaves=[]; top={}
def walk(node,path):
    for k,v in node.items():
        p=f"{path}.{k}" if path else k
        if "properties" in v:
            walk(v["properties"],p)
        elif "fields" in v:
            leaves.append(p)
            for mk in v["fields"]: leaves.append(f"{p}.{mk}")
        else:
            leaves.append(p)
for name,body in m.items():
    walk(body.get("mappings",{}).get("properties",{}),"")
    t=name
for l in leaves:
    b=l.split(".")[0]; top[b]=top.get(b,0)+1
br=" ".join(f"{k}:{v}" for k,v in sorted(top.items(),key=lambda x:-x[1])[:6])
print(len(leaves), br)
') || { echo "ERROR: count parse failed" >&2; exit 3; }

TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
if   [ "$COUNT" -ge "$HARD" ]; then VERDICT="CRIT"; RC=2;
elif [ "$COUNT" -ge "$SOFT" ]; then VERDICT="WARN"; RC=1;
else                                VERDICT="OK";   RC=0; fi

# Daily-growth trend from prior state rows (ts<TAB>count)
GROWTH="n/a"
if [ -s "$STATE" ]; then
    read -r PTS PCNT < <(tail -1 "$STATE" | awk '{print $1"\t"$2}')
    PD=$(date -d "$PTS" +%s 2>/dev/null || echo "")
    CD=$(date -d "$TS" +%s)
    if [ -n "$PD" ] && [ "$CD" -gt "$PD" ]; then
        DAYS=$(python3 -c "print(max(($CD-$PD)/86400,1/24))")
        GROWTH=$(python3 -c "print(round(($COUNT-$PCNT)/$DAYS,1))")
    fi
fi
printf '%s\t%s\n' "$TS" "$COUNT" >> "$STATE"

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) p40-field-growth index=${IDX} leaf_fields=${COUNT} limit=${LIMIT} soft=${SOFT} hard=${HARD} verdict=${VERDICT} growth_per_day=${GROWTH} branches[${BRANCHES}]" >> "$LOG"
echo "p40-field-growth index=${IDX} leaf_fields=${COUNT} limit=${LIMIT} verdict=${VERDICT} growth_per_day=${GROWTH}"
echo "branches: ${BRANCHES}"
echo "log: ${LOG} state: ${STATE}"
exit $RC
