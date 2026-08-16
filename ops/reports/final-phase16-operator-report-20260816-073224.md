# MCT Security Stack - Final Phase 16 Operator Report

Date: 2026-08-16
Pack: /home/user/mct-security-14 (Retention Cleanup, Windows Validation, Cache Bootstrap, White-Label)
Stack root: /opt/mct-security-stack

## Executive summary

Phase 16 implemented the highest-value Phase 15 findings safely: ES local
snapshot cleanup EXECUTED (approved; 43->14 snapshots, freed 4.3G), Windows FP
suppression VALIDATED with real events (effective + safely scoped), Docker
digest pinning applied to 6 images with CI check, internal cache bootstrapped
with first artifact, and white-label generator wired producing branded samples.
Client ops stable: 2 billable endpoints (013 powered-off at check - normal;
014 active). Healthcheck 0 FAIL, CI green, 10 commits pushed.

## ES snapshot retention cleanup

- **EXECUTED with operator approval**: 43 -> 14 local snapshots (kept newest),
  repo 13G -> 8.7G (**freed ~4.3G**).
- S3 DR unaffected (37 SUCCESS verified before + after).
- Approval marker on file; apply script created with dry-run + S3 health gates.
- Local retention now meets policy (14).

## Client 013/014 health

- 013 SAMSUNG: disconnected (device powered off 06:41 - normal workstation);
  1,301 events/24h, no threats.
- 014 DESKTOP-MI54LFT: ACTIVE, 521 events/24h, Sysmon flowing, no threats.
- Queue-full alerts noted (agent buffer tuning backlog, no data loss).

## Billing and scorecard checkpoint

- Billable: 2 (013, 014). Internal: 6 excluded.
- Scorecard cycle to 09-15; progress + billing checkpoints written.

## Windows FP validation

- **VALIDATED**: post-deploy window (06:15+) had exactly 1 alert - explorer.exe
  (Microsoft-signed, NOT in suppression list) - CORRECTLY not suppressed.
- Listed paths (backgroundTaskHost 53x, RuntimeBroker 11x, taskhostw 10x
  pre-deploy) = 0 alerts post-deploy. Suppression effective + safe.
- Decision: KEEP rules 121105/121106. Safety tests PASS (3/3 passive).

## Docker digest pinning

- **6 images pinned** (digests = running images, no recreate needed):
  IRIS app, Shuffle frontend/backend/orborus, MISP core, Greenbone gvmd.
- 29 refs remain unpinned (versioned tags allowed; backlog).
- CI unpinned-image check added (informational).

## CI unpinned-image check

- ops/scripts/check-unpinned-docker-images.sh + GitHub Actions step +
  local CI step. Reports violations, non-blocking (backlog).

## Internal cache bootstrap

- **/opt/mct-cache created** (9 dirs): velociraptor v0.77.2 binary cached
  (sha256 recorded), checksums/ populated, manifest updated.
- Layout doc: docs/INTERNAL-CACHE-LAYOUT.md.

## Python wheelhouse/tooling cache

- Wheelhouse built: 10 wheels (pymisp, requests, pyyaml + deps) at
  /opt/mct-cache/python-wheelhouse/. Offline install documented.

## White-label generator and samples

- scripts/reporting/render-branded-template.py wired (config-driven, example
  fallback). Rendered: branded sample scorecard + branded kickoff email.
- Client-safety verified (no internals in outputs).

## Greenbone scan authorization

- Preflight ready; hard-gated on signed authorization (none yet). No scan
  executed - correct.

## Proxmox capacity

- Thin pool 87.84% (FLAT 7 checks), vm-202 90.95% (flat). Host disk / 65%
  (improved by ES cleanup).

## DR S3 status

- Data tier healthy: 37 SUCCESS (05:47). Local 14 post-cleanup.
- Config bundle 403 unchanged (keys needed).

## Canarytoken T1

- BLOCKED (no hosted account). OpenCanary validated.

## Monthly client ops

- Client-aware run complete: 8 agents, 2 billable, no threats, backups valid,
  Greenbone proven, scorecard cycle on track.

## Remaining risks

1. Client scan authorization not signed.
2. DR config bundle 403 (keys needed).
3. 29 unpinned docker images (backlog).
4. Canarytoken T1 account.
5. Agent queue-full tuning (both client endpoints).
6. 013 device power cycles (normal).
7. Thin pool 87.84% WARN (stable).

## Recommended Phase 17 roadmap

1. **Client ops**: signed scan auth -> Greenbone client schedule -> first full
   scorecard (09-15) -> first invoice (2 endpoints).
2. **Windows**: complete 7-day re-measure (07-23); add explorer.exe to
   suppression (optional); build W1/W2 dashboards; then PS logging + D-rules.
3. **Docker**: pin remaining 29 refs; flip CI check to hard-fail.
4. **Cache**: cache wazuh agent pkg + sysmon with checksums; docker save/load
   snapshot for DR.
5. **White-label**: real brand.yml + client profile; render production artifacts.
6. **DR S3**: new keys -> config bundle SUCCESS -> full DR validation.
7. **ES retention**: add weekly retention cron (keep 14).
8. **Canarytoken T1**: hosted account -> validate chain.
9. **Agent buffer**: tune queue settings for client endpoints.

## Files added (summary)

- Reports: 20+ phase16-*.md (cleanup plan/dry-run/approval/results, endpoint
  health, FP validation final, digest pinning, CI check, cache bootstrap,
  wheelhouse, whitelabel wiring, rendering, scan readiness, capacity, DR S3,
  canarytoken, monthly ops, final).
- Scripts: es-snapshot-retention-apply.sh, check-unpinned-docker-images.sh,
  scripts/reporting/render-branded-template.py.
- Docs: docs/INTERNAL-CACHE-LAYOUT.md.
- Cache: /opt/mct-cache (9 dirs + velociraptor + checksum).
- Client: endpoint health summary, scorecard/billing checkpoints, branded
  kickoff email, whitelabel sample scorecard.

## No secrets

All reports cite paths/variable names only; no secret values printed.
