# MCT Security Stack - Final Phase 7 Operator Report

Date: 2026-08-12
Pack: /home/user/mct-security-5 (Phase 7 Client Pilot + MSP Packaging)
Wazuh root: /opt/wazuh-docker/multi-node
Phase root: /opt/mct-security-stack

## Executive summary

Phase 7 executed all 18 prompts. Key results: endpoint deployment kit audited
(PASS, 10 files) and proven with a **Linux endpoint pilot PASS** (native agent
006 on this host: enrolled via public IP 142.105.190.25, verify 6/6 as root).
Velociraptor post-fix path validated with a **safe hunt executed**
(Generic.Client.Info, evidence exported; 3 clients enrolled). Backup cron jobs
**proven via exact-cron-command simulation** (IRIS/MISP/freshness/shuffle/prune
all exit 0; automated runs pending schedule timing). Full **MSP service
packaging** created (5 docs: packages, pricing matrix, deliverables, 30-day
runbook, SLA template). Client-ready scorecards generated (live). External
client decision: **GO (conditional - Linux-only first client)**.

## Starting state

- Phase 6 fixes active (Velociraptor 8002, health selftest, backup cron,
  registration password enforced).
- Blockers: PVE 401, RAM 9G, creds deferred, Greenbone GMP missing,
  Canarytokens/Windows/macOS pending.

## Operator unblock status

| Blocker | Status | Next action |
|---|---|---|
| PVE API/SSH | OPEN | 3 unblock paths (pve-api-repair.md) |
| VM101 RAM | OPEN | qm set 101 --memory 16384 |
| P1 credentials | DEFERRED | supply new values |
| Greenbone GMP/GSA | OPEN | GSA UI procedure documented (admin pw in .env) |
| Canarytokens | OPEN | hosted account choice |
| Windows endpoint | OPEN | provide device |
| macOS endpoint | OPEN | provide device |
| Velociraptor GUI pw | OPEN | velociraptor user set_password admin |

## Endpoint deployment kit audit

- **PASS** - 10 files present, 0 syntax errors, no embedded secrets, variables
  documented, prepare-velociraptor-client.sh verified (3rd client enrolled from
  generated config: C.fa6cb8dfabd3e4cb).
- Public IP enrollment verified (142.105.190.25, registration password enforced).

## Linux/macOS/Windows pilot status

| OS | Status | Evidence |
|---|---|---|
| Linux | **PASS** | docker-host (agent 006) native agent, Active, verify 6/6 (root), enrolled via public IP |
| macOS | BLOCKED | no device; installer ready (Intel+ARM) |
| Windows | BLOCKED | no device; installer + sysmon-mct.xml + agent group config ready |

Note: verify scripts require root (level.io Linux default) - client.keys/ossec.conf root-only.

## Velociraptor hunt validation

- **PASS** - safe hunt (Generic.Client.Info) executed, evidence exported
  (integrations/velociraptor/phase7-safe-hunt-results.json, 13KB), IRIS attach
  path documented. 3 clients enrolled with server-pushed monitoring flows.

## Greenbone first scan status

- gvmd healthy, GSA up (bound 127.0.0.1:443 - SSH tunnel access documented).
- Schedule creation + first scan = operator GSA action (gsa-ui-procedure.md).
- Critical alert config (MCT-critical-to-shuffle) documented.

## Canary/Canarytoken status

- Local OpenCanary validated (rule 121012 fired, Class A).
- Canarytokens + mct-canary01 blocked (service/VM pending).

## Backup scheduled-run proof

- 5 jobs executed with exact cron command + redirection: IRIS (36K), MISP
  (149MB), freshness (PASS), shuffle export (30KB), prune --apply (0 pruned).
- First automated runs: 04:30/04:35/06:15 UTC today (pending timing).
- Action items: confirm cron logs grew at 04:40/06:20; Sunday weekly runs.

## Credential rotation status

- ALL DEFERRED (no new protected values). Framework validated PASS.

## MSP service packaging status

- **COMPLETE** (5 docs, client-safe):
  service-packages.md (Starter/Standard + 4 add-ons),
  pricing-scope-matrix.md, client-deliverables.md,
  client-first-30-days-runbook.md, managed-security-sla-template.md.

## Client-ready scorecard status

