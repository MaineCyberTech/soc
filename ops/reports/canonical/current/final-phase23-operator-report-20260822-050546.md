# MCT Security Stack - Final Phase 23 Operator Report

Date: 2026-08-22
Pack: /home/user/mct-security-21 (Endpoint Apply Windows, Capacity Recovery, Detection Routing Activation, Credential Rotation, Documentation Governance)
Stack root: /opt/mct-security-stack | Release: v1.1.0 (v1.2.0 staged)

## Executive summary

Phase 23 delivered the P22 roadmap: **agent 015 macOS flood RESOLVED** (reconnected 04:22 UTC,
bounded telemetry, archives ~0, 0 queue-full - 24h window accruing), **disk relief applied**
(85% -> 83%; OpenSearch back below the low watermark, no write blocks), **swap root-cause
documented** (transient flood pressure - now idle pages, si=0, 8.6%), **Sysmon EventID 7
include-oriented design** prepared (apply blocked on endpoint access), **documentation
governance** executed (ARCHITECTURE/STACK-OVERVIEW refreshed, evidence banners 122/122 applied
making the v1.0.0 claim true, client-artifact + white-label governance, client-dir cleanup),
change register + approval gates established, and regression audits green. Credential rotations
(VT key, indexer) and PVE222 token remain blocked on replacements/approval; Zeek Class A
routing stays approval-pending; NetFlow scope and Greenbone remain operator/client-gated.

## Change register / approval gates

- Created: phase23-change-register.md (C1-C9) + phase23-approval-gates.md.
- Applied: C4 disk relief (D1+D2, non-destructive); C8 docs governance. C2 validated externally.
- Pending: C1 (014), C3 (Zeek routing), C5 (PVE222), C6 (VT), C7 (indexer), C9 (013 info).

## Windows 014 Sysmon

- Precheck: no endpoint access -> apply stopped; config hash + baseline steps delivered.
- **Include-vs-exclude design review**: EventID 7 switched from ever-growing exclusion list to
  **include-oriented** policy (LOLBin loading processes, unsigned modules, non-system module
  paths) - `phase23-eventid7-policy.xml` + test matrix. Powershell excluded from process-include
  to avoid re-noise (caught via module conditions).
- Apply: **BLOCKED** (access + approval). Before/after + **rule-11 throttle retirement criteria**
  defined (retire when EID7 < 2K/24h + buffer clean 24h).

## Agent 015 macOS

- **RECONNECTED 04:22 UTC** (external apply of the bounded config). Bundle integrity verified
  (checksums + syntax); **predicate upgraded** to the research-informed set (sshd/tccd/
  screensharingd/logoutd/logout/session + auth/sysconfig/loginwindow). Upgrade-preservation
  risk documented (re-run repair --check after agent upgrades).
- Validation (early PASS): keepalive continuous, mac-clients group, archives 0 since reconnect,
  0 queue-full, bounded events (sudo/srcuser/dstuser) flowing. 24h completion target 00:00 UTC 08-23.

## Agent 013

- Powered-off (likely, 6d silence, abrupt disconnect); **unconfirmed remotely** - client power
  confirmation required. Coverage gap on a billable endpoint.

## Zeek Class A routing

- Preflight: v2.2 clean (316/24h), Class A logtest+live verified, Shuffle/IRIS healthy.
  **Gap found + closed in plan**: duplicate-case protection + rate-limit (stop at 5 cases/day)
  added to the enable procedure.
- Enable: **APPROVAL PENDING** (C3). Case-volume validation method prepared.

## Suricata

- Symlink/updater/cron healthy; ingest proven; quiet (1 event). Severity 1-2 rules stay staged.
  No invasive traffic.

## Disk / watermarks

- Preflight: 85% root, nodes 84.7% vs low watermark 85% (high 90%, flood 95%); no write blocks.
- Inventory + relief plan; **D1+D2 applied (dangling + unused images): ~2.8GB reclaimed
  (85% -> 83%)**; cluster green (266 shards), 0 read-only blocks, containers intact.
- Validation PASS. D5 swapfile resize deferred (only if > 85% again). No evidence/snapshot/
  backup deletion (in-policy stores untouched).

