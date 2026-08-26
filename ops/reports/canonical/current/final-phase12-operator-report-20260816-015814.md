# MCT Security Stack - Final Phase 12 Operator Report

Date: 2026-08-16
Pack: /home/user/mct-security-10 (GitHub CI, Portable Release, First Client Readiness)
Stack root: /opt/mct-security-stack

## Executive summary

Phase 12 made the stack versioned, CI-verified, and release-bundled. The repo
is prepared for GitHub `mainecybertech/soc` (local git init, hardened
.gitignore, pre-push checklist + runbook) but **NOT pushed - awaiting operator
approval**. CI (GitHub Actions + local) wired to the Phase 11 verify scripts;
local CI PASS. Portable release bundle built (536K, 1015 files, 0 sensitive).
First-client work advanced to sales-ready kit (no client engaged - blocker
unchanged). Operational follow-ups CLOSED: agent 009 removed (phantom
registration, coverage 100%), thin pool monitoring automated (87.84% WARN),
Greenbone schedule confirmed (proof pending 06:00 UTC run), Windows tuning
cycle measured (2 FPs identified), Canarytoken T1 blocker documented.

## Starting state

- Phase 11 close: portable repo, all verify PASS, no git, no CI, 7 agents
  (1 never-connected), thin pool 87.8%, Greenbone schedule set.

## GitHub repo status for mainecybertech/soc

- Local git init done (branch master, no commits - per plan, commit planned on
  approval to main).
- Remote NOT added (runbook documents add + push steps - approval-gated).
- .gitignore hardened: .env/creds/keys/pcap/evtx/archives + NEW
  client.config.yaml (live Velociraptor keys - found during baseline),
  shuffle-periodic-repair.log.
- Dry-run staged set: 935 files, 0 sensitive, largest 207KB (now excluded).
- **Status: NOT PUSHED - local init only, commit+push approval-gated.**

## CI/local verification status

- .github/workflows/verify.yml: push main + PR; repo-only checks (layout,
  stale-refs, secret scan, bash -n, py_compile, PS presence); live-stack checks
  explicitly skipped (docker/creds unavailable in CI).
- scripts/ci/run-local-ci.sh: PASS on host (61 sh bash -n, 245 py compile,
  4 verify scripts, secret scan).
- Secret scan: 15 reference-only hits; client.config.yaml caught + excluded.
- Reports: phase12-ci-validation.md, phase12-secret-scan-ci-status.md.

## Portable release bundle status

- Build: scripts/ci/build-release-bundle.sh (dry-run default, --apply to build).
- Artifact: /home/user/mct-security-releases/mct-security-stack-release-20260816-014828.tar.gz
  (536K, 1015 files, sha256 8d4dc402..., 0 sensitive - gate verified).
- Manifest: release-manifest.json + RELEASE-NOTES.md.
- Build fixes: phantom include path, output dir perms, example-env exemption.

## First client engagement status

- No client engaged. Sales-ready kit created (client-onboarding/phase12-sales-ready-pilot-kit.md)
  + managed security pilot offer (service-packaging/phase12-managed-security-pilot-offer.md).
- Path: launch-ready, blocked on client engagement.

## Client intake/deployment/baseline status

- Intake: placeholder + exact blocker (no client, no signed auth).
- Deployment: NOT executed; procedure + rollback steps documented.
- Baseline: sample (lab reference); coverage 100%, 0 exploitable vulns.
- Reports: phase12-client-intake-status.md, phase12-client-agent-deployment.md,
  phase12-client-baseline.md.

## Greenbone scheduled proof

- Schedule confirmed: MCT-lab-weekly-sun-0600 attached (id 09c42710, DTSTART
  2026-08-16T06:00Z, WEEKLY). Last report = manual proof (00aa2e0b, 00:57Z).
- **Scheduled run proof PENDING (timing blocker)** - first scheduled run due
  06:00 UTC today; verify after (steps documented in
  phase12-greenbone-scheduled-run-proof.md).

## Proxmox .222 capacity status

- 87.84% (WARN >= 85%, below ACTION 90). PV free 4.75G. 0 unused disks.
- Monitoring scripted: ops/scripts/proxmox-thinpool-report.sh (weekly report).
- Watch: vm-202 canary disk 90.9% - resize/reduce retention if > 95%.
- Runbook: ops/runbooks/proxmox-lab-capacity-management.md.

