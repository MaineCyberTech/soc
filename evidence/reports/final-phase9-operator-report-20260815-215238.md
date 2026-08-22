> **HISTORICAL EVIDENCE (2026-08-15).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# MCT Security Stack - Final Phase 9 Operator Report

Date: 2026-08-15
Pack: /home/user/mct-security-7 (Phase 9 Production Operations + First Client Launch)
Wazuh root: /opt/wazuh-docker/multi-node
Phase root: /opt/mct-security-stack

## Executive summary

Phase 9 executed all 16 prompts. **Capacity stabilized** (disk 63%, config backup
bug fixed, S3/dr-s3 gap identified). **Greenbone recurring schedule created and
validated** (weekly Sunday 06:00). **Canary alert path regression found and
FIXED** (remote syslog moved 514->15140; rule 121007 lvl 12 re-validated).
**Windows pilot advanced**: Sysmon channel collection enabled (was missing),
filebeat archives shipping enabled (Sysmon events now indexable), Velociraptor
client enrolled on VM 201 and a **safe hunt (Generic.Client.Info) completed**.
**Backup weekly verification done** with the config-backup CWD bug fixed.
**P1 credentials**: no new values supplied - rotation deferred; DO Spaces keys
confirmed stale for CLI use (snapshots still S3-backed). **First client launch
package finalized**; go/no-go remains **CONDITIONAL GO (Linux-only)** with
capacity/DR conditions. MSP billing + SLA artifacts created.

## Starting state

- Phase 8: lab VMs 201-205 validated, Windows pilot agent 012 + Sysmon,
  backup cron proof, client package ready.

## Capacity before/after

| Item | Before | After | Action |
|---|---|---|---|
| Root disk | 63-64% | 63% | stable (52G free) |
| Swap | 5.9G/8G (74%) | 5.9G (persistent) | RAM expansion recommended |
| Thin pool .222 | 88% | 88% stable | monitor (threshold script created) |
| Config backup | 45-byte empty archives | **145KB valid archives** | CWD fix in script |
| DR S3 bundle | 403 FAIL | 403 FAIL (open) | needs valid DO keys |
| OpenSearch | 9.1G indices | stable | - |

New scripts: disk-growth-report.sh, capacity-threshold-check.sh,
endpoint-count-report.sh (all tested).

## Snapshot retention and S3 policy

- Local: 41 snapshots (7d, every 5h) - KEEP as fast-recovery tier.
- S3: 34 snapshots (30d) all SUCCESS - durable DR tier (via indexer keystore).
- **dr-s3 config bundle FAILING (403)** - creds.env keys stale; configs remain
  local-only (dr-stage 88M). No deletion performed.

## Greenbone recurring schedule/report

- Schedule **MCT-lab-weekly-sun-0600** created + attached to task
  MCT-lab-scan-242 (weekly Sunday 06:00 UTC).
- Validation run: report 8eeb4a46, Done, 16 findings all severity 0.0.
- D5 alert **MCT-Critical-to-Shuffle** (severity >= 9.0 -> Shuffle webhook)
  verified active; correctly did not fire (no critical findings).

## Canarytoken T1 validation

- Shuffle webhook routing validated (success:true, execution b24d020d).
- **Token creation BLOCKED** on hosted canarytokens.org account (operator email
  required). Lifecycle + case workflow documented.

## Windows Sysmon tuning status

- Sysmon 4.91 running (48k channel records).
- **FIX: agent config lacked Sysmon channel** - added
  Microsoft-Windows-Sysmon/Operational; events confirmed flowing to master
  archives.json (492+ entries).
- **FIX: filebeat archives shipping was disabled** - enabled; Sysmon events
  now index to wazuh-archives (2.4GB backlog draining).
- Tuning backlog: PowerShell script block logging, LOLBin ProcessCreate,
  ImageLoad noise, rule/dashboard backlog (integrations/sysmon/).

## Velociraptor Windows hunt status

- Client enrolled on VM 201 (C.d0d09f675bd30e12, Windows 11 Pro 25H2).
- **Safe hunt Generic.Client.Info COMPLETED** (flow F.DA0DKGEQGT4GS, 26 rows:
  hostname, network, users).
- Fixes: UFW 8002 allow for lab subnet; API user phase9-hunt registered;
  service install with --config path.

## Backup weekly proof

- Daily: IRIS 04:30 OK, MISP 04:35 OK, snapshots (local+S3) SUCCESS, freshness PASS.
- Weekly: prune (Sun 06:00) retention correct; shuffle export OK;
  Greenbone dump present (next scheduled run Aug 16).
- **Config backup bug fixed** (CWD) - verified valid 145KB archive.

## P1 credential rotation status

- No NEW protected values supplied -> **rotation deferred** (one-at-a-time rule).
- DO Spaces keys STALE for s3cmd/CLI (403); snapshots unaffected (keystore).
- Validation script DO check flagged as weak (fix documented).

## First client launch package

- phase9-first-client-launch-package.md (scope, capability status)
- phase9-first-client-authorization-bundle.md (signed prereq)
- phase9-first-client-escalation-matrix.md
- service-packaging/phase9-first-client-offer.md

