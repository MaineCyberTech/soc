# Phase 43: Owner Session Agenda

**Report ID:** phase43-22-owner-agenda.md
**Phase:** 43
**Title:** Phase 43 Owner Session Agenda — Eight-Item Single Session
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T14:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-22-owner-agenda.md`

---

## 1. Purpose

Single-session owner agenda (60 minutes) covering all eight open gates requiring human decision/action.

---

## 1. Session Overview

| Time | Agenda Item | Owner Action | Evidence Required |
|------|-------------|--------------|-------------------|
| T+0 | Agent 013 Recovery | Power-on device; verify network; confirm wazuh-agent service | Device online; KA in API |
| T+10 | Agent 015 Flap Remediation | Apply caffeinate/power settings on macOS device | Device awake; sustained KA |
| T+20 | RTO/RPO Signoff | Sign DEC-40-01 decision sheet | Signed PDF |
| T+30 | Restore Target Decision | Select target from candidate matrix | Signed approval |
| T+40 | Disk Threshold Policy | Decision: enable `disk.threshold_enabled=true` OR accept advisory | Decision record |
| T+45 | v1.3.1 GitHub Release | Provide GH token; approve publish | Token provided; publish executed |
| T+50 | Dashboard v2 Swap | Approve v2 artifact import | Import confirmation |
| T+50 | Disk Threshold Config | Apply `disk.threshold_enabled=true` or accept advisory | Config change + restart |
| T+55 | Closeout | Sign off all items; next review date | Signed session record |

---

## 2. Prerequisites (All Ready)

| Item | Status | Evidence |
|------|--------|----------|
| Agent 013 runbook | Ready | Phase40-15/16/16/17 |
| Agent 015 remediation | Ready | caffeinate plist + Energy settings doc |
| DEC-40-01 sheet | Ready | phase40-72-rto-rpo-owner-decision.md |
| Restore target memo | Ready | phase41-31/42-31/42-41 |
| v1.3.1 tag pushed | Done | `git ls-remote origin refs/tags/v1.3.1` |
| v1.3.1 asset on-box | Done | `ops/releases/v1.3.1/v1.3.1-from-tag.tar.gz` |
| Dashboard v2 artifact | Ready | `ops/evidence/p42-dashboard-v2/*.ndjson` |
| Disk threshold doc | Ready | R-DISKBYPASS in current-state |

---

## 2. Evidence Artifacts (Ready for Session)

| Artifact | Path |
|----------|------|
| Owner session agenda | This document |
| DEC-40-01 signoff sheet | `ops/reports/generated/phase40-72-rto-rpo-owner-decision.md` |
| Restore target memo | `ops/reports/generated/phase41-31-target-approval.md` |
| Disk threshold decision sheet | `ops/reports/generated/phase42-34-disk-policy-signoff.md` |
| Dashboard v2 artifact | `ops/evidence/p42-dashboard-v2/w1-w2-windows-endpoints.ndjson` |
| v1.3.1 publish runbook | `ops/reports/generated/phase42-79-v131-release-plan.md` |
| Disk threshold decision sheet | `ops/reports/generated/phase42-34-disk-policy-signoff.md` |

---

## 3. Scheduling Ask (Verbatim)

> **To**: MCT SOC Owner  
> **From**: Automation (Phase 43 orchestration)  
> **Subject**: 60-min Owner Session Request — 8 Decisions Required  
> **Proposed Windows**: [Provide 2-3 options]  
> **Agenda**: 8 decisions (013 recovery, 015 flap, RTO/RPO, restore target, disk threshold, GH token, dashboard v2, host chmod)  
> **Artifacts**: All decision sheets attached; no prep required beyond review  
> **Duration**: 60 minutes max  
> **Output**: Signed decisions + executed actions

---

## 4. Stop Conditions (Session Abort)

| Condition | Action |
|-----------|--------|
| Owner unavailable > 48h | Escalate; document deferral |
| Critical system failure during session | Pause; stabilize first |
| Conflicting decisions | Escalate to steering committee |

---

## 5. Post-Session Deliverables

| Deliverable | Owner |
|-------------|-------|
| Signed DEC-40-01 | Owner |
| Restore target approval memo | Owner |
| Disk threshold decision record | Owner |
| GH token provided (secure) | Owner |
| Dashboard v2 signoff | Owner |
| Host chmod 640 executed | Owner/Automation |
| Session minutes | Automation |

---

**STATUS: PACKAGED** — All artifacts ready. Awaiting owner availability for single 60-minute session.