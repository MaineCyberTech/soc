> **HISTORICAL EVIDENCE (2026-08-11).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# MCT Security Stack - Final Phase 6 Operator Report

Date: 2026-08-11
Pack: /home/user/mct-security-4 (Phase 6 Infrastructure Remediation)
Wazuh root: /opt/wazuh-docker/multi-node
Phase root: /opt/mct-security-stack

## Executive summary

Phase 6 executed all 17 prompts. **Major win: Velociraptor client-server path
FIXED and D7 completed (PASS)** — the Phase 2 port conflict (Portainer owned
8000) was resolved by rebinding to 8002, and three client-config defects
(server_urls SAN, CA mismatch, nonce mismatch) were diagnosed and fixed; test
client C.ef79f1598cca19a9 enrolled and executed a flow (evidence stored).
Also completed: truthful health-check selftest, OpenSearch archives DECISION
(Option B - local+SO retention, storage-bound), backup cron first-run
verification (manual PASS; automated runs pending schedule), Client Zero
posture review (GOOD), external client readiness package, and precise blocker
documentation for PVE (401), RAM (not added), credentials (no new values),
Greenbone schedules (GMP CLI missing), canary VM + Windows VM (PVE blocked),
Canarytokens (no service).

## Starting state

- Phase 5 quick fixes active (gateway allowed, crons installed, noise suppressed).
- Blockers: PVE API 401, Velociraptor port conflict, P1 creds deferred,
  Greenbone schedules pending, canary/Windows VMs blocked, archives decision open.

## PVE API status

- **BLOCKED** - stored credentials 401 (all realm variants); SSH keys denied.
- pve-api-healthcheck.sh created (fails truthfully: 8006 reachable, auth FAIL).
- 3 unblock paths documented (refresh password / API token / SSH key).
- Manual VM provisioning bypass documented (requires one unblock path).

## Memory/RAM status

- RAM: 9.3 GiB (unchanged); swap 4.7 GiB used; disk 82%.
- phase6-resource-validation.sh correctly FAILs (no change applied).
- PVE VM101 memory change runbook + operator steps documented.
- RAM increase pending PVE access (operator action).

## Velociraptor/D7 status

- **FIXED + D7 PASS**:
  - Port rebind 8000(Portainer) -> 8002; server.pem 200.
  - Client config fixes: server_urls (cert SAN VelociraptorServer),
    ca_certificate (copy from server), nonce (copy from server), /etc/hosts entry.
  - Client C.ef79f1598cca19a9 enrolled; /reader + /control HTTP 200;
    flow F.D9TR4TO1N2RC2 (Generic.Client.Stats) collected + completed.
  - Evidence export + IRIS attach workflow documented.
- Remaining (not blockers): GUI admin password not set; production clients
  need cert-matching DNS.

## Credential rotation status

- **ALL P1 DEFERRED** - no new protected values supplied (files unchanged since Aug 7-9).
- Framework validated PASS (rotation-validation 6/6, postcheck).
- Precise blocker: operator must supply new values; then one-at-a-time rotation.

## Greenbone/D5 status

- Admin credential present (GREENBONE_ADMIN_PASSWORD in .env); gvmd healthy.
- **GMP CLI not installed on VM103** - schedule creation via GSA UI (documented).
- D5: component-PASS (webhook infra verified); last hop = Greenbone alert object
  (operator via GSA).
- Schedule config (MCT-core-infra-monthly) + critical-alert-to-shuffle documented.

## Canary VM status

- **BLOCKED** - PVE API 401 + no SSH key (same unblock required).
- Build/operations/config/alert-path docs finalized (qm create 110 commands ready).

## Canarytokens status

- **BLOCKED** - no canarytokens service (hosted account pending / self-hosted
  needs VM). Inventory + lifecycle docs ready; webhook path exists.

## Windows Sysmon pilot status

- **BLOCKED** - no Windows endpoint (PVE 401).
- Server side READY: Velociraptor 8002 validated with Linux client; Sysmon agent
  group config + validation queries + install docs ready.
- Dashboard/saved-search/report backlog defined (pending first data).

## Client Zero posture review

- **GOOD** - 4/4 agents, 2,062,690 alerts/30d (Class A 450), 9 canary hits
  (investigated, no compromise), backups PASS, noise suppression holds,
  Velociraptor fixed. Scorecards regenerated (client + internal).

## OpenSearch archives decision

- **DECISION: Option B (accept local + Security Onion retention)**.
- Rationale: Option A adds 4-8 GB/day; disk at 82% -> full in <3 days.
- Warning documented: `wazuh-archives-*` NOT trustworthy (stale); health-check
  uses local archives freshness (PASS).
- Revisit when disk >= 60% free or archive search required (Option A plan
  prepared: bind-mounted filebeat.yml).

## Backup cron first-run verification

