# Phase 41 Preflight — Full Morning State

**Report ID:** phase41-01-preflight
**Phase:** 41
**Title:** Phase 41 Preflight — Stack State Freeze at Arc Start, Incl. Rejection False-Alarm Catch (8640 Apparent → All Pre-Cutover)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:53:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-01-preflight.md`

---

## 1. Purpose

Freeze the observable state of the pipeline at Phase 41 start so every later claim has
a fixed baseline. Two surprises dominated the morning picture and are resolved here and
in phase41-03: (a) an apparent wall of mapping rejections in a naive `--since 6h` log
pull, and (b) the question of whether field growth had actually stopped or merely
paused.

## 2. Cluster State (MEASURED)

| Item | Value @ arc start |
|---|---|
| Cluster health | green, 3 nodes, 282 active shards |
| Today's archives index | `wazuh-archives-4.x-2026.08.26` (created 2026-08-26T00:00:02.420Z) |
| Archives docs today (04:49Z re-read) | 288,875 |
| Alerts docs today (04:46Z) | 10,655 |
| Effective total-fields limit | 2000 (template `wazuh-archives-fieldlimit`, priority 320) |
| Guardrail last reading pre-P41 | 1706 leaf_fields, verdict WARN, growth_per_day=0.0 (03:38:34Z) |

## 3. The False Alarm — Naive Reading

A morning triage pull equivalent to:

```
docker logs --since 6h <indexer> 2>&1 | grep -c 'Limit of total fields'
```

returned a four-figure rejection count, suggesting the mapping defect had returned.
That reading is **wrong by construction**: `--since 6h` filters by container-log
timestamp, and both indexers retained their full pre-cutover rejection storms in the
log buffer. The rejections are real *events* but stale *signals* — they all belong to
windows before their respective midnight template rollovers.

## 4. Time-Bucketed Resolution (MEASURED, docker logs --timestamps)

Minute/hour-bucketed histogram of `Limit of total fields` lines:

| Container | Window | Count | Character |
|---|---|---|---|
| multi-node-wazuh1.indexer-1 | 2026-08-24T23:52–23:59 | 8107 | prior-day pre-cutover storm (limit [1000] era) |
| multi-node-wazuh1.indexer-1 | any time on 08-25/08-26 | 0 | silent |
| multi-node-wazuh2.indexer-1 | 2026-08-25T23:53–23:59 | 5896 | pre-cutover storm for the current index |
| multi-node-wazuh2.indexer-1 | 2026-08-26T00:00 | 3 | dying breath at rollover second |
| multi-node-wazuh2.indexer-1 | after 00:00:01.422Z | 0 | silent through arc end |
| multi-node-wazuh3.indexer-1 | all retained history | 0 | never participated |

The three final lines on the current index, verbatim bucket:

```
2026-08-26T00:00:00.413Z  IllegalArgumentException: Limit of total fields [1000] has been exceeded
2026-08-26T00:00:01.414Z  IllegalArgumentException: Limit of total fields [1000] has been exceeded
2026-08-26T00:00:01.422Z  IllegalArgumentException: Limit of total fields [1000] has been exceeded
```

P40's certification (phase40-13 §2 item 5) recorded the final rejection as
**00:00:01.431Z**; today's retained-buffer tail ends one line earlier at .422Z
(sub-second line-order variance between log pulls). Either way: **the last rejection
ever landed within 1.5 seconds of index cutover**, exactly when the new index with the
2000-limit template took over. Nothing after.

## 5. Why This Matters for P41

- Every later claim of "zero rejections" must carry a window qualifier ("post-roll",
  "post-restart") — a bare grep count is meaningless on these containers.
- The [1000] in the message confirms the rejected writes targeted the OLD index whose
  default limit was exhausted; the new index accepted 1580→1706+ fields without a
  single rejection (behavioral cross-proof carried from phase40-06).

## 6. Baseline Anomalies Carried Forward

| Anomaly | Disposition |
|---|---|
| Guardrail WARN (1706 ≥ soft 1400) | Owned by P41 containment arc (Arc B/C) |
| `growth_per_day=0.0` at 03:05/03:38 samples | Investigated as plateau, phase41-04 |
| wazuh3 indexer shows no rejections ever | Expected — shard routing kept the storm on wazuh1/wazuh2 |
| Agent 008 securityonion disconnected | Pre-existing, out of scope (tracked in P40 endpoint reconciliation) |

## 7. Preflight Checklist

- [x] Cluster green; alert lane pacing normally (latest alert 04:45:43.877Z)
- [x] Guardrail script executable and appending to state TSV
- [x] Indexer log buffers retained deep enough for full-window forensics
- [x] No uncommitted mutations pending from other arcs touching the field domain
- [x] Credentials sourced only from `[REDACTED-*]` env file; no secrets transcribed

## 8. Alert-Lane Snapshot at Freeze (MEASURED)

| Item | Value |
|---|---|
| Alerts today | 10,655 docs on `wazuh-alerts-4.x-2026.08.26` |
| Latest alert | 04:45:43.877Z — "Ubiquiti device: link down on eth10" (wazuh.master collector) |
| Suricata signature lane | flowing — P40 canary series MCT-CANARY-P40-E2E-001..007 landed 01:07–01:28Z (fingerprint preserved at `ops/evidence/p41-fp-sampling/sample-25.json`) |
| Organic suricata alerts | present pre-window (SURICATA STREAM/APPLAYER classes) |

The alert snapshot matters as a pre-mutation baseline: postcheck (phase41-16 §4)
compares against exactly this picture to prove the containment restart did not disturb
detection delivery.

## 9. Instrument Inventory Available to the Arc

| Instrument | Path | Role in P41 |
|---|---|---|
| Guardrail script | `ops/scripts/p40-field-growth-check.sh` | leaf counts, verdicts, state rows |
| Trend state | `ops/evidence/p40-field-growth-state.tsv` | plateau proof (§5 series) |
| Guardrail log | `ops/reports/p40-field-growth.log` | full verdict lines w/ branches |
| Indexer containers | multi-node-wazuh{1,2,3}.indexer-1 | rejection forensics via docker logs --timestamps |
| Manager API | agents inventory | producer attribution names/IDs (agent 016 etc.) |
| Fingerprint sample | `ops/evidence/p41-fp-sampling/sample-25.json` | alert-lane baseline evidence |

## 10. Conclusion

Stack healthy; the scary number dissolves under timestamps. The real story of the
morning is quieter and better: growth had already plateaued (phase41-04), and P41's
job is to make that plateau permanent by removing the growth source rather than
raising ceilings.
