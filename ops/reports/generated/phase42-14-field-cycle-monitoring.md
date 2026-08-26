# Phase 42 Field-Cycle Monitoring Plan

**Report ID:** phase42-14-field-cycle-monitoring
**Phase:** 42
**Title:** Interim Monitoring Until Birth (Hourly Guardrail Cadence, Alert-If-Rejections>0) and Post-Birth Schedule (Adjudicator + Plateau Sampling t+1h/t+6h/t+24h)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** ACTIVE (effective immediately)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-14-field-cycle-monitoring.md`

---

## 1. Interim plan — now until 2026-08-27T00:00Z (~15.4h)

| Cadence | Command | Alert condition | Action |
|---|---|---|---|
| Hourly, manual or cron `0 * * * *` | `bash ops/scripts/p40-field-growth-check.sh wazuh-archives-4.x-2026.08.26` | none by itself (informational per report 12 §3) | log row only |
| Hourly | `docker logs multi-node-wazuh.master-1 --since 1h 2>&1 \| grep -c "Limit of total fields"` | **count > 0 → note burst window + producer sample; NO config change** | append one line to this report's §4 watch-log |
| Continuous (already armed) | watchdog cron 3,18,33,48 + delivery monitor */15 | watchdog ALERT line / monitor stall | existing P41 escalation path |

Cron suggestion (owner-optional; manual cadence is acceptable for a <16h window):

```
0 * * * * bash /opt/mct-security-stack/ops/scripts/p40-field-growth-check.sh wazuh-archives-4.x-2026.08.26 >> /opt/mct-security-stack/ops/reports/p40-field-growth.log 2>&1
```

Escalation triggers (only these): rejections observed on **worker** container (new
behavior) · dashboards/indexer health flip from GREEN · any mutation attempt against
index settings (must not happen pre-birth).

## 2. No-action-unless policy

Scenario B projection (report 11 §5) accepts further legacy-index rejection bursts as
bounded noise on a dying index. Emergency limit-raise stays owner-gated per safety rules
and is not sought: the newborn resolves headroom structurally at midnight.

## 3. Post-birth schedule (2026-08-27)

| T | Action | Destination |
|---|---|---|
| T+30min (≈00:30Z) | birth detection + settings capture (report 04 commands) | report 04/13 |
| T+adjudication (immediately after birth proof) | `bash ops/scripts/p42-field-cycle-adjudicate.sh` → fill addendum verdicts | report 13 |
| T+1h | guardrail fresh-basis baseline row on newborn + C3 recount | report 13 plateau box |
| T+6h (≈06:00Z) | adjudicator re-run (idempotent read-only) + rejection grep since birth | same |
| T+24h (2026-08-28 ≈00:30Z) | final adjudicator run + growth delta vs t+1h baseline → close-out note appended to report 13 | same |

## 4. Watch-log (append-only)

```
2026-08-26T07:02–07:45Z  REJECTION-EVENT legacy index: 2746 total (1366@07:02, 14@07:03, 1366@07:45), producers agent016 syscollector + vuln-detector; zero since 07:45:42Z (report 08)
2026-08-26T08:20Z        verification: master since-last-burst = 0; worker lifetime = 0
(next rows: hourly interim reads; then post-birth schedule above)
```
