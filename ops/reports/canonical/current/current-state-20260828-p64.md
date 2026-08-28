# Canonical Current-State — Phase 64 (supersedes current-state-20260828-p63.md)

**Doc ID:** current-state-20260828-p64
**Date:** 2026-08-28T19:38:00Z
**Status:** CURRENT (live truth). Supersedes `current-state-20260828-p63.md`.
**Scope:** MCT Security Stack — safe deployment + kill-switch-without-outage certification, watchdog valid/invalid
certification, Wazuh-to-IRIS recovery canary, bounded Class-A production.

## Live Truth (verified this session)
- **Production routing:** ACTIVE, scoped to Class-A high-severity lane (`wazuh-high-severity-to-iris` → IRIS, value-blind,
  ROUTED 200 proven). Packet lane (`e133a645-…`) is a separate test workflow, NOT production.
- **integratord:** RUNNING (single instance, PID 26278) on wazuh.master-1, hook present, config root:wazuh 640.
- **Watchdog:** s6-managed (PIDs 25174/26174, lock-coordinated), monitors integratord; recovers valid config (no outage),
  fails closed on invalid config.
- **Config-source of record:** redacted governed copy `ops/source/ossec-conf-source/ossec.conf.class-a.governing.redacted`
  (api_keys masked); live backup outside repo (sha256 1893ae0e…); staged-deploy validates owner/group/mode/readability/xml/hook/backup/rollback before restart.
- **Dashboard v2:** 4 saved objects present (re-checked). **Disk watermark:** threshold_enabled=true (persistent); 3 nodes 67%.
- **Corrupt `eb937a37`:** GONE (GET 400). **Restore:** APPROVED DEFERRAL (DR future).
- **Evidence:** phase64-config.json (8 keys), phase64-correlation.json (8 keys), phase64-states.json (13 states, live in Shuffle), all verified by `p64-agents-ci.sh` (PASS=5 FAIL=0).

## Open / Gated (NO-GO without sign-off)
- Full restore rehearsal — deferred (DR future).
- Credential rotation — not required (value-blind token).
- Manual ISM/index intervention — none needed.
- Container recreate-to-deploy — requires sudo + owner sign-off (not performed).

## Phase 63 Incident — Corrected
Root cause: `docker cp` restore overwrote ossec.conf ownership (1000:1000), stopping all daemons. Corrective control:
staged deployment enforces root:wazuh 640 + validation before restart; kill switch uses integratord-only restart via watchdog.
Kill switch re-tested WITHOUT manager outage (engage PID 21450 / rollback PID 21512, ROUTED 200).

## Reports / Evidence
- 460 phase64 reports: `ops/reports/generated/phase64/`.
- Evidence: `ops/evidence/phase64-{config,correlation,states}.json`.
- CI: `ops/scripts/p64-agents-ci.sh` (PASS=5 FAIL=0).
- Final operator report: `ops/reports/current/final-phase64-operator-report-20260828T193500Z.md`.

## Canonical pointer
AGENTS.md → this doc (`current-state-20260828-p64.md`).
