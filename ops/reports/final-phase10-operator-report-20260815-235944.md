# MCT Security Stack - Final Phase 10 Operator Report

Date: 2026-08-15
Pack: /home/user/mct-security-8 (Phase 10 DR Hardening + First Client Execution + Windows Telemetry Maturity)
Wazuh root: /opt/wazuh-docker/multi-node
Phase root: /opt/mct-security-stack

## Executive summary

Phase 10 executed all 15 prompts. **RAM expansion COMPLETE and validated** (the
balloon was capping VM101 at 10G despite 16G allocated - raised to 16G, guest
now sees 15.9G with 7G available; swap draining). **DR scratch restore EXECUTED
on VM203** (config bundle unpacked, IRIS dump fully restored to scratch Postgres
- 82 tables, MISP/Greenbone schemas validated, OpenSearch snapshot read path
validated; production untouched). **DR S3 config bundle**: fix attempted - no new
keys exist, so local-only config DR formally ACCEPTED for pilot (data DR fully
S3-backed: 35 snapshots). **First client**: launch STAGED - all stack conditions
MET/ACCEPTED, but no external client engaged (precise blocker: intake + signed
authorization). Deployment rehearsal PASSED internally (VM 204 verify 4/4).
**Windows telemetry matured**: agent 012 logcollector stall FIXED (preflight),
archive backlog confirmed CAUGHT UP, Sysmon events indexed (24k/day), detection
pack + saved searches + dashboard backlog created. **Canarytoken T1** remains
blocked (no hosted account; routing re-validated). Greenbone weekly proof pending
(first scheduled run 2026-08-16 06:00 UTC). P1 credentials deferred (no new
values). MSP monthly ops runbook + client communication templates created.

## Starting state

- Phase 9: SO reconfiguration (packet-ingestion feeding Wazuh), docs audit,
  DR 403 accepted-risk, client launch conditional, archives backlog draining.

## DR S3 config bundle status

- **LOCAL-ONLY ACCEPTED (fix blocked)** - no new DO Spaces keys supplied; the
  working keys are in the indexer's encrypted keystore (not retrievable).
- Data DR: fully S3-backed (35 snapshots, latest 2026-08-15 20:47).
- Config DR: local staging daily (config-20260815-040001.tar.gz) + git.
- Re-test procedure documented (do-spaces-key-rotation.md).

## DR scratch restore status

- **EXECUTED (PASS)** on VM203 (mct-dr-scratch01, .243):
  - VM203 disk grown 3G -> 30G.
  - Config bundle: unpacked, 75 files, valid.
  - IRIS dump: **fully restored to scratch Postgres** (82 tables, 1 case).
  - MISP dump: 113 tables schema validated.
  - Greenbone dump: 192 tables schema validated.
  - OpenSearch snapshots: SUCCESS (38 indices, 64 shards 0 failed), read path valid.
  - Cleanup complete; production untouched.
- Lessons learned + evidence checklist documented.

## RAM/capacity status

- **RAM EXPANDED + VALIDATED**: balloon 10G -> 16G (config + live). Guest
  MemTotal 9.3G -> 15.9G; free 135M -> 6.2G; available 7.0G. Swap draining
  (5.2G -> 4.9G). post-ram-health-validation.sh PASS (12 services).
- Disk: 66% (50G free). Thin pool .222: 88% (WARN, monitor).
- PVE host .187 at 30G/31G - no further growth without host RAM.

## First client launch status

- **STAGED - all stack conditions MET/ACCEPTED**:
  - RAM: MET (16G).
  - DR S3: ACCEPTED (local-only pilot).
  - Greenbone client scan workflow: ready (authorization-gated).
  - Deployment kit: rehearsal PASS.
- **Blocker (precise)**: no external client engaged - intake form empty, signed
  authorization requires a client.
- Launch decision + approved scope + intake docs created.

## First client agent deployment status

- **Internal rehearsal PASS** (VM 204 / agent 011, verify 4/4).
- Deployment kit ready (install/verify/uninstall/velociraptor-prep).
- External deployment pending client.

## First client baseline/scorecard status

- Internal reference baseline captured (alerts, agents, endpoints).
- Onboarding summary + scorecard-start templates created.
- 30-day cycle starts on client engagement.

## Windows archive catch-up and tuning

- **ARCHIVES CAUGHT UP** (2.4GB backlog drained; offset at file end).
- Agent 012 logcollector stall (21:00 UTC) FIXED - events flowing, indexed current.
- Sysmon indexed: 24k events/day (EID 7: 23k noise, 1: 358, 10: 11, 5: 653, 2: 8).
- Tuning report: ImageLoad noise (System32 DLLs), PowerShell logging not enabled,
  LOLBin ProcessCreate backlog.

## Windows detection/dashboard backlog

- Detection pack: 12 detections (D1-D12) across 7 categories - backlog, not deployed.
- Saved searches: S1-S10 defined.
- Dashboards: W1-W8 backlog (W1/W2 buildable now).
- No noisy rules deployed without measurement (safety).