## Swap / memory

- Root cause: transient flood-burst pressure; now **idle pages (707MB, 8.6%), si=0, PSI ~0**.
  No swap-clear/resize action (not percentage-driven). Memory review: indexers + shuffle-
  opensearch healthy, no safe change identified (no pressure signals).

## PVE222 / credentials

- PVE222: **blocked on replacement token** (401 persists); reconciliation procedure prepared.
- VirusTotal: **blocked on replacement key**; env-render path ready.
- Indexer password: **approval-pending**; env abstraction in place; post-rotation validation
  baseline captured (green auth, elastiflow fresh, CI PASS).

## Documentation governance

- ARCHITECTURE.md refreshed (endpoints, detection posture, release); STACK-OVERVIEW header
  current. Partial agent-inventory refresh (P24).
- Client-dir: classification doc + governance doc; 11 internal artifacts moved to
  reporting/output/internal/; client-safe scorecard carries classification header.
- **Evidence banners: applied to 122/122** with before/after hash manifest (claim in v1.0.0
  notes now true).
- Branding: WHITELABEL-GOVERNANCE.md; brand.example.yml neutralized; template neutralization
  backlogged.

## NetFlow / Greenbone / fleet / billing

- NetFlow: blocked (operator classification; alerts unarmed).
- Greenbone: unsigned.
- Fleet: 015 restored; 014 degraded (throttle); 013 offline. Billing: **PARTIAL** (2/3
  covered; not ready until 013 confirmed + 014 tuned). Scorecard draft (internal).

## Regression audits

- Full system + code/security/performance/docs regression audits: **NO regressions**; CI PASS,
  secret scan PASS, health 0 FAIL. Risk register + remediation backlog (P24) produced.

## Remaining risks (top)

1. 014 flood agent-side (throttled) - tuning blocked on access.
2. 013 offline (power unconfirmed) - 6d coverage gap.
3. Disk 83% - below watermark but watched (14d deletes from ~09-05; swapfile resize if >85%).
4. PVE222 token missing; VT key + indexer rotations pending.
5. NetFlow scope unconfirmed (~423K/24h).
6. Redis loop ~10K/day (owner).
7. Git history literals (accepted, private).
8. Greenbone unsigned.

## Recommended Phase 24 roadmap

1. **014 tuning apply** (endpoint access) -> throttle retirement -> telemetry healthy.
2. **013 power confirmation** (client) -> billing readiness completion.
3. **015 24h window completion** -> scorecard inclusion + post-upgrade predicate re-check.
4. **Credential rotations** (VT replacement key, indexer approval) + PVE222 token -> post-
   rotation validation.
5. **Zeek Class A routing enable** (approval) + case-volume window.
6. **v1.2.0 release** (approval): tag + GitHub release + portable bundle.
7. **Disk watch**: 14d archive deletes, prune review, swapfile resize if > 85%.
8. **Governance finish**: template brand neutralization, STACK-OVERVIEW inventory, evidence
   banner-at-creation.
9. **NetFlow scope** -> arm alerts; **Greenbone** signed auth -> client scan; **Redis** VPS fix.

## Files added (summary)

- 35+ Phase 23 deliverables: preflight/status-review, change register + approval gates,
  windows014 (precheck, design review, policy XML, final config, apply, before/after,
  throttle decision), macos (bundle precheck, repair apply, reconnect 24h, telemetry decision,
  bundle predicate v2), 013 coverage, zeek (preflight, enable, validation), suricata readiness,
  disk (preflight, inventory, relief plan, relief apply, validation), swap root-cause, memory
  plan, pve222 (refresh + reconciliation), vt rotation, indexer rotation, post-rotation
  validation, architecture refresh, client-dir classification + governance doc, evidence
  banner reconciliation + manifest, branding governance, netflow, fleet/billing/scorecard,
  monthly ops + monthly scorecard, regression audits + risk register + remediation backlog,
  repo commit status + v1.2.0 readiness, final report. RELEASE-NOTES v1.2.0 draft.

## No secrets

All reports cite paths/variable names only; no secret values printed.