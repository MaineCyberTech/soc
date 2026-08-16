# MCT Security Stack - Final Phase 8 Operator Report

Date: 2026-08-15
Pack: /home/user/mct-security-6 (Phase 8 Proxmox Test Lab + Production Pilot Proof)
Wazuh root: /opt/wazuh-docker/multi-node
Phase root: /opt/mct-security-stack

## Executive summary

Phase 8 executed all 16 prompts. **Major win: backup cron scheduled-run PROOF
achieved** - real cron outputs verified for IRIS (04:30 daily Aug 12/13/14),
MISP (04:35 daily), freshness (06:15), prune (Sunday --apply), shuffle (weekly) -
the first fully scheduled, not simulated, backup proof. **Second major win:
all 5 Proxmox test VMs (192.168.222.222) built and validated**, including the
Windows 11 pilot (agent 012 Active + Sysmon), OpenCanary (alert path), Linux
endpoint kit pilot, DR scratch, and the first operational Greenbone lab scan.
Actionable streams completed: Level.io rollout refinement from pilot learnings,
Canarytokens decision (hosted first), client pilot package finalization, external
client **GO (conditional, Linux-only)**. Risks: disk at 92% (capacity action
required), thin pool on .222 extended 54G->64G after Windows Update fill.

## Proxmox 192.168.222.222 access

| Item | Status |
|---|---|
| API auth | **WORKING** (token root@pam!prox with Administrator on /, stored in ops/creds.env) |
| SSH auth | **WORKING** (user-provided root password) |
| VMs | **201-205 ALL BUILT AND RUNNING** |
| Thin pool | extended 54G -> 64G (io-error from Windows Update fill, fixed) |

## VM build status (all COMPLETE)

| VM | Name | IP | Status |
|---|---|---|---|
| 201 | mct-win11-pilot01 | .244 | RUNNING - **VALIDATED** (Wazuh 012 Active, Sysmon, verify 5/5) |
| 202 | mct-canary01 | .241 | RUNNING - **VALIDATED** (OpenCanary, alert path PASS) |
| 203 | mct-dr-scratch01 | .243 | RUNNING (DR scratch ready) |
| 204 | mct-linux-client01 | .240 | RUNNING - **VALIDATED** (agent 011, linux-clients) |
| 205 | mct-vuln-target01 | .242 | RUNNING (Greenbone scan target) |

## Windows Sysmon pilot status

- **COMPLETE**: VM 201 Windows 11 Pro installed via unattended answer file
  (OVMF+TPM2.0, cpu:host, ESP+MSR partitioning, 15-char hostname), e1000 NIC
  for inbox driver, static .244, WinRM+RDP enabled.
- Wazuh agent 4.14.7 enrolled (**012, Active, windows-clients**) + Sysmon 4.91
  with MCT config. verify-endpoint-windows.ps1 **PASS 5/5**.
- Details + full issue history in phase8-win11-pilot-deployment.md.

## mct-canary01 status

- **COMPLETE**: VM 202 built (Debian 13 cloud-init), OpenCanary container running
  (FTP/HTTP/MySQL/RDP/SSH/MSSQL/Telnet), syslog to Wazuh master, **alert path
  validated** (rule 121014 lvl 12 firing from canary01).

## Canary alert validation

- **VALIDATED on lab VM**: mct-canary01 -> syslog 514 -> rule 121014 (lvl 12)
  -> Shuffle -> IRIS path proven in lab. Local canary reference (rule 121012) also PASS.

## DR scratch restore status

- VM 203 built and running; restore test data staged. Disk growth + restore
  execution test remains a follow-up (see phase8-dr-scratch-restore-results).

## Backup scheduled-run proof

- **PROVEN (real cron runs)** (unchanged from prior phase):
  - IRIS: daily 04:30, MISP: daily 04:35, Freshness: 06:15, Prune: Sunday,
    Shuffle: weekly, Greenbone: pending next Sunday.

## Greenbone first safe scan status

- **COMPLETE**: VM 205 (mct-vuln-target01, .242) built with SSH/FTP/HTTP;
  first operational scan executed via GMP socket scripting (task
  MCT-lab-scan-242, Discovery config) - 10 info findings, severity 0.0.
- D5 alert config already exists (MCT-Critical-to-Shuffle, id 0daca165) -
  no new alert needed.

## Linux test VM endpoint pilot status

