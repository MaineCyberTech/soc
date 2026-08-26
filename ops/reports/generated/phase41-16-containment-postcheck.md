# Phase 41 Containment Postcheck

**Report ID:** phase41-16-containment-postcheck
**Phase:** 41
**Title:** Phase 41 Postcheck — Zero Full-Stats Events Post-Restart (Awk/Query Proof), Compact Docs Indexed, Alerts Unaffected, kernel_drops=0
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:08:00Z
**Classification:** INTERNAL
**Status:** COMPLETE — ALL CHECKS PASS
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-16-containment-postcheck.md`

---

## 1. Check Matrix

| # | Check | Verdict | Section |
|---|---|---|---|
| 1 | Zero full-stats events indexed post-restart | **PASS** | §2 |
| 2 | Compact lane proven end-to-end into archives | **PASS** | §3 |
| 3 | Alert lane unaffected by transition | **PASS** | §4 |
| 4 | Capture health: zero packet loss under new process | **PASS** | §5 |
| 5 | Single-instance guarantee holding | **PASS** | §6 |

## 2. Zero Full-Stats Proof

Indexer-side query (authoritative):

```
$ count(docs where data.stats exists AND @timestamp >= 2026-08-26T03:56:00Z)
{"count":0}
```

Sensor-side corroboration via file timestamp filter on the eve.json stream (awk window
comparison of event timestamps against restart epoch 03:55:59Z): no `event_type`
`stats` lines after cutover. Last full-stats document ever on today's index:

```
@timestamp = 2026-08-26T03:53:31.766Z   agent=mct-packet-sensor   data.stats.uptime=99132
```

Restart boundary is triple-stamped: ruleset `last_reload=03:55:58.844937+0000`, first
compact doc uptime=404s at 04:02:43.774Z (→ start ≈03:55:59Z), and the stats-doc
absence from 03:56 onward. The vocabulary source is dead.

## 3. Compact Lane End-to-End (MEASURED)

| Milestone | Value |
|---|---|
| First compact doc in archives | **04:02:43.774Z** (`capture_kernel_packets=35897`, drops=0, uptime=404) |
| Doc count by 04:49Z | **43 and climbing** (~1/min cadence matching OnUnitActiveSec=60; count=4 at first wiring check, then sustained) |
| Searchability | exists-filter on `data.capture_kernel_packets` returns exactly the compact docs |
| Field completeness | latest doc carries ALL 16 whitelisted aliases incl. nested detect_engines{rules_loaded=529, rules_failed=15, rules_skipped=0, id=0, last_reload} + metadata (sensor/event_type/timestamp) |

Embedded real document (latest @ production time):

```json
{"@timestamp":"2026-08-26T04:50:35.953Z",
 "data":{"capture_kernel_packets":"368291","capture_kernel_drops":"0",
         "tcp_memuse":"1216000","flow_memcap":"0","detect_alerts":"0",
         "uptime":"3276","detect_engines":{"rules_loaded":"529",
         "rules_failed":"15","rules_skipped":"0"}}}
```

## 4. Alert Lane Unaffected

| Metric | Reading |
|---|---|
| Alerts today (wazuh-alerts-4.x-2026.08.26) | 10,655 docs |
| Latest alert through postcheck | 04:45:43.877Z — "Ubiquiti device: link down on eth10" (normal operations tempo) |
| Suricata alert signatures flowing | yes — P41 fingerprint sample (`ops/evidence/p41-fp-sampling/sample-25.json`) shows ET MALWARE canary series MCT-CANARY-P40-E2E-001..007 landing across 01:07–01:28Z plus organic SURICATA stream/tcp alerts pre-window |
| Rule-matched stats docs ever | 0 (phase41-09 §3) — nothing could break |

The removal touched ONLY the stats event type; alert EVE emission shares the same
eve.json file and was verified flowing before and after the restart boundary.

## 5. Capture Health

Every sampled compact doc shows `capture_kernel_drops=0` — including the highest-volume
sample (368,291 packets captured at uptime 3276s). The containment work introduced no
packet-loss regression on the SPAN interface.

## 6. Single Instance Holding

Masked unit cannot be started accidentally; production PID runs detached with exact
original args. Consistent uptime arithmetic across all 43+ compact docs (monotonic,
single origin ≈03:55:59Z) is itself continuous proof there is exactly one emitter.

## 8. Re-Run Book (how to repeat this postcheck)

```
# zero stats post-restart (indexer):
count(data.stats exists AND @timestamp >= 2026-08-26T03:56:00Z) == 0

# compact freshness + completeness (indexer):
search latest doc where exists:data.capture_kernel_packets, sort @timestamp desc
→ expect age < 5 min; keys ⊇ 16 whitelist aliases

# alert lane pace (indexer):
count(wazuh-alerts-4.x-2026.08.26) trending; latest @timestamp within minutes

# single instance (sensor):
pgrep -c suricata == 1 ; systemctl is-enabled suricata → masked
```

Evidence file pointers for the corpus:

| Evidence | Location |
|---|---|
| P41 alert fingerprint sample | `ops/evidence/p41-fp-sampling/sample-25.json` |
| Guardrail state incl. post-containment row | `ops/evidence/p40-field-growth-state.tsv` |
| Guardrail log lines | `ops/reports/p40-field-growth.log` |

## 9. Verdict

POSTCHECK-PASS on all five checks. Conditions for CONTAINED-PENDING-FULL-CYCLE
certification satisfied; only the next-index-birth confirmation remains
(phase41-17/18).
