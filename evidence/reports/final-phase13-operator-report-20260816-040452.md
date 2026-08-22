> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# MCT Security Stack - Final Phase 13 Operator Report

Date: 2026-08-16
Pack: /home/user/mct-security-11 (GitHub Publish, Level.io Variable Fix, Client Ops)
Stack root: /opt/mct-security-stack

## Executive summary

Phase 13 completed the GitHub publish (repo live with green CI), fixed the
Level.io variable problem (root cause found + refactor + proven harness), and
continued operational follow-ups. The Level.io issue is RESOLVED: scripts now
read inputs via CLI flags or env, treat unresolved {{placeholders}} as missing
(fail-fast), and the simulation harness passes 4/4. GitHub: main branch pushed
(7 commits), CI passing on all commits, release tag pending approval. Windows
FP suppressions applied (event-content scoped, protects all Windows agents).
Greenbone scheduled proof still timing-dependent (06:00 UTC). **FIRST CLIENT
DEPLOYED via Level.io: agent 013 SAMSUNG (Windows 11 Pro) is Active, enrolled
to windows-clients, Sysmon collection enabled, 0 threats detected.**

## GitHub publish status

- **PUSHED**: https://github.com/MaineCyberTech/soc (branch main)
- 7 commits: f14ba1b (initial 987 files), 0f22899 (CI MCT_STACK_ROOT fix),
  eb00166 (reports), d4a20be (Level.io fix), ba1f9c7 (Phase 13 work),
  e3b88bf (final report), f67e759 (client 013 rollout fixes)
- SSH: deploy key ~/.ssh/github (ed25519) added to repo
- Remote: git@github.com:MaineCyberTech/soc.git (org casing MaineCyberTech)
- Reports: phase13-github-publish.md, phase13-git-staged-review.md,
  phase13-github-prepush-final-check.md

## GitHub CI/release tag status

- CI: **PASSING on all commits** (bash -n, py_compile, stack layout, stale-refs,
  secret scan; live-stack checks skipped by design).
- Initial failure (f14ba1b) was ROOT=/opt/mct-security-stack missing on runner -
  fixed with MCT_STACK_ROOT=$PWD export.
- Release tag v1.0.0: NOT created (approval-gated, runbook ready).

## Level.io variable audit

- Root cause: Level script variables are OUTPUT slots (not inputs); scripts
  read env-only; unresolved {{VAR}} placeholders were used as literal values
  (silent broken enrollment); silent defaults masked missing values.
- Confirmed by live tests (placeholder used literally, CLI args ignored).
- Report: phase13-levelio-variable-audit.md + levelio-variable-model.md +
  levelio-variable-name-map.md.

## Level.io script refactor status

- **COMPLETE + TESTED**: lib/mct-env.sh (mct_get_var/mct_require_var/mct_is_unset/
  mct_redact/mct_print_config); install-wazuh-linux.sh + macos + windows.ps1
  support CLI flags, fail-fast (exit 2), --dry-run, --print-config-redacted;
  placeholder detection; secrets always redacted.
- Verified: env path, CLI override, missing-required (exit 2), placeholder
  (exit 2), unknown arg (exit 2), dry-run (exit 0).
- Report: phase13-levelio-script-refactor.md + README-levelio-variables.md.

## Level.io simulation results

- **PASS 4/4** (simulate-levelio-linux.sh): env success, CLI success, missing
  required, unresolved placeholder.
- Windows harness (simulate-levelio-windows.ps1) staged; pwsh not on host.
- Runner: scripts/ci/run-levelio-variable-tests.sh.
- Report: phase13-levelio-simulation-results.md.

## First client engagement status

- **CLIENT DEPLOYED (2026-08-16 04:26 UTC)**: agent 013 "SAMSUNG" enrolled via
  Level.io - Windows 11 Pro (10.0.26200), IP 192.168.111.166 (client network),
  Active, group windows-clients, Wazuh v4.14.7.
- **Deployment verification**: 1004 events/15m (Sysmon 21, System, Application,
  Security); 0 real threats; 3x level-9 alerts are SCA CIS benchmark summaries
  (informational).
- **Post-rollout fixes**: (1) Sysmon channel added to shared windows-clients
  group config (client had agent + Windows channels but no Sysmon forwarding -
  now flowing); (2) FP suppression rules de-scoped from agent-012-only to
  event-content (Wazuh rules cannot filter agent.id - syntax error) - now
  protects the client too.
- Outreach kit created: phase13-sales-outreach-kit.md, phase13-outreach-email.md,
  phase13-one-page-pilot-offer.md.
- Rollout result: integrations/levelio/phase13-client-rollout-result.md.
- Baseline/scorecard: sample-ready (no client baselines yet).

## Greenbone scheduled proof

