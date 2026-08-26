# Phase 42 Dashboard EID Discrepancy Investigation

**Report ID:** phase42-69-dashboard-eid-discrepancy
**Phase:** 42
**Title:** EID-42 — ROOT-CAUSED: `event.code` Is Never Populated In This Stack (0 Hits Across Archives AND Alerts); Real Signal = `data.win.system.eventID` (1.96M Docs) With Detection Tags `sysmon_eidN_detections` In `rule.groups` On A 0.17% Subset; Zero Of 8 Artifacts Reference event.code; REAL Defect Found & FIXED — Original W2 Table Aggregates A Text Field (fielddata Error) → v2 Objects Imported With `.keyword` Fix, Live Parity Proven, Swap Plan Staged, Originals Retained
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (investigation + safe-path remediation applied)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-69-dashboard-eid-discrepancy.md`

---

## 1. The P41 flag, restated precisely

phase41-62 recorded: `event.code` 0-hits while "sysmon EIDs live in rule.groups"
(sysmon_eid1_detections 576 etc., alerts pattern, last-24h), and flagged the W2 EID
table IF it binds `event.code`. This phase ran the full investigation.

## 2. Field census — real queries, this session (09:0xZ)

| Query | Result |
|---|---|
| `wazuh-archives-*` count where `event.code` exists | **0** (20/20 shards) |
| `wazuh-alerts-*` count where `event.code` exists | **0** (60/60 shards) |
| `wazuh-archives-*` count where `data.win.system.eventID` exists | **1,955,152** |
| `wazuh-archives-*` docs with `rule.groups: sysmon_eid*` | **3,400** total |
| same, last-24h | **0 buckets** (subset died with agent-013 offline) |
| rule.groups breakdown (all-time): | `sysmon_eid7_detections` 1004 · `sysmon_eid1_detections` 436 · `sysmon_eid10_detections` 12 |

## 3. Where the EID actually lands — real doc inspected

```json
GET wazuh-archives-*/_search (rule.groups wildcard sysmon_eid*, newest first) →
_source: { "agent":{"name":"MCT-WIN11PILOT"},
           "data":{"win":{"system":{"eventID":"7","computer":"MCT-WIN11PILOT"}}},
           "rule":{"groups":["sysmon","sysmon_eid7_detections","windows"],"id":"92154"},
           … }
```
A second sample (eventID present, NO sysmon group): decoder
`windows_eventchannel`, `eventID:"7"`, no `event.code` key anywhere.

**Root cause (confirmed):** the Wazuh windows_eventchannel decoding path writes the
Windows EventID to `data.win.system.eventID`; ECS `event.code` is never mapped by
this stack. The `sysmon_eidN_detections` tokens in `rule.groups` are NOT a universal
EID encoding — they are Wazuh detection-rule group tags (e.g., rule 92154) present
on only ~0.17% of archived sysmon events. Mapping note: `eventID`,
`agent.name/id`, `rule.groups` carry keyword variants only on indices ≤08.18;
from **08.19 onward they map text-only with a populated `.keyword` sub-field**
(verified via `_field_caps` + empirical aggs both directions).

## 4. Impact on the 8 imported objects

`grep 'event\.code' w1-w2-windows-endpoints.ndjson` → **0 references**.
The P41 conditional resolves: no panel keys on `event.code`.

BUT the inspection surfaced the REAL renderability defect: original
`p39-w2-eid-top-table` aggregates the RAW field:

```
aggs on data.win.system.eventID (08.26) → illegal_argument_exception:
"Text fields are not optimised for operations that require per-document field data…"
```
i.e. the browser panel errors over any recent window (≤08.18 windows would behave
differently only because those indices carried different mappings).

## 5. Remediation decision and SAFE-PATH APPLY (executed)

Options considered: (a) repoint panel queries to aggregatable convention;
(b) filebeat/ECS mapping change so `event.code` gets populated (heavier,
pipeline-wide). **Chosen: (a)** as a minimal artifact edit.

Safe path executed exactly as staged — edit copy → new ids `-v2` → reimport → verify:

- Artifact: `ops/evidence/p42-dashboard-v2/w1-w2-windows-endpoints-v2.ndjson`
  (sha256 `771be36e44f1…2057d9`); W2 set only, W1 untouched; eid table agg field
  `data.win.system.eventID` → **`data.win.system.eventID.keyword`**; titles suffixed
  `[v2]`; originals NOT deleted or modified.
- Import: `POST /api/saved_objects/_import?createNewCopies=false` →
  **successCount 4 / success true** at 09:20:20Z (dashboard + 3 visualizations).
- Read-back: all four v2 ids present, updated_at 09:20:20.920Z.

## 6. Verification — live parity of the fixed panel query (last-24h)

```
v2-equivalent agg (terms eventID.keyword ×20, sub-terms agent.id.keyword ×5):
  EID 7 → 44,095 · EID 5 → 981 · EID 1 → 842 · EID 4798 → 158 · …
control count(eventID exists, same window): 46,226
top-6 bucket sum 46,154 (+ tail buckets/sum_other ≈ 72 gap ⇒ coherent)
```
Distribution matches the single-day control read (7=38,356 / 5=828 / 1=737 on 08.26).

## 7. Swap plan (owner action; nothing deleted)

1. Browser session (phase42-68 kit steps 3–5): confirm S5 renders clean vs S4 error.
2. Owner approves swap; operator re-points ORIGINAL W2 dashboard's panelsJSON to the
   `-v2` visualization ids (or retires original dashboard after cloning refs).
   One-line edit + reimport-overwrite; reversible.
3. Post-swap, mark originals deprecated in description (never delete history).

Residual: option (b) remains available if client reporting ever needs native ECS
`event.code`; owner-deferred.
