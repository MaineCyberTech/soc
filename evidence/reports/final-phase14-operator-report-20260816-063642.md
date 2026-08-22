> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# MCT Security Stack - Final Phase 14 Operator Report

Date: 2026-08-16
Pack: /home/user/mct-security-12 (Release, Client Ops, Code/Dependency/Resource Audits)
Stack root: /opt/mct-security-stack

## Executive summary

Phase 14 delivered the v1.0.0 GitHub release, first-client operations (agent
013 SAMSUNG: baseline, Sysmon/SCA validation, billing, scorecard cycle),
PROVEN the Greenbone scheduled run, and completed full code/dependency/
offline/resource audits. Major technical win: root-caused the Windows FP
suppression failure (rules were only on the master while agents analyze on the
worker; local_rules.xml loads before the ruleset) and deployed the fix to both
nodes. All audits PASS with tracked backlog. Healthcheck 0 FAIL. Repo on
GitHub with green CI (10 commits this phase incl. prior work).

## GitHub release status

- **v1.0.0 RELEASED**: https://github.com/MaineCyberTech/soc/releases/tag/v1.0.0
- Tag on commit cc4e389; release created via API (operator PAT, transient);
  portable bundle attached (544811 bytes).
- CI badge added to README; RELEASE-NOTES.md updated.
- CI: green on all commits.

## Client 013 baseline

- SAMSUNG (Windows 11 Pro 10.0.26200), agent 013, ACTIVE, windows-clients,
  node worker01 (rebalanced from manager).
- 24h: 1,295 events (Sysmon 175: EID 7=148, EID 1=27; Security/System/App).
- No actionable threats. Baseline script: ops/scripts/client013-baseline-report.sh.
- Reports: phase14-client013-baseline.md, client013-baseline-*.md.

## Client billing and scorecard status

- Billing: 1 billable endpoint from 2026-08-16 (phase14-client-billing-record.md,
  phase14-billing-baseline.md). Internal 6 excluded.
- Scorecard: 30-day cycle started (2026-08-16 to 2026-09-15); starter +
  template ready (phase14-client-scorecard-start.md, templates/phase14-client-scorecard.md).

## Windows Sysmon/SCA validation

- Sysmon validated: channel flowing post-shared-config-fix (175/24h, EID 1+7).
- All 4 Windows channels flowing (Sysmon 175, Security 35, System 30, App 27).
- SCA validated: 3 CIS Windows 11 benchmark summaries, classified informational.
- Reports: phase14-client013-sysmon-validation.md, phase14-client013-sca-validation.md.

## Windows FP remeasure

- **ROOT CAUSE FOUND + FIXED**: suppressions were deployed ONLY to the master;
  agents 012/013 analyze on WORKER01. Also: local_rules.xml loads BEFORE the
  ruleset (if_sid/overwrite ineffective there).
- FIX: custom_rules/suppressions.xml (121105 VaultCli, 121106 Defender-Lsass,
  field-scoped) + `<rule_dir>etc/custom_rules</rule_dir>` after ruleset on BOTH
  master + worker. Loaded 0 errors.
- Validation: both Windows agents idle since fix - final alert-level proof
  pending next events; 7-day re-measure running (phase14-windows-fp-remeasure.md).

## Greenbone scheduled proof

- **PROVEN**: report a2020145-41a5-4d89-a6e1-b6b4b4bd65c4 created
  2026-08-16T06:00:00Z (exact schedule), scan Done 100%, 1 host, 14 info
  findings, 0 critical/high. MCT-Critical-to-Shuffle correctly silent.
- Weekly recurrence confirmed (next 2026-08-23 06:00 UTC).
- Reports: phase14-greenbone-scheduled-run-proof.md,
  phase14-lab-vulnerability-review.md.

## Level.io production readiness

- Hardened with 013 lessons: node-aware deployment, Sysmon group config,
  custom_rules on all nodes, production rollout checklist.
- CI: levelio variable tests added to local CI (4/4 PASS).
- Reports: phase14-levelio-production-hardening.md + known-good windows/linux
  rollout docs + checklist.

## Code audit findings

- 66 sh (bash -n) + 245 py (py_compile): 0 failures. verify.yml valid YAML.
- Categories: correctness/idempotency/secret/error/logging/paths/dry-run/
  ports/architecture - all PASS.
- Backlog: 3 ps1 need runtime validation (no pwsh), shellcheck/markdown lint
  optional. Reports: phase14-code-audit.md, -backlog, -script-syntax-results.

## Dependency audit findings

