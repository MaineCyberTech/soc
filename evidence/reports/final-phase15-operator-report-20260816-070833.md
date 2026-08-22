> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# MCT Security Stack - Final Phase 15 Operator Report

Date: 2026-08-16
Pack: /home/user/mct-security-13 (Full Stack Audit, Self-Contained, White-Label, Client Ops)
Stack root: /opt/mct-security-stack

## Executive summary

Phase 15 completed a comprehensive assurance review: full infrastructure audit
(all components operational), repo/code/docs audits, self-contained packaging
strategy, white-label customization layer, dependency hardening (digests,
pip, checksums), and client ops stabilization. **Second client endpoint
deployed** (agent 014 DESKTOP-MI54LFT, Windows 11, Active, Sysmon flowing) -
2 billable endpoints now. Key findings: Velociraptor runs native (not compose),
local ES snapshot repo at action threshold (13G/43 snapshots), FP suppression
validation window open with 014 providing live test events. Healthcheck 0 FAIL,
CI green, 8 commits pushed this phase.

## Full infrastructure audit

- ALL components HEALTHY: Wazuh cluster (enabled/running), OpenSearch green
  (196 shards), 8 agents active (2 client), SO zeek-forward fresh, ElastiFlow
  10k+ flows/24h, Shuffle 13 containers, IRIS 5, MISP+Greenbone on VM103,
  Velociraptor native (:8002/:8889), OpenCanary up, Proxmox 5 VMs.
- Integration matrix + risk register created.
- Finding: Velociraptor = native binary (compose unused) - runbook annotated.

## Repo/code/docs audit

- Repo structure SOUND: 1,391 text artifacts, evidence separated (122).
- 67 sh + 245 py: 0 syntax failures. CI PASS.
- Source-of-truth map created; client-zero docs marked legacy.
- Client-facing content verified CLEAN (no internal leaks).

## Self-contained completeness audit

- All items classified: included/generated/external-cache/external-licensed/
  secret/ops-data. No undocumented pulls.
- docs/SELF-CONTAINED-STACK.md + missing-artifacts-actions created.
- Core Python = STDLIB ONLY (verified) - requirements.txt covers optional tooling.

## Internal dependency cache plan

- Docker registry mirror (registry:2) + save/load; pip wheelhouse; endpoint
  asset cache; apt-cacher-ng. docs/INTERNAL-DEPENDENCY-CACHE.md.

## White-label readiness

- config/examples/brand.example.yml + client-profile.example.yml + WHITELABEL.md.
- Client-safe templates compatible; generator wiring = backlog.
- Hardcoded brand scan: mct- = MCT brand (intentional); client-zero marked legacy.

## Client 013 operations

- Weekly health: telemetry flowing (1,301/24h, Sysmon 213); device observed
  powered-off at checkpoint (normal). Baseline + scorecard + billing checkpoints.
- **NEW: agent 014 DESKTOP-MI54LFT** (Windows 11, .162) deployed via Level.io
  at 07:03 UTC - Active, windows-clients, Sysmon flowing (508 events/30m),
  0 threats. Billing: 2 billable endpoints.

## Windows FP validation

- 7-day re-measure window OPENED (06:15 deploy -> closes 08-23).
- 0 suppressed-rule alerts (92153/92900) since deploy from agents 012/013/014.
- 014 = live test source (active, new) - will produce validation events.
- Suppression validation doc + detection promotion plan created.

## Greenbone scan authorization

- READY: target group plan + authorization status + template. Blocked on
  signed client authorization (none yet).

## Docker digest pinning

- Digests captured: IRIS (app/db/nginx), Shuffle (backend/frontend/orborus/
  worker), cloudflared, elastiflow. Docs: DEPENDENCY-HARDENING.md.
- Compose edits + MISP/Greenbone digests = backlog (approval window).

## Python/cache plan

- Core stdlib-only; requirements.txt (pymisp, requests, pyyaml) + wheelhouse
  plan. docs/PYTHON-TOOLING.md.

## ES snapshot retention

- Local: 43 snapshots / 13G = **AT ACTION THRESHOLD** (policy: keep 14).
- S3: 37 snapshots healthy. Retention report script + policy created.
- Cleanup approval-gated (destructive).

## Low-resource implementation

- Safe items: reporting scripts, retention reports, thresholds, backup
  retentions verified in-policy. No telemetry removed.
- Deferred (approval): ES cleanup, shuffle mem_limit, tenzir pause, digest
  recreate. Risk acceptance doc created.

## Proxmox capacity

- 87.84% WARN, FLAT (6 checks). vm-202 canary 90.95% flat.

## DR S3 status

- Data tier healthy (37 snapshots SUCCESS, latest 05:47). Config bundle 403
  unchanged (local-only accepted). Keys refresh procedure ready.

## Canarytoken T1

- BLOCKED (no hosted account). OpenCanary assets validated (121012 hit 08-15).

## Monthly client ops

- Client-aware run: 8 agents (6 internal + 2 client), no threats, backups
  valid, scorecard cycle running, billing 2.

## Remaining risks

1. ES local snapshot cleanup approval (13G, action threshold).
2. FP suppression validation pending (window open, 014 will produce events).
3. Client scan authorization not signed.
4. DR config bundle 403 (keys needed).
5. Docker digest compose edits (approval window).
6. Canarytoken T1 account.
7. Client 013 device power cycles (normal workstation behavior).
8. Thin pool 87.84% WARN (stable).

## Recommended Phase 16 roadmap

1. **Windows validation**: confirm suppression via 014/013 events; close 7-day
   re-measure; build W1/W2; then PS logging + D-rules.
2. **Client ops**: signed scan auth -> Greenbone client schedule -> baseline
   014 -> first full scorecard (09-15) -> first invoice (2 endpoints).
3. **ES snapshots**: approved cleanup (43->14) + weekly retention job.
4. **Docker**: pin compose digests (IRIS/Shuffle already captured); capture
   MISP/Greenbone; digest check in CI.
5. **Cache**: build /opt/mct-cache (endpoint assets + checksums + pip wheelhouse).
6. **White-label**: wire generators to config profiles; tenant-prefixed groups.
7. **DR S3**: new keys -> config bundle SUCCESS -> full DR validation.
8. **Canarytoken T1**: hosted account -> validate chain.
9. **CI**: levelio harness in GitHub Actions (Windows runner); shellcheck.

## Files added (summary)

- Audits: 25+ phase15-*.md (infrastructure, repo, code, docs, self-contained,
  whitelabel, branding, cache, digest, pip, checksums, retention, low-resource,
  DR, canarytoken, client ops, final).
- Docs: SELF-CONTAINED-STACK.md, WHITELABEL.md, INTERNAL-DEPENDENCY-CACHE.md,
  DEPENDENCY-HARDENING.md, PYTHON-TOOLING.md.
- Config: brand.example.yml, client-profile.example.yml.
- Scripts: es-snapshot-retention-report.sh (+ P14 resource-efficiency-report.sh).
- Client: 013 weekly health, baseline checkpoint, scorecard + billing checkpoints,
  014 noted, monthly scorecard, billing record updated (2 endpoints).
- Manifest: repo-artifact-cache-manifest.json (real digests).

## No secrets

All reports cite paths/variable names only; no secret values printed.
