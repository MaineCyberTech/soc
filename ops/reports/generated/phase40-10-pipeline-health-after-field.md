# Phase 40 Pipeline Health After Field Fix

**Report ID:** phase40-10-pipeline-health-after-field
**Phase:** 40
**Title:** Phase 40 Pipeline Health Post-Cutover — Clean Logs, GREEN Cluster, Steady Resources, Alert Lane Unaffected
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Claims:** VERIFIED (MEASURED)
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-10-pipeline-health-after-field.md`

---

## 1. Indexer/Analysisd Logs (MEASURED)

```
# mapping-related exceptions across all three indexers, LAST 30 MINUTES:
multi-node-wazuh1.indexer-1 → 0      multi-node-wazuh2.indexer-1 → 0
multi-node-wazuh3.indexer-1 → 0

# context: a 120-minute window still catches the PRE-cutover storm echoed indexer-side:
wazuh2.indexer (since 120m) = 7980, but first lines stamp 2026-08-25T23:46:57Z against
[wazuh-archives-4.x-2026.08.25] "mapping update rejected by primary … Limit of total
fields [1000]" — all pre-midnight; nothing after.

# manager ossec.log: error-class lines = only the benign remoted agent.conf.bak
# permission pair; non-remoted errors = 0. analysisd clean.
```

## 2. Cluster Health and Shards (MEASURED)

```
GET _cluster/health → green, 3 nodes, active_primary_shards 149, active_shards 282,
relocating 0, initializing 0, unassigned_shards 0, pending_tasks 0,
active_shards_percent 100.0%
```

New index fully allocated (phase40-04 §3); no recovery or red/Yellow shards anywhere.

## 3. Host Resources (MEASURED ~01:39Z)

```
$ free -m   → Mem 15553 total / 11689 used / 3863 available; Swap 4875 used (pre-existing)
$ uptime    → load average: 1.46, 1.75, 1.85 (up 3d 20h)
PSI: cpu some avg10=3.03 avg60=4.41 full=0 ; memory ≈0 ; io some avg60=0.02
```

CPU pressure modest and steady; no memory or IO stall signatures. Ingest-driven write
throughput projection from measured pace (≈950–1000 docs/min sustained): **≈1.35–1.4M
docs/day** for 08.26 if the day holds this shape — versus rejection-suppressed prior
days (08.24: 248k accepted; 08.25: 883k) and pre-saturation healthy days (2.1–2.6M).
Projection is a rate extrapolation, not a promise; EOD recount will settle it.

## 4. Alert Pipeline Unaffected (MEASURED)

```
$ _cat/indices/wazuh-alerts-4.x-* → wazuh-alerts-4.x-2026.08.26 docs.count=4137 @01:38Z
(prior full days run ~49.6k–55k; 08.26 is on a normal arc for H+2)
```

Alerts index continues under its long-standing policy (`wazuh-retention`) — unchanged
by the archives fix. Delivery lane to IRIS untouched this arc (last proven P39).

## 5. Verdict

**COMPLETE — PASS.** No adverse pipeline effects from the field fix; log channels,
cluster state, resources, and the alert lane are all nominal post-cutover.
