# Phase 43 Closeout: Closeout Change Register

**Report ID:** phase43-closeout-03-change-register
**Phase:** 43 Closeout
**Title:** Phase 43 Closeout — Closeout Change Register
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T20:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-closeout-03-closeout-change-register.md`

---

## 1. Change Register

| Gate ID | Domain | Action | Approval Required | Rollback Plan | Status |
|---------|--------|--------|-------------------|---------------|--------|
| GC-43-01 | Field Adjudication | Run adjudicator on 08.27 index; publish addendum | Automation (script) | N/A (read-only) | **STAGED** |
| GC-43-02 | Monitor Full-Day Cert | Verify 24h window at 01:45Z Aug-27 | Automation | N/A | **RUNNING** |
| GC-43-03 | Monitor Logrotate | Install/verify logrotate for monitor log | Operator | Revert config | **PLANNED** |
| GC-43-04 | Watchdog Hardening | Verify watchdog alert path; test stale→ALERT | Operator | Revert script | **VERIFIED** |
| GC-43-07 | Owner Batch | Execute 8-item agenda (single session) | Owner | Document decisions | **PACKAGED** |
| GC-43-08 | Agent 013 Recovery | Physical power-on; verify sustained KA | Owner/RMM | N/A | **AWAITING-OWNER** |
| GC-43-09 | Agent 015 Flap Fix | Apply caffeinate/plist; verify 24h stability | Owner/Device | Revert power settings | **AWAITING-OWNER** |
| GC-43-10 | RTO/RPO Signoff | Sign DEC-40-01 decision sheet | Owner | N/A | **AWAITING-OWNER** |
| GC-43-10 | Restore Target | Approve target from candidate matrix | Owner | N/A | **AWAITING-OWNER** |
| GC-43-11 | Disk Threshold Policy | Enable `disk.threshold_enabled=true` OR accept advisory | Owner | Toggle config | **DECISION NEEDED** |
| GC-43-12 | v1.3.1 GitHub Release | Upload asset via GH token | Owner (token) | Delete release | **BLOCKED** |
| GC-43-13 | Dashboard v2 Swap | Import v2 artifacts; verify live parity | Operator | Revert import | **PENDING** |
| GC-43-14 | Dashboard Visual Test | Browser session; screenshot checklist | Operator | N/A | **PENDING** |
| GC-43-15 | Disk Threshold Config | Enable thresholds OR accept advisory | Owner | Toggle config | **PENDING** |
| GC-43-16 | Disk Risk Acceptance | Formalize advisory-only acceptance | Owner | Document decision | **PLANNED** |
| GC-43-17 | Packet Remediation Decision | Select A/B/C; document rationale | Engineering | Revert decision | **DECISION NEEDED** |
| GC-43-18 | Packet Remediation Execute | If A: UI rebuild; if B: upgrade | Engineering | Revert workflow | **BLOCKED** |
| GC-43-19 | Packet Proofs | Replay, malformed, datastore, counter, downstream, volume | Engineering | N/A | **BLOCKED** |
| GC-43-20 | Packet Certification | Certify/Defer/Reject with evidence | Engineering/Owner | Revert workflow | **BLOCKED** |
| GC-43-21 | ISM Wave Observe | Observe 08-29 wave; capture before/after | Automation | N/A | **PENDING** |
| GC-43-22 | ISM Restore Spot-check | 4th spot-check; restore→verify→delete | Automation | Re-delete temp index | **PLANNED** |
| GC-43-23 | Disk Relief Proof | Measure actual relief post-wave | Automation | N/A | **PENDING** |
| GC-43-24 | Dashboard v2 Import | Import v2 artifacts; verify live parity | Operator | Revert import | **PENDING** |
| GC-43-25 | Dashboard Visual Test | Browser session; screenshot checklist | Operator | N/A | **PENDING** |
| GC-43-26 | Dashboard Accessibility | Mobile/ARIA/contrast check | Operator | N/A | **PENDING** |
| GC-43-27 | Dashboard Client-Safe | Verify no internal IPs/paths in v2 | Automation | N/A | **PLANNED** |
| GC-43-28 | VT Host Perm Fix | chmod 640 host wazuh_manager.conf | Owner (sudo) | chmod 644 | **AWAITING-OWNER** |
| GC-43-29 | VT Key Rotation | Runbook execution if scheduled | Owner | N/A | **PLANNED** |
| GC-43-30 | Dashboard Visual Test | Browser session; screenshot checklist | Operator | N/A | **PLANNED** |
| GC-43-31 | Dashboard Accessibility | Mobile/ARIA/contrast check | Operator | N/A | **PLANNED** |
| GC-43-32 | VT Host Perm Audit | Verify host perms post-chmod | Automation | N/A | **PLANNED** |
| GC-43-33 | VT Key Rotation | Execute if scheduled | Owner | N/A | **PLANNED** |
| GC-43-34 | FP Population Check | Rerun universe query; update counts | Automation | N/A | **RUNNING** |
| GC-43-35 | FP Sample Extract | If population ≥50: extract sample | Analyst | N/A | **PENDING** |
| GC-43-36 | FP Review | Review new natural alerts | Analyst | N/A | **PENDING** |
| GC-43-39 | v1.3.1 Release Page | Create GitHub release; upload asset | Owner (token) | Delete release | **BLOCKED** |
| GC-43-40 | v1.3.1 Assurance | Verify tag/asset/hash/manifest | Automation | N/A | **VERIFIED** |
| GC-43-41 | Repo Commit/Push | Gates → classify → commit → push | Automation | N/A | **PLANNED** |
| GC-43-42 | Final Report | Write corrected final; supersession map | Automation | N/A | **PLANNED** |
| GC-43-43 | Final Validation | Reread all closeout artifacts | Automation | N/A | **PLANNED** |
| GC-43-44 | Closeout Summary | Operator summary with verdict/roadmap | Automation | N/A | **PLANNED** |

---

## 2. Protected Historical Files (Never Rewrite)

| File | Classification | Protection |
|------|----------------|------------|
| `ops/reports/current/final-phase43-operator-report-20260826-2359Z.md` | **IMMUTABLE HISTORICAL** | Never edit; corrective addendum only |
| All Phase 37-42 finals | **IMMUTABLE HISTORICAL** | Never edit |
| `ops/reports/current/final-phase42-operator-report-20260825-2130Z.md` | **IMMUTABLE HISTORICAL** | Never edit |
| All `ops/reports/generated/phase43-*` (pre-closeout) | **IMMUTABLE PHASE WORK** | Never edit |

---

## 3. Prohibited Actions

| Action | Prohibited | Alternative |
|--------|------------|-------------|
| Edit original final reports | YES | Write corrective addendum |
| Delete historical reports | YES | Archive/move only |
| Rewrite history | YES | Use addendum/supersession map |
| Force ISM deletion | YES | Observe only |
| Raise field limit > 2000 | YES | Owner emergency change only |
| Print secrets in reports | YES | Redact: `[REDACTED]` |
| `docker compose down -v` | YES | Never |

---

## 4. Approval Matrix

| Gate | Approver | Method | Evidence |
|------|----------|--------|----------|
| GC-43-07 (Owner Batch) | Owner | Signed session record | Signed DEC-40-01 + session notes |
| GC-43-11 (Disk Threshold) | Owner | Signed decision record | Decision record |
| GC-43-12 (GH Release) | Owner | GH token + push | Release URL |
| GC-43-13 (Dashboard v2) | Owner | Screenshot + parity check | Import receipt |
| GC-43-15 (Disk Policy) | Owner | Signed decision | Config diff |
| GC-43-17 (Packet Decision) | Engineering | Decision memo | Decision record |
| GC-43-18 (Packet Execute) | Engineering | PR + test results | PR link |
| GC-43-25 (Disk Threshold Apply) | Operator | Config diff + CI green | Config diff |