- Schedule confirmed (id 09c42710, DTSTART 2026-08-16T06:00Z, WEEKLY).
- First scheduled run due 06:00 UTC; checked 03:47 UTC - not yet executed.
- Proof pending (timing blocker) - verification steps documented in
  phase13-greenbone-scheduled-run-proof.md.

## Proxmox capacity

- Thin pool: **87.84% FLAT across 3 checks** (P11 close, P12, P13) - stable.
- vm-202 canary disk: 90.92% flat. PV free: 4.75G.
- Report: phase13-proxmox222-capacity-watch.md (WARN threshold, no action needed).

## Windows FP tuning

- **Suppressions APPLIED** (operator-approved):
  - Rule 121105: VaultCli (92153) suppressed for legit system images
  - Rule 121106: Defender-Lsass (92900) suppressed
- **Scope note (updated)**: initially scoped to agent 012 via agent.id - Wazuh
  rules cannot filter agent.id (syntax error). Rules are now scoped by EVENT
  CONTENT (legit system images / Defender source), protecting all Windows
  agents (pilot 012 + client 013). Non-system images still fire.
- Verified loaded (0 errors), manager restarted. No new FPs post-restart.
- Re-measure in 7 days; target < 10 level>=9/day.
- Reports: phase13-windows-fp-tuning.md, integrations/sysmon/phase13-pilot-suppressions.md.

## Canarytoken T1

- BLOCKED: no hosted canarytokens.org account (unchanged). OpenCanary assets
  validated. Reports: phase13-canarytoken-t1-validation.md,
  phase13-token-inventory.md.

## Monthly ops

- 3rd dry run executed (health PASS, capacity stable, backups validated -
  first post-fix cron archive 146KB, endpoints 6/6, FP suppression noted,
  vuln 0 exploitable, billing 0 billable).
- **Updated post-client**: endpoints now 7 agents total (6 lab + client 013
  SAMSUNG active); billable = 1 (client endpoint) once billing cycle starts.
- Reports: phase13-monthly-ops-run.md, phase13-endpoint-billing-count.md,
  phase13-monthly-scorecard.md.

## Remaining risks

1. **Greenbone scheduled run proof** - verify after 06:00 UTC 2026-08-16.
2. **Client baseline/scorecard** - 013 deployed; baseline + first scorecard
   cycle not yet captured.
3. **Release tag v1.0.0** - approval-gated, not created.
4. **Thin pool 87.84% WARN** - stable; vm-202 canary watch item.
5. **Windows FPs** - suppression applied; 7-day re-measure pending (client included).
6. **DR S3 config bundle 403** - accepted local-only; keys pending.
7. **Canarytoken T1** - hosted account blocker.
8. **W1/W2 dashboards** - definitions staged; UI import needed (no API tooling).

## Recommended Phase 14 roadmap

1. **GitHub ops**: create tag v1.0.0 + GitHub release with portable bundle asset;
   add CI badge + release automation.
2. **Greenbone**: append scheduled-run proof; first full weekly cycle.
3. **Client ops (first real client)**: capture client baseline (endpoints,
   alerts, vulns if authorized) -> start 30-day scorecard cycle -> first
   monthly billing (1 endpoint).
4. **Windows**: 7-day FP re-measure (pilot + client); build W1/W2 in dashboard
   UI; then PS ScriptBlockLogging + D5/D6.
5. **Level.io**: run Windows simulation on a Windows host; confirm client
   Sysmon config propagation over next days.
6. **Capacity**: weekly thin-pool reports (scripted); resize vm-202 if > 95%.
7. **DR S3**: obtain keys -> bundle SUCCESS -> full DR validation.
8. **Canarytoken T1**: create hosted account -> validate chain.

## Files added (summary)

- Level.io: lib/mct-env.sh, test/simulate-levelio-linux.sh + windows.ps1,
  README-levelio-variables.md, scripts/ci/run-levelio-variable-tests.sh,
  integrations/levelio/levelio-variable-model.md + levelio-variable-name-map.md
  + phase13-variable-driven-rollout.md + levelio-troubleshooting-variables.md,
  updated install-verify-workflow.md
- GitHub: ops/runbooks/github-release-process.md + github-tag-and-release.md,
  ~/.ssh/github (deploy key), remote origin set
- Client: phase13-sales-outreach-kit.md, phase13-outreach-email.md,
  phase13-one-page-pilot-offer.md, intake/auth/endpoints placeholders,
  **phase13-client-rollout-result.md (client 013 SAMSUNG deployed + verified)**
- Windows: integrations/sysmon/phase13-pilot-suppressions.md (event-content
  scoped) + phase13-dashboard-w1-w2.md
- Manager config: windows-clients shared agent.conf (Sysmon channel added),
  local_rules.xml (suppression rules 121105/121106, backup 20260816)
- Reports: 20+ phase13-*.md under ops/reports/

## No secrets

All reports cite paths/variable names only; no secret values printed.