- reporting/output/client/phase7-client-ready-scorecard.md (LIVE: 2,085,268
  alerts/30d, Class A 452, agents 4/4, canary 10, backups PASS).
- phase7-sample-external-scorecard.md (template).
- phase7-alert-quality-snapshot.md (internal, live).

## DR readiness status

- **READY-TO-EXECUTE (RAM-tight)**: 21 snapshots (latest snap-20260812-0017),
  IRIS/MISP/Greenbone dumps present, 19GB disk. Execute after RAM increase or
  on separate host.

## External client readiness decision

- **GO (conditional)**: Linux-only first client, with conditions:
  1) RAM increased, 2) Linux endpoints only, 3) scan authorization signed,
  4) Greenbone schedule created, 5) escalation verified.
- NO-GO for Windows-only / Sysmon-requiring clients until pilot devices exist.

## Remaining risks

1. PVE access (blocks RAM, canary VM, Windows/macOS VMs).
2. RAM 9G / swap 4.8G (OOM risk).
3. P1 credentials deferred.
4. Greenbone schedule + D5 alert pending GSA action.
5. No Windows/macOS pilot devices (client scope limited to Linux).
6. Canarytokens service pending.
7. Backup cron first automated run unverified (pending timing).
8. Disk 81%.

## Recommended Phase 8 roadmap

1. **Operator unblocks PVE** (SSH key fastest) -> RAM 16-24G, mct-canary01,
   Windows 11 VM.
2. **Windows Sysmon pilot** + **macOS pilot** on provided devices; Sysmon
   tune-in (2 weeks log-only).
3. **Set Velociraptor GUI admin password**; run full hunt suite; formal IRIS
   evidence workflow.
4. **Greenbone**: create schedule + critical alert via GSA; first scan +
   vulnerability review; complete D5 end-to-end.
5. **Rotate P1 credentials** (one at a time).
6. **Canarytokens**: provision service; deploy T1; validate IRIS route.
7. **Verify backup cron automated runs** (04:30/06:15 today; Sunday weekly).
8. **DR scratch restore execution** (post-RAM).
9. **First external client**: intake -> Linux agents via level.io -> baseline
   -> first scan -> 30-day scorecard.
10. **MSP ops**: billing-ready endpoint counts, quarterly SLA reviews,
    client-specific noise tuning.

## Files added (summary)

- ops/reports/: phase7-preflight, phase7-blocker-status, phase7-operator-unblock-status,
  phase7-endpoint-kit-audit, phase7-linux-endpoint-pilot, phase7-macos-endpoint-pilot,
  phase7-windows-sysmon-pilot, phase7-velociraptor-hunt-validation,
  phase7-greenbone-first-scan, phase7-vulnerability-review, phase7-canary-validation,
  phase7-backup-scheduled-run-verification, phase7-backup-prune-status,
  phase7-credential-rotation-complete, phase7-scorecard-generation-status,
  phase7-dr-readiness-review, external-client-readiness-review-phase7,
  final-phase7-operator-report (this file)
- ops/runbooks/: phase7-change-control, operator-unblock-checklist,
  levelio-endpoint-rollout, phase7-credential-rotation, backup-cron-operations,
  phase7-dr-scratch-restore-next-actions
- ops/checklists/: phase7-credential-validation, pve-api-and-ram-change
- integrations/levelio/: device-group-rollout-plan, encrypted-variable-plan,
  install-verify-workflow, uninstall-rollback-workflow, endpoint-kit-variable-map,
  linux-device-rollout-result, macos-device-rollout-result, windows-device-rollout-result
- integrations/velociraptor/: phase7-safe-hunt-results.md + .json,
  dfir-iris/velociraptor-evidence-to-iris-phase7
- integrations/greenbone/: gsa-ui-procedure, critical-alert-phase7-status
- integrations/opencanary/: canarytoken-first-test, mct-canary01-phase7-status
- integrations/sysmon/: phase7-windows-validation-results
- scripts/endpoint-deploy/: rollout-status.md
- service-packaging/: 5 documents
- reporting/output/: client/phase7-client-ready-scorecard + phase7-sample-external-scorecard,
  internal/phase7-alert-quality-snapshot
- client-onboarding/: external-client-go-no-go, first-client-pilot-plan

## No secrets

All reports cite paths/variable names only; no secret values printed.
