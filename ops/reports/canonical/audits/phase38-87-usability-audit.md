# Phase 38-87: Usability Audit Report

**Report ID:** phase38-87-usability-audit
**Phase:** 38
**Title:** Phase 38-87: Usability Audit Report
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-87-usability-audit.md`

| Field | Value |
|-------|-------|
| **Report ID** | phase38-87 |
| **Generated** | 2026-08-25 21:17 UTC |
| **Classification** | Internal / Operational |
| **Owner** | MCT SOC |
| **Status** | PARTIAL |

**Status:** PARTIAL
**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-87-usability-audit.md`
**Retention Class:** LONG

---

## 1. Executive Summary

Operator experience is mid-migration: a single authoritative current-state document now exists (phase38-49) and a canonical navigation structure is fully designed (phase38-55–64), but the migration was deferred, so day-to-day discoverability remains poor across a 1,922-file corpus. Alert-facing usability is degraded by field-error spam (~147/min). Two designed dashboards (W1/W2) were never built. Runbook coverage is strong (90+ runbooks). Mobile accessibility untested.

## 2. Status Clarity

- **Single current-state:** `generated/phase38-49-generate-current-state.md` is the designated source of truth and is internally consistent (claims table with VERIFIED/UNVERIFIED markers).
- Residual ambiguity: older phase reports (e.g., phase38-24's "433 alerts", phase38-01's "796 executions") remain in place WITHOUT supersession banners; an operator landing on them gets stale numbers (433 verified live today, but 796 executions is now 68). Supersession banners are a migration-plan item (59), not yet applied.
- Status enum drift persists: 48 files carry non-enum status `COMPLETE` (phase38-66 validation) — machine-parsing of "what's done" still unreliable.

## 3. Canonical Navigation — DESIGNED, NOT APPLIED

Designed artifacts exist and are coherent:
- 55 canonical structure design · 56 naming standard · 57 authority model
- 58 retention classification · 59 migration plan · 60 canonical index
- 61 machine catalog · 62 source map · 63 backlink map · 64 README navigation

Migration state: dry-run completed (68), apply deferred (69/70 report the gate not taken). Consequence: `ops/reports/` remains flat + `generated/` mixed-era; navigation depends on tribal knowledge and grep.

## 4. Dashboards — MISSING ARTIFACTS

W1/W2 Sysmon dashboards were never produced as JSON artifacts (confirmed by phase38-34 missing-artifact scan: only `netflow-health-dashboard.json` and `zeek-detections-dashboard.json` exist under `reporting/queries/dashboards/`). Endpoint-certification finals gated on W1/W2 ("gated" per phase27/28 operator reports). Impact: endpoint health visibility relies on ad-hoc API queries — no at-a-glance operational view exists for the Windows fleet.

## 5. Alert Noise Usability

Indexer-side `Limit of total fields [1000]` errors fire ~147/min (14,105/day, see phase38-85 §5). For operators triaging via indexer logs or dashboards that surface indexing failures, this drowns genuine issues. Until fixed (archives template limit raise or ingest flattening), any red/yellow dashboard signal must be mentally discounted — a false-negative-inducing UX hazard.

## 6. Report Discoverability

- Corpus: **1,922 md files** under `ops/reports` (88 in `generated/`); flat namespace with phase-number prefixes only.
- Working aids that DO exist: `catalog-reports.csv/json` in generated/, backlink map (63), source map (62). These help tooling more than humans until the directory restructure lands.
- Search ergonomics: no tags/front-matter standard applied corpus-wide (schema defined at 07; 72 files fail ≥1 check).

## 7. Ownership Gaps

Authority model (57) defines owners, but application is partial: several backlog items and retired components (e.g., security-onion container cleanup, Shuffle hardening steps awaiting "operator approval") have no named accountable individual — ownership defaults to "SOC" generically. Client-facing reporting ownership is defined (client-onboarding templates + client-reporting runbook) and functional.

## 8. Runbooks

Strong coverage: 90+ runbooks under `ops/runbooks/` (alert-routing, backup-cron-operations, break-glass, dr-restore, shuffle-restart-recovery, safe-mode, credential rotation, per-component ops) plus multi-node ops scripts wired into cron. Gap noted: no runbook yet references the corrected snapshot-repo dual-target setup post-drift D-03b correction (phase38-79 §6).

## 9. Mobile Accessibility — UNTESTED

No responsive/accessibility testing has been performed on: Wazuh dashboard via cloudflared path, Shuffle UI (:3001), IRIS web (:8443). All assume desktop browser. Field-incident use from mobile remains unsupported by evidence; flag as accepted limitation rather than defect until a requirement emerges.

## 10. False-Health Risks

- Cluster health GREEN (3 nodes, 274 shards, 100% active) can mask the storage trajectory: disk 83% and climbing toward the 85% flood-stage band while GREEN stays GREEN. A green-cluster reading without the disk column invites complacency.
- Similarly, "8 agents active" headline can mask 015's flapping (reconnected then dropped same day) and 013's 15h silence.
Recommendation: composite health banner in the current-state doc combining cluster+disk+fleet deltas (backlog P2).

## 11. Top Usability Actions

1. Apply supersession banners to stale headline figures (796→68 executions; repo-registration correction) — cheap, high clarity value.
2. Execute migration apply gate G7 after schema rewrite of the 48 `COMPLETE` statuses.
3. Fix archives field-limit error class (removes dominant noise source).
4. Build W1/W2 dashboards from existing design notes.
5. Add composite-health banner + named owners to open P0/P1 items.

---
*Assessment based on live file counts, API queries, and generated-corpus inspection, 2026-08-25.*
