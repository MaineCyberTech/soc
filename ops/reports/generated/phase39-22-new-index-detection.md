# Phase 39 New-Index Detection

**Report ID:** phase39-22-new-index-detection  
**Phase:** 39  
**Title:** First Post-Fix Index Detection — `wazuh-archives-4.x-2026.08.26` Creation Window, Capture Checklist, and Ready-to-Run Verification Script  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:00:00Z  
**Classification:** INTERNAL  
**Status:** PENDING  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-22-new-index-detection.md`  
**Unblock Condition:** first matching index roll at 2026-08-26T00:00:02Z ±2s

---

## 1. Purpose

Defines exactly how the first index created under `wazuh-archives-fieldlimit`
(priority 320) will be detected and what must be captured for the downstream proof
reports (phase39-23/24/25). Nothing in this report is yet verifiable: at writing
(2026-08-25T23:00Z) the newest archive index is 08.25, created BEFORE the template.
This is an honest PENDING, not a gap — the fix can only manifest on a creation-time
boundary.

## 2. Expected Creation Window — MEASURED basis

Historical creation timestamps (live `_cat/indices`, full 11-index set):

```
wazuh-archives-4.x-2026.08.15  2026-08-15T21:00:44.251Z   ← outlier (rebuild-time manual)
wazuh-archives-4.x-2026.08.16  2026-08-16T00:00:01.702Z
wazuh-archives-4.x-2026.08.17  2026-08-17T00:00:02.094Z
wazuh-archives-4.x-2026.08.18  2026-08-18T00:00:01.869Z
wazuh-archives-4.x-2026.08.19  2026-08-19T00:00:01.954Z
wazuh-archives-4.x-2026.08.20  2026-08-20T00:00:02.537Z
wazuh-archives-4.x-2026.08.21  2026-08-21T00:00:03.199Z
wazuh-archives-4.x-2026.08.22  2026-08-22T00:00:02.243Z
wazuh-archives-4.x-2026.08.23  2026-08-23T00:00:02.625Z
wazuh-archives-4.x-2026.08.24  2026-08-24T00:00:02.733Z
wazuh-archives-4.x-2026.08.25  2026-08-25T00:00:02.400Z
```

Expected for 08.26: **2026-08-26T00:00:02.000Z–00:00:04.000Z** (midnight UTC rollover,
sub-second jitter only). If the index has not appeared by 00:05Z → escalate to cluster
health / disk watermark check before proceeding.

## 3. Detection Method (post-roll)

Primary detection — newest index by name and its creation stamp:

```
curl -s -k -u admin:[REDACTED-PW] "https://127.0.0.1:9200/_cat/indices/wazuh-archives-*?v&h=index,creation.date.string,docs.count" | sort | tail -2
```

Confirmation that the template MATCHED (two independent methods):

```
# a) simulate again post-creation; overlapping list must still include fieldlimit
curl -s -k -u admin:[REDACTED-PW] -XPOST "https://127.0.0.1:9200/_index_template/_simulate_index/wazuh-archives-4.x-2026.08.27"

