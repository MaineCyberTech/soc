# Phase 42 Change Register — Gates G42-01..14

**Report ID:** phase42-02-change-register
**Phase:** 42
**Title:** Change Register — Fourteen Gates Mapped to Execution States, Evidence Paths, and Owners
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:34:11Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-02-change-register.md`

---

| Gate | Change / item | Class | State at 08:34Z | Evidence |
|---|---|---|---|---|
| G42-01 | Sensor config verify-stable (P41 carryover; agent016 mct-packet-sensor config unchanged) | verify | **DONE-P41 VERIFY-STABLE** — no drift signals in monitor logs; rejections attribution confirms sensor emitting expected syscollector/vuln lanes | report 11 §3 |
| G42-02 | Field-cycle adjudication script staged | stage | **STAGED** — `ops/scripts/p42-field-cycle-adjudicate.sh` chmod +x (mode 755, mtime 07:53Z), `bash -n` SYNTAX-OK; execution PENDING-WINDOW | reports 03–09 |
| G42-03 | Packet native rebuild probes | probe | **EXECUTED → DEFINITIVE-NEGATIVE** — native rebuild path closed; standing platform defect reaffirmed | phase31v2 chain; commit 6579919 message "packet lane honestly deferred" |
| G42-04 | Packet lane production apply | apply | **BLOCKED-platform** — lane remains test-only until upstream platform defect clears | report 01 §6 |
| G42-05 | Owner batch: agents 013/015 remediation decisions | owner | **AWAITING-OWNER** | phase41-82/83 register |
| G42-06 | Owner batch: GitHub API token for v1.3.1 publication | owner | **AWAITING-OWNER** | v1.3.1 MANIFEST publication status |
| G42-07 | Owner batch: dashboard login session for render-proof | owner | **AWAITING-OWNER (login-gated)** — query-layer validation done via API | report 01 §2 |
| G42-08 | Repair-script churn fix (`shuffle-repair-network.sh` restart-only-if-reconnected) | fix | **APPLIED + PROVEN** — dry-run/live run prints `NO-OP: frontend network intact; no restart needed`; restart path retained for genuine reconnects | git diff @6579919+; report 01 §5 |
| G42-09 | nosniff dedup | fix | **APPLIED** (single-source container-side) — proxy conf duplicate removed in working tree; `shuffle-frontend` nginx.conf lines 57/98 serve the header | report 01 §5 |
| G42-10 | VT integration perms 640 container-side | hardening | **APPLIED** — container-side perms verified; host-side manifest row carried | P41 hardening chain |
| G42-11 | v1.3.1 cut | release | **EXECUTED** — annotated tag 71701dfd→6579919 PUSHED; asset on-box sha256 4e6c3712… built 07:52:53Z; publish BLOCKED-token | ops/releases/v1.3.1/MANIFEST.md |
| G42-12 | Monitor certification (delivery monitor + watchdog) | certify | **EVIDENCE-READY** — 26 cycles incl. 2 real ERROR catches; watchdog zero-stall | report 01 §4; logs cited there |
| G42-13 | ISM watch (`wazuh-archives-14d`, states hot→delete) | arm | **ARMED** — policy live; legacy 08.26 predates template (explain policy=None) so birth-time assignment is the certification target | `_plugins/_ism/policies/wazuh-archives-14d` output, report 06 |
| G42-14 | Dashboard session | gate | **LOGIN-GATED** (=G42-07) | report 01 §6 |

## Commit plan note

Working-tree set is intentional and minimal: two fixes (G42-08/09), one staged script
(G42-02), one append-only evidence TSV, one release asset directory. Commit lands after
adjudication so the addendum (report 13) can reference the same tree state.

## CHG-42-AGENTS-01 (appended 2026-08-26T10:12Z, phase42-86)

| Field | Value |
|---|---|
| Change | Minimal root AGENTS.md diff: canon pointer → `current-state-20260826-p42.md`; P42 closures appended to resolved list (churn/nosniff/VT-container/v1.3.1-custody/EID); field clause names staged adjudicator; packet blocker refreshed to DEFINITIVE-negative + B>A>C; two notes added (HTTP-app-is-only-interpolator extension; disk-threshold-disabled config-truth pointer) |
| Backup BEFORE | `ops/backups/agents/AGENTS.md.bak-20260826-100238` + `.sha256-20260826-100238` |
| sha256 BEFORE | `7401ac9b836d91373fd44ba9439f4994615baa4d86908226561c6470fbc123ab` |
| sha256 AFTER | `d95d66de530893d9e8c587eddb55c04400ba987b909830c3de0d124f79051242` |
| Method | Python assert-guarded replace ×5 (dry-run hunks published phase42-86 §3 before apply); any no-op anchor would have aborted |
| Validation | Post-greps 1/1/1/1/1 as specified; p39-agents-ci.sh **PASS (0 warnings)**, length 172 ≤ 200; zero secrets introduced |
| Status | APPLIED |
