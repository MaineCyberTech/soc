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
**THIRD CLIENT ENDPOINT DEPLOYED: Julians-Air (macOS, agent 015) via Level.io**
- the first macOS endpoint - after fixing three deployment bugs (arch-specific
pkg URL, silent curl failure, non-self-contained scripts). Moved to new
mac-clients group. Client fleet: 3 billable endpoints (013 SAMSUNG powered-off
at check - normal; 014 active; 015 active). Healthcheck 0 FAIL, CI green,
14 commits pushed.

## ES snapshot retention cleanup

- **EXECUTED with operator approval**: 43 -> 14 local snapshots (kept newest),
  repo 13G -> 8.7G (**freed ~4.3G**).
- S3 DR unaffected (37 SUCCESS verified before + after).
- Approval marker on file; apply script created with dry-run + S3 health gates.
- Local retention now meets policy (14).

## Client 013/014/015 health

- 013 SAMSUNG: disconnected (device powered off 06:41 - normal workstation);
  1,301 events/24h, no threats.
- 014 DESKTOP-MI54LFT: ACTIVE, 521 events/24h, Sysmon flowing, no threats.
- **015 Julians-Air (macOS): DEPLOYED via Level.io 07:44 UTC - ACTIVE,**
  **v4.14.7, 192.168.111.77, unified logging flowing (66 events/5m at check),**
  **no threats.**
- Queue-full alerts noted on 013/014 (agent buffer tuning backlog, no data loss).

## macOS deployment fixes (Level.io, applied during 015 rollout)

Three bugs found + fixed in the endpoint scripts during live deployment:
1. **Arch-specific pkg URL**: macOS packages are wazuh-agent-<ver>-1.arm64.pkg /
   -1.intel64.pkg; the Linux-style name (-1.pkg) returned 403. Script now
   resolves arch via uname -m.
2. **Silent curl failure**: -sL masked the 403 and created a 0-byte file.
   Now curl -fsSL --retry 2 + empty-file check + clear error.
3. **Non-self-contained scripts**: lib/mct-env.sh never reaches the endpoint
   (Level.io copies only the script). Helpers now INLINED in
   install-wazuh-macos.sh + install-wazuh-linux.sh. Also fixed BASH_SOURCE
   unbound under stdin/bash -c execution.

## mac-clients group

- Created (manager fs + API sync); agent 015 assigned + removed from default.
- Group config: macOS unified logging localfile.
- Doc: integrations/levelio/mac-clients-group-config.md.
- Level.io macOS actions should pass WAZUH_AGENT_GROUP=mac-clients.

## Billing and scorecard checkpoint

- Billable: **3 (013, 014, 015)**. Internal: 6 excluded. Total agents: 9.
- Scorecard cycle to 09-15; progress + billing checkpoints written.
- Billing record updated with Julians-Air (015, macOS, from 08-16 07:44).

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

- Client-aware run complete: **9 agents (6 internal + 3 client)**, no threats,
  backups valid, Greenbone proven, scorecard cycle on track.

## Remaining risks

1. Client scan authorization not signed.
2. DR config bundle 403 (keys needed).
3. 29 unpinned docker images (backlog).
4. Canarytoken T1 account.
5. Agent queue-full tuning (013/014).
6. 013 device power cycles (normal).
7. Thin pool 87.84% WARN (stable).
8. macOS telemetry volume low (unified logging, quiet workstation) - monitor
   first weeks for coverage quality.

## Recommended Phase 17 roadmap

1. **Client ops**: signed scan auth -> Greenbone client schedule -> first full
   scorecard (09-15) -> first invoice (**3 endpoints**).
2. **macOS**: confirm WAZUH_AGENT_GROUP=mac-clients in Level.io action;
   monitor unified-logging coverage; macOS-specific detections backlog.
3. **Windows**: complete 7-day re-measure (07-23); add explorer.exe to
   suppression (optional); build W1/W2 dashboards; then PS logging + D-rules.
4. **Docker**: pin remaining 29 refs; flip CI check to hard-fail.
5. **Cache**: cache wazuh agent pkg + sysmon with checksums; docker save/load
   snapshot for DR.
6. **White-label**: real brand.yml + client profile; render production artifacts.
7. **DR S3**: new keys -> config bundle SUCCESS -> full DR validation.
8. **ES retention**: add weekly retention cron (keep 14).
9. **Canarytoken T1**: hosted account -> validate chain.
10. **Agent buffer**: tune queue settings for client endpoints.

## Files added (summary)

- Reports: 20+ phase16-*.md (cleanup plan/dry-run/approval/results, endpoint
  health, FP validation final, digest pinning, CI check, cache bootstrap,
  wheelhouse, whitelabel wiring, rendering, scan readiness, capacity, DR S3,
  canarytoken, monthly ops, final).
- Scripts: es-snapshot-retention-apply.sh, check-unpinned-docker-images.sh,
  scripts/reporting/render-branded-template.py.
- Docs: docs/INTERNAL-CACHE-LAYOUT.md, integrations/levelio/mac-clients-group-config.md.
- Cache: /opt/mct-cache (9 dirs + velociraptor + checksum).
- Client: endpoint health summary, scorecard/billing checkpoints, branded
  kickoff email, whitelabel sample scorecard, billing record (3 endpoints).
- Endpoint scripts (fixed during 015 rollout): install-wazuh-macos.sh +
  install-wazuh-linux.sh - arch-specific pkg URL, curl fail-fast,
  self-contained inline helpers, stdin-exec compatible.

## No secrets

All reports cite paths/variable names only; no secret values printed.