# b) live settings on 08.26 itself (authoritative; this is the phase39-23 gate)
curl -s -k -u admin:[REDACTED-PW] "https://127.0.0.1:9200/wazuh-archives-4.x-2026.08.26/_settings?flat_settings=true&pretty"
```

Pre-captured reference: last night's simulate (phase39-21 §4) already returned
composed settings limit=2000 + ISM policy wazuh-archives-14d with overlapping list
[wazuh-main, wazuh(legacy), p19-retention]. Tomorrow's check confirms reality matched
simulation.

## 4. Capture Checklist

| # | Item | Command | PASS signature |
|---|---|---|---|
| C1 | Creation timestamp in window | `_cat/indices …creation.date.string` | 00:00:02.000–00:00:04.000Z |
| C2 | Matched templates recorded | simulate_index output archived verbatim | fieldlimit present in overlapping |
| C3 | total_fields.limit inherited | `_settings?flat_settings` | `index.mapping.total_fields.limit: "2000"` |
| C4 | ISM settings carried | same + `_plugins/_ism/explain/wazuh-archives-4.x-2026.08.26` | policy_id wazuh-archives-14d attached |
| C5 | Shards/allocation | `_cat/shards/wazuh-archives-4.x-2026.08.26?v` | expect 1p+1r STARTED like 08.25 (wazuh-main's 3-shard setting has NOT applied to archives historically) |
| C6 | Mappings trajectory | mapping walk (script in phase39-26) at ~H+1, H+6, EOD | count GROWS past 1000 (headroom real); watch soft 1400 |
| C7 | Docs landing | `_count` on 08.26 ≥ hourly recheck | monotonically increasing from first minutes |

C6 deserves emphasis: under the old ceiling every recent day froze at ~999–1000
(phase39-26). If 08.26's mapped-field count also plateaus below 1000 despite no
rejections, that would indicate upstream volume loss, not success — cross-check with
phase39-24/25 gates.

## 5. Ready-to-Run Verification Script

Save as `/opt/mct-security-stack/ops/jobs/fieldlimit-proof-capture.sh`; run any time
after 00:05Z Aug-26. Writes one evidence file per run.

```bash
#!/usr/bin/env bash
# phase39-22 capture script — first post-fix archives index proof
set -u
OS="curl -s -k -u admin:[REDACTED-PW]"
BASE="https://127.0.0.1:9200"
IDX="wazuh-archives-4.x-$(date -u -d 'today' +%Y.%m.%d)"
OUT="/opt/mct-security-stack/ops/evidence/fieldlimit-proof-$(date -u +%Y%m%dT%H%M%SZ).log"
mkdir -p "$(dirname "$OUT")"
exec > >(tee -a "$OUT") 2>&1
echo "=== RUN $(date -u +%FT%TZ) target=$IDX ==="
echo "--- C1 creation ---"
$OS "$BASE/_cat/indices/wazuh-archives-*?v&h=index,creation.date.string,docs.count" | sort | tail -2
echo "--- C2 template match (simulate next-day) ---"
$OS -XPOST "$BASE/_index_template/_simulate_index/wazuh-archives-4.x-$(date -u -d 'tomorrow' +%Y.%m.%d)"
echo
echo "--- C3/C4 settings flat ---"
$OS "$BASE/$IDX/_settings?flat_settings=true&pretty"
echo "--- C4 ISM explain ---"
$OS "$BASE/_plugins/_ism/explain/$IDX?pretty"
echo "--- C5 shards ---"
$OS "$BASE/_cat/shards/$IDX?v&h=index,shard,prirep,state,docs,node"
echo "--- C6 mapped-field walk ---"
$OS "$BASE/$IDX/_mapping" | python3 -c '
import json,sys,collections
d=json.load(sys.stdin); m=list(d.values())[0].get("mappings",{})
n=0
def walk(p):
    global n
    for k,v in p.items():
        n+=1
        if isinstance(v,dict):
            if "properties" in v: walk(v["properties"])
            if "fields" in v: walk(v["fields"])
walk(m.get("properties",{}))
print("TOTAL_FIELDS(engine-approx):",n)'
echo "--- C7 docs count ---"
$OS "$BASE/$IDX/_count"
echo "--- rejection counter now ---"
docker logs --since 60m multi-node-wazuh.master-1 2>&1 | grep -c "Limit of total fields"
echo "=== END ==="
```

Exit criteria feeding phase39-28: C1–C5 PASS + rejection counter trending to 0
(phase39-24) + docs growth (phase39-25).

## 6. Verdict

**PENDING.** Unblock condition: existence of `wazuh-archives-4.x-2026.08.26` with
creation timestamp inside §2 window. Owner MCT SOC; first scheduled run 2026-08-26
00:30Z, repeat 06:00Z for C6 trajectory.