## Canarytoken T1 status

- **BLOCKED** (no hosted canarytokens account/email - operator action).
- Shuffle webhook routing re-validated (execution afd4de3c, HTTP 200).
- Inventory + IRIS workflow documented.

## Greenbone weekly/client scan workflow

- Schedule MCT-lab-weekly-sun-0600 confirmed; first scheduled run due
  2026-08-16 06:00 UTC (today is Aug 15) - proof pending timing.
- Client scan authorization + target group procedure + vuln review template created
  (authorization-gated).

## P1 credential status

- No new protected values - ALL rotations DEFERRED.
- Wazuh admin / Cloudflare / S3 snapshots validated working.
- DO Spaces CLI keys stale (403) - accepted local-only for pilot (P10.02).

## MSP monthly ops runbook status

- msp-monthly-operations.md: 10-step monthly workflow.
- monthly-msp-ops-checklist.md: checklist.
- monthly-service-review-flow.md: flow diagram + gates.

## Client communication templates

- 7 client-safe templates created (kickoff, deployment notice, scan auth,
  baseline, scorecard delivery, incident notification, pilot review).

## Remaining risks

1. **DR S3 config bundle 403** - accepted local-only; needs operator keys.
2. **No external client engaged** - launch staged, waiting on intake.
3. **Thin pool .222 88%** - monitor (Windows Update still disabled on guest).
4. **Canarytokens account** - T1 blocked.
5. **P1 rotation** - deferred (no new values).
6. **Greenbone weekly proof** - verify after 2026-08-16 06:00 run.
7. **Windows detection rules** - not deployed (measurement-first backlog).
8. **PowerShell script block logging** - not enabled on pilot.
9. **PVE host RAM** - 30G/31G; no growth headroom.

## Recommended Phase 11 roadmap

1. **Greenbone weekly proof**: verify first scheduled run (2026-08-16 06:00 UTC);
   export report; confirm D5 alert on critical.
2. **First client**: engage external client -> intake -> signed authorization ->
   deploy -> baseline -> 30-day scorecard cycle.
3. **DR S3**: obtain DO Spaces keys -> fix dr-s3 bundle -> full DR validation.
4. **Full OpenSearch scratch restore**: stand up scratch indexer on VM203;
   restore 1-2 indices from snapshot (real restore test).
5. **Windows telemetry**: enable PS ScriptBlockLogging on pilot; deploy D1-D4/D7/D10
   to pilot, measure 7 days, promote to windows-clients; build W1/W2 dashboards.
6. **Canarytoken T1**: create hosted account -> token -> validate IRIS path.
7. **Capacity**: monitor thin pool + disk; PVE host RAM review for growth.
8. **MSP ops**: first monthly cycle execution (scorecard + billing + comms).
9. **MISP/Greenbone full scratch restores** (postgres/mariadb now on VM203).

## Files added (summary)

- ops/reports/: phase10-preflight, phase10-phase9-status-review, phase10-dr-s3-bundle-fix,
  phase10-dr-config-bundle-validation, phase10-dr-scratch-restore-results,
  phase10-ram-before-after, phase10-first-client-launch-decision,
  phase10-first-client-agent-deployment, phase10-first-client-baseline,
  phase10-windows-pilot-tuning-results, phase10-sysmon-archive-catchup,
  phase10-windows-detection-pack-status, phase10-canarytoken-t1-validation,
  phase10-greenbone-weekly-run-proof, phase10-p1-credential-rotation-status,
  final-phase10-operator-report (this file)
- ops/runbooks/: phase10-change-control, do-spaces-key-rotation, dr-restore-lessons-learned,
  ram-risk-acceptance-for-client-pilot, phase10-credential-rotation, msp-monthly-operations
- ops/scripts/: post-ram-health-validation.sh
- ops/checklists/: phase10-dr-restore-evidence-checklist, phase10-credential-validation,
  monthly-msp-ops-checklist
- integrations/do-spaces/: dr-s3-config-bundle-status
- integrations/proxmox/: vm203-dr-scratch-execution
- integrations/sysmon/: phase10-windows-detection-pack, phase10-windows-saved-searches,
  phase10-windows-dashboard-backlog
- integrations/levelio/: phase10-first-client-rollout-result
- integrations/opencanary/: phase10-hosted-token-inventory
- integrations/greenbone/: phase10-client-target-group-procedure
- integrations/dfir-iris/: phase10-canarytoken-case-workflow
- client-onboarding/: phase10-first-client-intake-complete, phase10-first-client-approved-scope,
  phase10-first-client-endpoint-inventory, greenbone-client-scan-authorization,
  templates/ (7 email templates)
- reporting/output/client/: phase10-first-client-onboarding-summary,
  phase10-first-client-scorecard-start
- reporting/output/internal/: phase10-windows-telemetry-summary
- reporting/templates/: client-vulnerability-review
- service-packaging/: monthly-service-review-flow

## No secrets

All reports cite paths/variable names only; no secret values printed.