- Categories complete: included/generated/OS-pkg/docker/external/excluded.
- 25 docker images (some `latest` - digest pinning backlog), endpoint assets
  (wazuh 4.14.7, sysmon, velociraptor v0.77.2, osquery), pip (pymisp, requests).
- Docs: docs/DEPENDENCIES.md + portability matrix.
- Reports: phase14-dependency-audit.md, phase14-portability-completeness-matrix.md.

## Offline/vendor/cache plan

- Cacheable: docker images (save/load), endpoint assets, ISO media, pip bundle.
- Must stay external: Windows ISO (EULA), image layers until cached.
- Checksum manifest created (repo-artifact-cache-manifest.example.json).
- Docs: docs/OFFLINE-INSTALL.md, docs/EXTERNAL-ARTIFACTS.md.
- Report: phase14-offline-vendor-cache-plan.md.

## Low-resource audit and profiles

- Host: 15Gi RAM (4.4Gi avail), disk / 65%, swap draining.
- Top: 3x indexer 1.8Gi, shuffle-opensearch 1.3Gi, elastiflow 830Mi.
- Disk: ES snapshot repo 13G (retention backlog), backups 4.4G, indices ~11G.
- Profiles: lab/pilot, production minimal, expansion (acceptance-gated).
- Report: phase14-low-resource-audit.md, docs/LOW-RESOURCE-PROFILES.md,
  ops/scripts/resource-efficiency-report.sh + runbook.

## Proxmox capacity

- 87.84% WARN, FLAT 5 checks. vm-202 90.95% (+0.03% negligible).
- Report: phase14-proxmox222-capacity-watch.md.

## DR S3 status

- Data tier HEALTHY: 37 S3 snapshots, latest 05:47 today, all SUCCESS.
- Config bundle 403 (stale creds.env keys) - accepted local-only risk; refresh
  procedure ready. Report: phase14-dr-s3-risk-review.md.

## Canarytoken T1

- BLOCKED: no hosted canarytokens.org account (unchanged). Reports:
  phase14-canarytoken-t1-validation.md, phase14-token-inventory.md.

## Monthly ops client-aware run

- First client-aware cycle: health PASS, capacity stable, backups valid,
  7 agents (6 internal + 1 client), client alerts no threats, Greenbone proven,
  scorecard started, billing 1 endpoint.
- Reports: phase14-monthly-ops-client-aware-run.md, phase14-monthly-scorecard.md.

## Remaining risks

1. **FP suppression final validation** - rules deployed both nodes; proof
   pending next Windows events (7-day re-measure).
2. **DR S3 config bundle 403** - accepted; new DO keys needed.
3. **ES snapshot repo growth** (13G) - retention policy backlog.
4. **latest docker tags** - digest pinning backlog.
5. **Canarytoken T1** - hosted account blocker.
6. **Client scan authorization** - not yet signed.
7. **Windows dashboards W1/W2** - UI build (operator).
8. **Thin pool 87.84% WARN** - stable; vm-202 watch.

## Recommended Phase 15 roadmap

1. **Windows FP validation**: confirm suppression on next real events; complete
   7-day re-measure; build W1/W2 dashboards; then PS ScriptBlockLogging.
2. **Client ops**: signed scan authorization -> Greenbone client schedule ->
   first full monthly scorecard (2026-09-15) -> first invoice.
3. **DR S3**: obtain keys -> config bundle SUCCESS -> full DR validation.
4. **Dependency hardening**: digest-pin docker images; requirements.txt + pip
   cache; ES snapshot retention policy.
5. **Capacity**: weekly thin-pool reports; ES snapshot rotation.
6. **Canarytoken T1**: hosted account -> validate chain.
7. **CI**: add levelio harness to GitHub Actions (Windows runner), shellcheck.
8. **Offline**: build vendor cache per plan; DR restore rehearsal.

## Files added (summary)

- Reports: 20+ phase14-*.md under ops/reports/.
- Scripts: client013-baseline-report.sh, resource-efficiency-report.sh.
- Docs: docs/DEPENDENCIES.md, docs/OFFLINE-INSTALL.md, docs/EXTERNAL-ARTIFACTS.md,
  docs/LOW-RESOURCE-PROFILES.md, repo-artifact-cache-manifest.example.json.
- Client: billing record, scorecard start, onboarding summary, monthly scorecard.
- Level.io: known-good rollouts (win/linux), production checklist.
- Sysmon: pilot suppressions final (custom_rules), dashboard readiness.
- Ops: resource-efficiency-tuning.md runbook, master checklist.

## No secrets

All reports cite paths/variable names only; no secret values printed.
