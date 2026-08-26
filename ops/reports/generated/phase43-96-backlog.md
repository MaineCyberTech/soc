# Phase 43: Consolidated Remediation Backlog

**Report ID:** phase43-96-backlog.md
**Phase:** 43
**Title:** Phase 43 Consolidated Remediation Backlog
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:59:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-96-backlog.md`

---

## 1. Consolidated Backlog (BCK-43-001..015)

| ID | Priority | Title | Owner | Dependencies | Acceptance | Rollback | Source | P44 Effect |
|------|----------|-------|-------|--------------|------------|----------|--------|------------|
| BCK-43-001 | P0 | Agent 013 Recovery | Owner | Physical access | Device online + sustained KA | N/A | phase43-23 | P44-01 |
| BCK-43-002 | P0 | Agent 015 Flap Fix | Owner | Device access | 24h clean keepalive | Revert power settings | phase43-26 | P44-02 |
| BCK-43-003 | P0 | RTO/RPO Signoff | Owner | DEC-40-01 ready | Signed sheet | N/A | phase43-29 | P44-03 |
| BCK-43-004 | P0 | Restore Target Approval | Owner | Candidate matrix | Signed memo | N/A | phase43-30 | P44-04 |
| BCK-43-005 | P0 | Disk Threshold Policy | Owner | Threshold config | Signed decision | Toggle threshold | phase43-39/40 | P44-05 |
| BCK-43-006 | P0 | v1.3.1 GitHub Release | Owner | GH Token | Release page live | Delete release | phase43-79 | P44-06 |
| BCK-43-007 | P1 | Packet Lane Remediation | Engineering | Owner decision (A/B/C) | Certified workflow | Revert workflow | phase43-41 | P44-07 |
| BCK-43-008 | P1 | Dashboard v2 Swap | Owner | Owner signoff | v2 live; v1 archived | Re-import v1 | phase43-63 | P44-08 |
| BCK-43-009 | P1 | Disk Threshold Config | Owner/Eng | Owner decision | Thresholds enabled or accepted | Toggle config | phase43-37/38 | P44-09 |
| BCK-43-010 | P1 | ISM Wave Observation | Automation | Aug-29 | Relief measured | N/A | phase43-71 | P44-10 |
| BCK-43-011 | P2 | Dashboard v2 Browser Test | Operator | Owner signoff | Visual parity confirmed | Revert import | phase43-68 | P44-11 |
| BCK-43-012 | P2 | Host VT Key chmod | Owner (sudo) | Access | `chmod 640` verified | chmod 644 | phase43-31 | P44-12 |
| BCK-43-013 | P2 | v1.3.1 GitHub Release | Owner | GH Token | Release page live | Delete release | phase43-79 | P44-13 |
| BCK-43-014 | P2 | XFO/XTCO Dedup | Engineering | None | Single headers verified | Revert proxy config | phase43-49/50 | P44-14 |
| BCK-43-015 | P3 | R-CHURN Cron Audit | Engineering | Cron access | `crontab -l` shows 0 restarts | Revert script | phase43-43/48 | P44-15 |

---

## 2. Quick-Wins (⚡)

| Item | Effort | Impact |
|------|--------|--------|
| XFO dedup | 5 min | Header hygiene |
| R-CHURN cron gate | Done | Eliminated 92 restarts/day |
| VT key host chmod | 1 min (sudo) | Config hygiene |
| X-Content-Type-Options dedup | Done | Header hygiene |

---

## 3. Status

**COMPLETE** — Backlog consolidated; 15 items prioritized; quick-wins flagged.