- Cron installed (6 jobs) + manual verification PASS (IRIS 36K, MISP 149MB,
  Greenbone 1.8GB, Shuffle 30KB, freshness PASS, prune --apply 0-pruned, all
  files gzip/JSON readable).
- First AUTOMATED daily run due tomorrow 04:30 (pending by schedule timing);
  weekly runs next Sunday. Verification checklist + troubleshooting runbook written.

## DR scratch restore status

- **READY but deferred** - resources sufficient except RAM headroom (~1 GB free).
- Executable plan documented (scratch OpenSearch 19200, snapshot copy, restore
  order, validation checks, cleanup). Execute after RAM increase.

## External client readiness

- **READY** - 5 documents: readiness checklist, minimum monitoring package,
  vuln scan authorization, canary authorization, first-30-days.
- Prereq for client #1: PVE access, Greenbone schedules, credential rotation.

## Remaining risks

1. PVE access blocked (401) - blocks RAM increase, canary VM, Windows VM.
2. RAM 9 GiB / swap 4.7 GiB - OOM risk under load spikes.
3. P1 credentials deferred (no new values).
4. Greenbone schedules + D5 alert not created (GMP CLI missing on VM103).
5. Disk 82% - archive decision mitigates (Option B); snapshot/backup growth monitored.
6. Velociraptor GUI admin password not set.
7. Canarytokens service not provisioned.
8. Backup cron automated first-run unverified (pending schedule timing).

## Recommended Phase 7 roadmap

1. **Operator unblocks PVE** (refresh creds/API token/SSH key) - unblocks 4 blockers.
2. **Add RAM to VM101** (16-24 GiB) - then execute DR scratch restore test.
3. **Set Velociraptor GUI admin password** - launch Generic.Client.Info hunt,
   complete D7 evidence export to IRIS formally.
4. **Rotate P1 credentials** one at a time (framework ready).
5. **Greenbone**: install GMP CLI on VM103 (or use GSA), create schedule +
   critical alert; first scan + vulnerability review; complete D5.
6. **Build mct-canary01** + deploy first Canarytokens; validate Class A path.
7. **Provision Windows 11 pilot VM** - Sysmon + Velociraptor pilot; 2-week tune-in.
8. **Install GMP tooling + schedules**; run first client-facing vulnerability review.
9. **First external client**: intake -> agents -> baseline -> first scorecard.
10. **Revisit archives Option A** after storage expansion (add disk or S3-only snapshots).

## Files added (summary)

- ops/reports/: phase6-preflight, phase6-blocker-matrix, pve-api-validation,
  phase6-memory-before/after, velociraptor-port-rebind-validation,
  d7-velociraptor-final-pass, phase6-p1-credential-rotation-results,
  greenbone-vm103-admin-validation, d5-greenbone-critical-final-pass,
  greenbone-first-scan-results, mct-canary01-build-validation,
  canarytokens-phase6-validation, windows11-sysmon-pilot-vm, sysmon-pilot-validation,
  sysmon-dashboard-readiness, client-zero-posture-review-phase6,
  opensearch-archives-decision, phase6-backup-cron-first-run,
  phase6-backup-prune-verification, dr-scratch-restore-readiness/results,
  external-client-readiness, final-phase6-operator-report (this file)
- ops/scripts/: healthcheck-selftest.sh, pve-api-healthcheck.sh, phase6-resource-validation.sh
- ops/runbooks/: phase6-change-control, pve-api-repair, manual-vm-provisioning-bypass,
  pve-vm101-memory-change, velociraptor-port-rebind, phase6-p1-credential-rotation-execution,
  mct-canary01-operations, canarytokens-lifecycle, backup-cron-troubleshooting,
  dr-scratch-restore-execution, wazuh-archives-shipping-options
- integrations/: velociraptor/client-config-port-8002 + d7-evidence-export,
  greenbone/phase6-schedule-config + critical-alert-to-shuffle,
  opencanary/mct-canary01-running-config + mct-canary01-alert-path + canarytokens-phase6-deployed,
  sysmon/windows11-pilot-install + sysmon-event-validation-results +
  sysmon-dashboard-backlog-phase6 + sysmon-saved-search-backlog,
  velociraptor/windows11-client-checkin, wazuh/custom-filebeat-archives-plan +
  archives-local-so-retention-plan
- reporting/output/: client/client-zero-scorecard-phase6.md,
  internal/client-zero-posture-review-phase6.md
- reporting/templates/: windows-sysmon-pilot-summary.md
- client-onboarding/: external-client-readiness-checklist, minimum-monitoring-package,
  external-client-vuln-scan-authorization, external-client-canary-authorization,
  external-client-first-30-days
- checklists/: phase6-credential-rotation-verification, dr-scratch-restore-checklist

## No secrets

All reports cite paths/variable names only; no secret values printed.
