# Phase 41 Name Diff — Fields Present vs Prior-Day Families

**Report ID:** phase41-05-name-diff
**Phase:** 41
**Title:** Phase 41 Mapping Name-Diff — wazuh-archives 08.25 vs 08.26 Leaf Sets, New-Family Ledger and Method Note
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:57:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-05-name-diff.md`

---

## 1. Method

Set difference of unique leaf paths (multi-field-collapsed) between yesterday's and
today's archives mappings, fetched live from the indexer:

```python
new = leaves_2026_08_26 - leaves_2026_08_25      # appeared only today
gone = leaves_2026_08_25 - leaves_2026_08_26     # present only yesterday
```

Method note: this diff uses the **unique basis** (each multi-field family counted
once). On the raw basis both sides inflate roughly equally, so the DELTA story is
basis-stable, but absolute counts differ from the guardrail series — see phase41-06 §3
for the reconciliation table.

## 2. Headline Numbers (MEASURED)

| Set | Unique leaves |
|---|---|
| wazuh-archives-4.x-2026.08.25 | 473 |
| wazuh-archives-4.x-2026.08.26 | 892 |
| NEW today | **+423** |
| gone (yesterday-only) | −4 |

Yesterday's index died young: it exhausted its default [1000] field budget-era
behavior mid-life (rejection storm 23:52–23:59) and never saw the full day's classes.
Today's index met the complete vocabulary — hence nearly double.

## 3. New-Field Ledger by Family (top)

| Family | New unique leaves | Producer (see phase41-07) |
|---|---|---|
| data.stats.* | +187 | Suricata EVE full-stats (agent 016) — rest of the 441 pre-existed yesterday |
| data.win.* | +41 | Windows endpoints 012/014 (eventchannel) |
| data.parameters.* | +35 | mct-portal-dev (007) web params |
| data.audit.* | +30 | auditd lane (007/006) |
| data.service.* | +30 | Windows service events (012) |
| data.osquery.* | +28 | osquery lane (docker-host/portal-dev) |
| data.netinfo.* | +9 | osquery/system inventory |
| data.alert.* | +7 | nested suricata alert metadata |
| data.ubiquiti.* | +5 | AP syslogs via manager |
| data.detect_engines.* | +5 | **compact-stats lane (post-containment)** |
| GeoLocation.location.* | +2 | geo enrichment |
| data.origin.*, data.docker.*, data.command.* | +5 misc | scattered |
| compact flat aliases (capture_kernel_packets/drops/errors, decoder_pkts/bytes/invalid, flow_memcap/spared/emergency_mode, tcp/http/ftp_memuse, detect_alerts, detect_alert_queue_overflow, uptime) | +15 | **compact-stats lane (post-containment)** |
| data.sensor, data.event_type | +2 | compact-lane metadata |

## 4. Observations

1. **187 of today's 441 stat leaves were genuinely new today**; 254 already existed on
   yesterday's index. The stats family maps progressively as counters first fire, but
   front-loads heavily at index birth because Suricata emits the whole enabled set per
   stats interval (phase41-06 §4).
2. **The +4 gone-set** consists of transient decoder paths from yesterday's unusual
   traffic that haven't recurred — normal churn, no action.
3. **Post-containment additions are visible inside the same diff** (compact lane,
   ~22 unique leaves incl. metadata): the replacement lane's footprint is measurable
   and bounded — the entire design goal (phase41-12 §3).
4. Windows (+41 today, and still trickling +8 during arc morning) is now the second-
   largest mapper and the top REMAINING growth family — assessed separately in
   phase41-11 (not contained this phase; trigger set at >150).

## 6. The Gone-Set (yesterday-only leaves, enumerated class-wise)

Four paths present yesterday are absent today — all transient decoder residue:

| Class | Character |
|---|---|
| decoder-edge fields | one-day protocol anomalies that never recurred |
| geo/location edge variants | enrichment differences on unique source IPs |

Normal dynamic-mapping churn; no action indicated. The gone-set's existence is itself
evidence that mapping is per-index and traffic-driven — reinforcing that tomorrow's
birth, not today's stock, is where containment is proven.

## 7. Diff Reproduction Command Shape

```bash
# fetch both mappings live, then set-diff leaf sets:
curl -sk -u "admin:[REDACTED]" ".../wazuh-archives-4.x-2026.08.25/_mapping" > map25.json
curl -sk -u "admin:[REDACTED]" ".../wazuh-archives-4.x-2026.08.26/_mapping" > map26.json
python3 - <<'EOF'
# walk properties; collect unique leaf paths (collapse multi-fields);
# print new = today - yesterday, gone = yesterday - today, grouped by family
EOF
```

Full transcript retained in arc session log; numbers quoted in §2–3 re-runnable any
time before index deletion.

## 8. Forward Use

This diff method becomes the standard post-birth check for every future containment
flip: run it on D+1 vs D to enumerate exactly what the removed producer used to add,
and what the replacement lane really costs. Scheduled next execution: 2026-08-27 after
first guardrail run (phase41-18 flip condition).

## 9. Reconciliation With Guardrail Series

Guardrail raw counts (1604→1706→1766) exceed these unique counts because raw counting
adds one leaf per multi-field variant (e.g., win raw=168 vs unique=85). Both views are
kept: the guardrail owns threshold enforcement continuity with P40; unique basis owns
attribution truth. No report in this corpus mixes bases inside a single table without
labeling (the one historical near-miss is called out in phase41-17 §4).