## Agent 009 disposition

- **REMOVED** (2026-08-16): phantom registration (ospd-openvas.local, never
  connected, no system carries it - Greenbone runs in containers on VM 103
  which has no agent).
- Coverage: 86% -> 100% (6 registered, 6 active, 0 never-connected).
- Reports: phase12-agent009-disposition.md, phase12-endpoint-counts-after-disposition.md,
  runbook: ops/runbooks/wazuh-agent-disposition.md.

## Windows tuning cycle

- Sysmon volume: 406 events/24h (EID 1/7/10), 4 channels collected.
- 88 level>=9 alerts/24h; FPs identified: VaultCli/taskhostw (60), Defender-Lsass
  (13). Suppression proposed (measurement-first, NOT applied).
- PS ScriptBlockLogging: not enabled (deferred). D1-D12 rules: backlog.
- Dashboards W1/W2: data ready. External Windows monitoring: not offered.
- Reports: phase12-windows-tuning-cycle.md, integrations/sysmon/phase12-pilot-rules.md,
  phase12-dashboard-w1-w2.md, reporting/output/internal/phase12-windows-readiness-report.md.

## Canarytoken T1 status

- BLOCKED: no hosted canarytokens.org account. OpenCanary assets validated
  (rules firing, Shuffle path HTTP 200). Procedure ready on account availability.
- Reports: phase12-canarytoken-t1-validation.md, phase12-token-inventory.md.

## Monthly ops run status

- 2nd dry run executed end-to-end (10 steps): health PASS, capacity 87.84%,
  backups valid (post-fix 146KB archives), endpoints 6/6, alert quality reviewed
  (FPs identified), vuln 0 exploitable, scorecard sample, billing 0 billable,
  comms ready, retrospective.
- Reports: phase12-monthly-ops-run.md, phase12-endpoint-billing-count.md,
  phase12-alert-quality-review.md, phase12-monthly-scorecard.md.

## Remaining risks

1. **No external client** - sales-ready kit ready; blocked on engagement.
2. **Git push pending** - local init only; operator approval + pre-push checklist required.
3. **Greenbone scheduled proof** - verify after 06:00 UTC 2026-08-16.
4. **Thin pool 87.84% WARN** - vm-202 canary 90.9% disk; PV headroom 4.75G only.
5. **Windows alert FPs** (VaultCli 60/24h, Defender-Lsass 13) - suppression proposed.
6. **DR S3 config bundle 403** - accepted local-only; keys required.
7. **Canarytoken T1** - hosted account blocker.
8. **PS ScriptBlockLogging + D-rules** - deferred until baseline stable.

## Recommended Phase 13 roadmap

1. **Git**: operator approval -> commit to main -> push -> enable CI on GitHub.
2. **First client**: present sales-ready kit; intake -> auth -> deploy -> baseline.
3. **Greenbone**: append scheduled-run proof; client scan workflow execution.
4. **Windows**: apply FP suppressions, re-measure, enable PS logging, build W1/W2.
5. **Capacity**: monitor vm-202; resize if needed; pool extension plan.
6. **DR S3**: obtain keys -> bundle SUCCESS -> full DR validation.
7. **Canarytoken T1**: create account -> validate chain.
8. **CI**: add shellcheck, markdown lint; scheduled bundle exports.

## Files added (summary)

- .github/workflows/verify.yml, scripts/ci/run-local-ci.sh, scripts/ci/build-release-bundle.sh,
  scripts/verify/github-prepush-check.sh, RELEASE-NOTES.md, release-manifest.json
- ops/scripts/proxmox-thinpool-report.sh, ops/runbooks/github-mainecybertech-soc-remote.md,
  ops/runbooks/proxmox-lab-capacity-management.md, ops/runbooks/wazuh-agent-disposition.md,
  ops/checklists/github-pre-push-checklist.md, ops/runbooks/phase12-change-control.md
- 18 phase12 reports under ops/reports/ + supporting docs in client-onboarding,
  service-packaging, reporting/output, integrations/sysmon, integrations/opencanary,
  integrations/dfir-iris, integrations/levelio

## No secrets

All reports cite paths/variable names only; no secret values printed.