## Fulfillment runbook status

- ops/runbooks/first-client-fulfillment-runbook.md (intake -> offboard)
- ops/checklists/first-client-fulfillment-checklist.md
- ops/reports/phase9-first-client-fulfillment-readiness.md (CONDITIONAL GO)

## Client scorecard status

- reporting/output/client/phase9-first-client-sample-scorecard.md
- reporting/output/client/phase9-first-client-vulnerability-section.md
- reporting/output/internal/phase9-client-reporting-qa.md

## Billing endpoint count status

- 7 Wazuh agents (6 active), 5 Velociraptor clients.
- ops/scripts/endpoint-count-report.sh (tested).
- billing-endpoint-count-policy.md + monthly-billing-review-template.md.

## Quarterly SLA review template

- service-packaging/quarterly-sla-review-template.md
- reporting/templates/quarterly-security-review.md
- client-onboarding/quarterly-review-prep-checklist.md

## External client go/no-go

- **CONDITIONAL GO (Linux-only pilot)**, conditions: signed authorization,
  RAM expansion (recommended), DR S3 bundle fix-or-accept, Linux-only,
  no deception until T1.

## Remaining risks

1. **DR S3 config bundle 403** - config DR local-only; needs valid DO keys.
2. **Swap 74%** - RAM expansion recommended before client launch.
3. **Thin pool .222 88%** - Windows Update disabled on guest; monitor weekly.
4. **Filebeat archives backlog 2.4GB** - draining; Sysmon visibility delayed
   until caught up.
5. **Canarytokens account** - T1 blocked on operator email.
6. **P1 rotation** - deferred (no new values).
7. **Windows pilot tuning** - rule/dashboard backlog items pending.
8. **VM 203 DR restore test** - still pending (Phase 10).

## Recommended Phase 10 roadmap

1. **DR hardening**: fix DO Spaces keys -> dr-s3 bundle SUCCESS; run first
   full DR restore test on VM 203.
2. **Capacity**: RAM 16G; monitor thin pool; archive-backlog drain check.
3. **First client**: sign auth bundle -> deploy -> 30-day scorecard.
4. **Windows pilot tune-in**: enable PS script block logging, LOLBin rules,
   build windows-clients dashboards (post archives catch-up).
5. **Canarytokens T1**: create account -> token -> validate IRIS route.
6. **Greenbone productionization**: production scan authorization + first
   client scan; verify weekly schedule ran Aug 16.
7. **MSP ops**: first monthly billing run; first quarterly SLA review.
8. **Alert quality**: integrate generate-alert-quality-report.py into monthly.

## Files added (summary)

- ops/reports/: phase9-preflight, phase9-phase8-status-review, phase9-capacity-before/after,
  phase9-disk-growth-report, phase9-local-snapshot-retention-review, phase9-s3-snapshot-policy-review,
  phase9-greenbone-recurring-schedule, phase9-first-vulnerability-review, phase9-canarytoken-t1-validation,
  phase9-windows-sysmon-tuning, phase9-velociraptor-windows-hunt, phase9-backup-weekly-run-verification,
  phase9-backup-prune-verification, phase9-p1-credential-rotation, phase9-first-client-fulfillment-readiness,
  phase9-scorecard-finalization, phase9-endpoint-counts, phase9-external-client-go-no-go,
  final-phase9-operator-report (this file)
- ops/runbooks/: phase9-change-control, storage-expansion-vm101, vm101-ram-expansion-validation,
  local-snapshot-retention-policy, s3-snapshot-dependency-risk, phase9-backup-operations,
  phase9-p1-credential-rotation, first-client-fulfillment-runbook
- ops/scripts/: disk-growth-report.sh, capacity-threshold-check.sh, endpoint-count-report.sh
- ops/checklists/: phase9-credential-validation, first-client-fulfillment-checklist
- integrations/greenbone/: phase9-scheduled-scan-config, phase9-vulnerability-report-export,
  phase9-critical-alert-validation
- integrations/opencanary/: phase9-hosted-canarytokens, phase9-canarytoken-t1-lifecycle
- integrations/sysmon/: phase9-rule-backlog, phase9-dashboard-backlog
- integrations/velociraptor/: phase9-windows-hunt-results
- integrations/dfir-iris/: phase9-canarytoken-case-workflow, phase9-windows-evidence-to-iris
- client-onboarding/: phase9-first-client-launch-package, phase9-first-client-authorization-bundle,
  phase9-first-client-escalation-matrix, phase9-client-go-no-go, phase9-first-client-next-actions,
  quarterly-review-prep-checklist
- service-packaging/: phase9-first-client-offer, billing-endpoint-count-policy,
  monthly-billing-review-template, quarterly-sla-review-template
- reporting/output/client/: phase9-first-client-sample-scorecard, phase9-first-client-vulnerability-section
- reporting/output/internal/: phase9-client-reporting-qa, windows-pilot-telemetry-summary
- reporting/templates/: quarterly-security-review

## No secrets

All reports cite paths/variable names only; no secret values printed.
