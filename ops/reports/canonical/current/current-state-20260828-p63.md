# Canonical Current-State — Phase 63 (supersedes current-state-20260828-p62.md)

**Doc ID:** current-state-20260828-p63
**Date:** 2026-08-28T19:10:00Z
**Status:** CURRENT (live truth). Supersedes `current-state-20260828-p62.md`.
**Scope:** MCT Security Stack — bounded Class-A production certification, post-P62 reconciliation, and the
kill-switch/rollback test incident (see Open / Gated).

## Live Truth (verified this session)
- **Production routing:** ACTIVE, explicitly scoped to the **Class-A high-severity lane**
  (`wazuh-high-severity-to-iris` → IRIS, value-blind, `ROUTED 200` proven). Packet lane
  (`e133a645-95b9-4e01-9454-e270d2a0b599`) is a separate test workflow, NOT production.
- **integratord:** RUNNING (PID 17452) on wazuh.master-1 with the Class-A hook present (rollback verified).
- **Watchdog:** alive (PID 17348), auto-started via s6; governed source at `ops/source/integratord-watchdog/`.
- **Dashboard v2:** imported (4 saved objects, successCount 4); `p39-w2-windows-telemetry-quality-v2` present.
- **Disk watermark:** `cluster.routing.allocation.disk.threshold_enabled=true`; 3 indexer nodes 67% used.
- **Corrupt `eb937a37`:** GONE (GET 400 "Failed finding workflow"); nothing to delete.
- **Restore:** APPROVED DEFERRAL (DR future). Review triggers: IRIS token change, Shuffle workflow change,
  or ossec.conf integratord hook change re-opens the gate.
- **Evidence authenticity:** 14/14 phase63 execution_ids verified present in live Shuffle (per-workflow
  executions LIST; single-execution GET unsupported/404).

## Open / Gated (NO-GO without sign-off)
- Full restore rehearsal — deferred (DR future).
- Credential rotation / token invalidation — not required now (value-blind token; old literal gone).
- Manual ISM/index intervention — none needed (OpenSearch 3.2.0 ISM incompatibility accepted, benign).
- Container recreate-to-deploy — requires sudo + owner sign-off (not performed this session).

## INCIDENT — kill-switch test (2026-08-28)
Restoring `ossec.conf` via `docker cp` overwrote ownership to bogus `1000:1000` (mode 640). All Wazuh daemons
failed to read config ("Error reading XML file 'etc/ossec.conf' (line 0)") and the **entire manager stopped**.
Watchdog did NOT auto-recover integratord (masked by the ownership fault). Recovered manually:
`chown root:wazuh /var/ossec/etc/ossec.conf && chmod 640` + `wazuh-control start`.

**Remediation (recorded):** the kill-switch runbook MUST preserve `ossec.conf` ownership `root:wazuh` (mode 640)
on any restore (`docker cp` does not preserve it). Watchdog auto-recovery path to be re-validated in a
controlled window before reliance.

## Reports / Evidence
- 410 phase63 reports: `ops/reports/generated/phase63/`.
- Evidence: `ops/evidence/phase63-correlation.json`, `phase63-states.json`, `phase63-production.json`.
- CI: `ops/scripts/p63-agents-ci.sh` — PASS=5 FAIL=0.
- Final operator report: `ops/reports/current/final-phase63-operator-report-20260828T190500Z.md`.

## Canonical pointer
AGENTS.md → this doc (`current-state-20260828-p63.md`).
