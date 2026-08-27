# Phase 44: Consolidated Remediation Backlog

**Report ID:** phase44-97-backlog
**Phase:** 44
**Title:** Phase 44 Consolidated Remediation Backlog
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:59:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-97-backlog.md`

---

## 1. Consolidated Backlog (BCK-44-001..NNN)

| ID | Priority | Title | Owner | Dependencies | Acceptance Criteria | Rollback | Evidence Links | P45 Effect |
|----|----------|-------|-------|--------------|------------|----------|--------|------------|
| BCK-44-001 | P0 | Agent 013 Recovery | Owner | Physical access | Device online + sustained KA | N/A | phase44-25 | P45-01 |
| BCK-44-002 | P0 | Agent 015 Flap Fix | Owner | Device access | 24h clean keepalive | Revert power settings | phase44-26 | P45-02 |
| BCK-44-003 | P0 | RTO/RPO Signoff | Owner | DEC-40-01 ready | Signed sheet | N/A | phase44-29 | P45-03 |
| BCK-44-004 | P0 | Restore Target Approval | Owner | Candidate matrix | Signed memo | N/A | phase44-30 | P45-04 |
| BCK-44-005 | P0 | Disk Threshold Policy | Owner | Threshold config | Signed decision | Toggle config | phase44-32 | P45-05 |
| BCK-44-006 | P0 | v1.3.1 GitHub Release | Owner | GH token | Release page live | Delete release | phase44-30 | P45-06 |
| BCK-44-007 | P1 | Packet Workflow Remediation | Engineering | Owner decision (A/B/C) | Certified workflow | Revert workflow | phase44-41 | P45-07 |
| BCK-44-008 | P1 | Dashboard v2 Swap | Owner | Owner signoff | v2 live; v1 archived | Re-import v1 | phase44-31 | P45-08 |
| BCK-44-009 | P1 | Agent 015 Flap Fix | Owner | Device access | 24h clean keepalive | Revert power settings | phase44-26 | P45-09 |
| BCK-44-010 | P1 | ISM Wave Observation | Automation | Aug-29 | Relief measured | N/A | phase44-71 | P45-10 |
| BCK-44-011 | P1 | Disk Threshold Config | Owner/Eng | Owner decision | Thresholds enabled or accepted | Toggle config | phase44-37/38 | P45-11 |
| BCK-44-012 | P2 | Dashboard v2 Browser Test | Operator | Owner signoff | Visual parity confirmed | Re-import v1 | phase44-68 | P45-12 |
| BCK-44-013 | P2 | Agent 013 Recovery | Owner | Physical access | Device online + sustained KA | N/A | phase44-25 | P45-13 |
| BCK-44-012 | P2 | Dashboard v2 Browser Test | Operator | Owner signoff | Visual parity confirmed | Re-import v1 | phase44-68 | P45-14 |
| BCK-44-013 | P2 | R-CHURN Cron Audit | Engineering | Cron access | `crontab -l` shows 0 restarts | Revert script | phase44-43 | P45-15 |
| BCK-44-013 | P2 | Securityonion Stop Decision | Engineering | Dependency sweep | `docker stop` documented | `docker start` | phase44-81 | P45-16 |
| BCK-44-014 | P2 | VT Key Rotation | Owner | Key expiry | New key + updated configs | Regenerate old | phase44-33 | P45-17 |
| BCK-44-014 | P2 | Dashboard v2 Browser Test | Operator | Owner signoff | Visual parity confirmed | Re-import v1 | phase44-68 | P45-18 |
| BCK-44-015 | P2 | EID Mapping Answer | Owner | Owner query | Decision documented | N/A | phase44-69 | P45-19 |
| BCK-44-016 | P2 | FP Sampling Continuation | Analyst | Population trigger | Sample extracted | N/A | phase44-75 | P45-20 |
| BCK-44-017 | P3 | XFO Dedup Cleanup | Engineering | 5 min | Header hygiene | Revert proxy config | phase44-49/50 | P45-21 |
| BCK-44-018 | P3 | Windows .bak Sweep | Engineering | 5 min | Config hygiene | Revert chown | phase44-67/68 | P45-22 |
| BCK-44-019 | P3 | Published Asset Retrieval | Owner | gh/network | gh CLI works | N/A | phase44-30 | P45-23 |

---

## 2. Quick-Wins (⚡)

| Item | Effort | Impact |
|------|--------|--------|
| XFO dedup | 5 min | Header hygiene |
| Agent.conf.bak chown | 1 min | Config hygiene |
| v1.3.1 GH release | 1 session (when token) | Release closure |
| R-CHURN cron audit | 10 min | Cron hygiene |
| X-Content-Type-Options dedup | Done | Header hygiene |

---

## 3. Status

**COMPLETE** — Backlog consolidated; 19 items prioritized; quick-wins flagged; owner-batch items grouped for single session.