# Phase 41 Usability Audit

**Report ID:** phase41-90-usability-audit
**Phase:** 41
**Title:** AUDIT-USE-41 — Current-State Freshness Restored (Postp41 Snapshot Today), Dashboards Data-Validated But Visual-Render Login-Gated, Monitor/Watchdog Observability Paths Documented With Live Tails, Ownership Explicit Per Row, Mobile & Accessibility Unknowns Declared, False-Health Watchlist Armed, Operator Quick-Ref Card Extended (Compact-Timer Check · Watchdog Log Path · Custody Hash One-Liner)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-90-usability-audit.md`

---

## 1. Current-state freshness

`canonical/current/current-state-20260826-postp41.md` written this cycle (phase41-81)
with same-session evidence; AGENTS.md pointer updated under CHG-41-AGENTS-01. The prior
CS-40 snapshot is retained unmodified as history. An operator opening the canon today
reads post-P41 truth — no stale-first-click.

## 2. Dashboards

- **Data layer: VALIDATED** against live queries this arc (agents widget, alert-group
  mixes, compact-stats zero-dependency check G41-10).
- **Visual render: LOGIN-GATED** — browser session credentials are operator-held;
  pixels/layout remain UNVERIFIED until an operator-driven pass (OW-41-03).
- Two honest discrepancies flagged rather than smoothed over: agent-count widget 6 vs
  `agent_control` 7; `event.code`=0 vs `sysmon_eid1`=576 mapping question inside the FP
  dataset (both zero in today's live indices) → OW-41-02 owner query.

## 3. Monitor & watchdog observability (paths + live tails)

```
Monitor log:   /opt/mct-security-stack/ops/reports/shuffle-delivery-monitor.log   */15
Watchdog log:  /opt/mct-security-stack/ops/reports/p41-monitor-watchdog.log       cron 3,18,33,48
$ tail -3 shuffle-delivery-monitor.log → per-run summaries + ALERT-39-01 SUMMARY line
$ ls -l p41-monitor-watchdog.log      → present, 0 bytes (= no stall alerts fired since install)
```

## 4. Ownership clarity

Every open row in OPENWORK-41-01 carries a named owner (Endpoint ops, SOAR ops,
Infrastructure, Governance, Release, Detection, ops-reports-owner) plus deps and a
rollback note; no orphan work items. Gated items name their gate explicitly.

## 5. Mobile / accessibility unknowns (explicit)

UNVERIFIED by design this phase: mobile viewport rendering of W1/W2 and Shuffle UI,
screen-reader semantics, contrast ratios beyond defaults, and touch-target sizes were
NOT tested (browser-gated). Prior client-safe accessibility review (phase41-64) covers
only artifact-level structure. Declared unknown; not claimed either way.

## 6. False-health watchlist

| Watch | Why it can look healthy while broken |
|---|---|
| Watchdog log EMPTY | Means "no stalls detected" only if the watchdog itself fires; verify cron log heartbeat periodically |
| Emitter fail-silent (`except: exit 0`) | Compact docs stop landing without any error surface — watch daily stats_compact count ≥ ~1400/day at full cadence |
| executions API FINISHED rows with null finished_at | Status green while latency SLO unverifiable (D-41-LAT) |
| Frontend restarts every 15 min | Looks like "fresh UI" but is churn masking DNS-state truth (OW-41-05) |
| Sensor suricata unit `failed` state | Stale record under mask — do NOT read as outage; verify via pgrep |

## 7. Operator quick-ref card (updated — extends phase38-64 table)

```
# Compact-stats pipeline health (sensor):
ssh -o BatchMode=yes mct-soc-scan 'systemctl is-active suricata-compact-stats.timer && \
  systemctl list-timers suricata-compact-stats.timer --no-pager | head -3'
# …and indexed-doc freshness:
curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" \
  'https://127.0.0.1:9200/wazuh-archives-4.x-$(date -u +%Y.%m.%d)/_count?q=data.event_type:stats_compact'

# Delivery watchdog path:
tail /opt/mct-security-stack/ops/reports/p41-monitor-watchdog.log   # entries = stall alerts
grep -c 'ALERT-39-01 SUMMARY' ops/reports/shuffle-delivery-monitor.log  # monitor heartbeat count

# Release custody hash verify one-liner:
sha256sum ops/releases/v1.3.0/v1.3.0-published-original.tar.gz   # expect da72bde45db379c5…
```