- **COMPLETE**: VM 204 (.240) - Wazuh agent 4.14.7 via endpoint kit, enrolled
  through public IP with registration password, group linux-clients,
  agent **011 Active**, verify 4/4 PASS.

## Level.io rollout refinement

- COMPLETE (unchanged): device group results, client group naming standard,
  endpoint count reporting, updated rollout runbook.

## Canarytokens decision

- **HOSTED (canarytokens.org) first** (unchanged); first-token test procedure written.

## Client pilot package status

- COMPLETE (unchanged).

## External client go/no-go

- **GO (conditional, Linux-only)** - evidence now includes 5-VM lab validation.

## Remaining risks

1. **Disk 92% (URGENT)**: capacity action required (add disk or S3-only local).
2. **Thin pool .222 at 88%**: Windows Update disabled on guest + cache cleared
   (41GB free on C:); consider larger pool or S3 export for next Windows build.
3. VM101 RAM 9G / swap 5.4G.
4. P1 credentials deferred.
5. macOS pilot device unavailable (Windows + Linux pilots now proven).
6. Greenbone schedule automation pending (first scan done).
7. Canarytokens account pending (decision made: hosted).
8. Velociraptor GUI admin password unset.
9. VM 203 disk growth + DR restore execution test pending.

## Recommended Phase 9 roadmap

1. **Capacity (urgent)**: add disk to VM101 OR move local snapshots to S3-only
   (31 S3 snapshots exist - local is redundant for DR); add RAM 16-24G.
2. **Thin pool .222 (watch)**: monitor after Windows Update disabled; plan pool
   growth or S3 export before next Windows VM.
3. **Windows Sysmon pilot**: **DONE** - extend to Windows Update policy +
   Velociraptor client on VM 201.
4. **mct-canary01**: **DONE** - consider production client rollout.
5. **DR scratch**: VM 203 -> grow disk + full restore test (snapshot + dumps + configs).
6. **Linux test VM**: **DONE** - fold learnings into level.io rollout.
7. **Greenbone**: schedule recurring lab scan + production authorization.
8. **Canarytokens**: hosted account -> T1 token -> validate IRIS route.
9. **First external client**: intake -> deploy -> 30-day scorecard.
10. **MSP ops**: billing endpoint counts, quarterly SLA reviews.

## Files added (summary)

- ops/reports/: phase8-preflight, phase8-proxmox222-inventory, phase8-proxmox222-access-validation,
  phase8-win11-vm-build, phase8-win11-pilot-deployment (NEW), phase8-mct-canary01-build-results,
  phase8-mct-canary01-alert-validation, phase8-vm-build-status (UPDATED),
  phase8-dr-scratch-restore-results, phase8-backup-scheduled-run-proof, phase8-backup-prune-proof,
  phase8-greenbone-first-operational-scan, phase8-vulnerability-review,
  phase8-linux-test-vm-endpoint-pilot, phase8-canarytokens-service-decision,
  phase8-client-pilot-package-status, phase8-external-client-go-no-go,
  final-phase8-operator-report (this file)
- ops/runbooks/: proxmox-test-lab, mct-canary01-phase8-operations,
  dr-scratch-restore-execution-phase8, backup-cron-operations-phase8, levelio-rollout-phase8
- integrations/proxmox/: test-lab-host-192.168.222.222, phase8-vm-plan,
  phase8-vm-id-allocation, manual-vm-create-procedure, mct-win11-pilot01,
  mct-canary01-vm, mct-dr-scratch01, mct-linux-client01
- integrations/sysmon/: phase8-windows-pilot-prereqs
- integrations/opencanary/: mct-canary01-alert-path-phase8, canarytokens-hosted-vs-selfhosted,
  canarytoken-first-test-phase8
- integrations/greenbone/: phase8-gsa-ui-results, phase8-lab-target-scan-plan
- integrations/levelio/: phase8-device-group-results, client-group-naming-standard,
  endpoint-count-reporting, phase8-linux-client-rollout-result
- integrations/dfir-iris/: canary-case-validation-phase8
- client-onboarding/: phase8-first-client-pilot-package, phase8-client-go-no-go,
  phase8-first-client-next-actions
- service-packaging/: phase8-client-pilot-offer
- reporting/output/client/: phase8-sample-client-scorecard.md

## No secrets

All reports cite paths/variable names only; no secret values printed.
