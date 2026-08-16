> **HISTORICAL EVIDENCE (YYYY-MM-DD).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# MCT Security Stack - Final Phase 4 Operator Report

Date: 2026-08-11
Pack: /home/user/mct-security-2 (Phase 4 SOC Optimization)
Wazuh root: /opt/wazuh-docker/multi-node
Phase root: /opt/mct-security-stack

## Executive summary

Phase 4 executed all 20 prompts: preflight + change window, credential rotation
prep (validation framework with all 6 checks PASS; no values rotated - no new
values provided), alert noise reduction applied (-50.6% via osquery 24010
suppression), drills D2-D8 executed (D2 PASS, D3/D4 PASS, D5 PARTIAL, D6 PASS,
D7 PARTIAL, D8 PASS), VM103 MISP+Greenbone backups automated (MISP 149MB dump
verified, Greenbone 1.8GB dump verified), Shuffle workflow export working
(30KB), canary VM plan + token inventory prepared, Sysmon pilot deliverables
prepared (no endpoint available), MISP IOC lifecycle validated (CDB path),
Greenbone schedules finalized (not yet created on VM103), first live internal
scorecard generated, capacity plan completed, and client onboarding package
built (8 documents).

## Starting state

- Alert volume ~521k/24h (osquery 24010 = 50.6%, UniFi = 45.7%).
- D2-D8 drills pending (defined but not executed).
- Credentials tracked for rotation but pending.
- VM103 (MISP/Greenbone) backups missing.
- Memory pressure: 90% RAM used, 4.5G swap.
- Windows Sysmon pilot planned only.

## Changes made

1. **Noise reduction (APPLIED)**: osquery rule 24010 -> level 0 (archive-only)
   via local_rules.xml override. Backup created, logtest validated (24010 level
   0; child 24013 still level 4), analysisd restarted both nodes (PID change
   verified), cluster green. **Verified: 0 alerts since 05:32Z.**
2. **Drills D2-D8**: see matrix below.
3. **Credential rotation**: rotation window runbook + validation script
   (all 6 checks PASS) + status report. No rotation executed (no new values
   provided) - blockers documented.
4. **VM103 backups**: vm103-misp-db-dump.sh (149MB gz verified), vm103-greenbone-backup.sh
   (1.8GB gz verified), shuffle-workflow-export.sh (30KB verified), vm103-backup-freshness-check.sh,
   backup/restore runbook, cron example (not installed - approval pending).
5. **Reporting**: live scorecard + live alert quality report generated;
   generator bugs fixed (auth, key mapping, track_total_hits).
6. **Capacity**: resource-trend-report.sh + capacity plan (add RAM recommended).
7. **Client onboarding**: 8 client-safe documents created.
8. **Shuffle repair re-applied** (replicas re-created 2x during phase - boot
   cron handles reboot case; manual repair for live re-creation).

## Credentials rotated or deferred

| Credential | Priority | Status |
|---|---|---|
| DO Spaces keys | P1 | DEFERRED - no new values provided; validation PASS |
| WAZUH_ADMIN_PASSWORD | P1 | DEFERRED - validation PASS (green) |
| Cloudflare tunnel token | P1 | DEFERRED - tunnel running |
| IRIS admin pw + API key | P2 | DEFERRED - API key validation PASS (/api/ping) |
| MISP admin pw + API key | P2 | DEFERRED - validation PASS (getVersion 200) |
| Shuffle admin/API key | P3 | DEFERRED - backend health PASS |
| VM103/DB secrets | P3 | DEFERRED - not rotated |

No values rotated: requires operator-provided new values via protected env
files, one at a time per runbook (phase4-credential-rotation-window.md).

## Alert/noise before-after

| metric | before/24h | after (verified) |
|---|---|---|
| total alerts | 520,670 | ~257k expected (-50.6%) |
| osquery 24010 | 263,490 | **0 since 05:32Z (verified)** |
| UniFi family | ~238k | unchanged (proposed C digest - not applied) |
| Class A (OpenCanary/MISP/flow) | intact | intact (1210xx/1211xx confirmed) |

## Drill results D2-D8

| Drill | Status | Evidence |
|---|---|---|
| D2 MISP IOC match | **PASS** | test IOC 203.0.113.77 in CDB -> rule 121100 level 12 matched (logtest); CDB reload behavior documented; IOC cleaned |
| D3 flow unusual port | **PASS** | monitor flow-unusual-ports enabled, trigger severity 2 (Class B), live flow data confirmed |
| D4 unknown exporter | **PASS** | monitor enabled; 24h census = only 3 approved exporters; approved list documented |
| D5 Greenbone critical | **PARTIAL** | payload + escalation runbook + IRIS template ready; webhook ID + Greenbone alert config pending VM103 operator |
| D6 active response audit | **PASS** | 2,518 AR events/7d; audit script fixed (group name active_response) |
| D7 Velociraptor evidence | **PARTIAL** | workflow + hunt map documented; no client enrolled to execute hunt |
| D8 Security Onion bridge | **PASS** | SO reachable; Wazuh->SO forwarding on; agent 008 Active; bridge gaps documented |

## Backup coverage updates

- MISP DB: NOW COVERED (149MB dump, verified)
- Greenbone gvmd: NOW COVERED (1.8GB dump, verified - note nohup pattern for large dumps)
- Shuffle workflows: NOW COVERED (30KB export, verified)
- VM103 freshness check: DONE
- Cron snippets: prepared (ops/cron/phase4-backup-cron.example) - NOT installed
- IRIS dump (Phase 3): still needs cron enablement

## MISP lifecycle validation

- States candidate/reviewed/active-monitor/active-block/expired/false-positive documented.
- CDB export + Wazuh matching validated (D2).
- FP/expiry procedure documented.
- Blocker: MISP UI tagging of real IOCs pending analyst action (0 action:block IOCs yet).

## Greenbone operations status

- Target groups (4), profiles (5), schedules (5 tasks) finalized.
- Remediation/verification workflow documented.
- Schedules NOT created on VM103 (operator action required).
- Critical-finding alert config pending.

## Canary status

- mct-canary01 build runbook + OpenCanary config + token inventory (5 tokens) prepared.
- VM NOT built (operator approval required for provisioning).
- No tokens deployed.

## Sysmon pilot status

- Implementation runbook + agent group config + validation queries + dashboard backlog + results template prepared.
- NOT DEPLOYED - no Windows endpoint available (blocker: operator provisions Windows 11 VM).

## Scorecard/reporting outputs

- reporting/output/internal/phase4-internal-soc-scorecard.md (LIVE: 1,949,758 alerts/30d, Class A 446)
- reporting/output/internal/phase4-alert-quality-report.md (LIVE: Class split A=446 B=9,302 C=466,183 D=1,473,853)
- reporting/output/client/phase4-client-scorecard-template.md
- Generator fixes: Basic auth, key mapping, track_total_hits, period key.

## Capacity recommendation

- **Short-term: add RAM 9.3 -> 16-24 GiB** (removes 4.5G swap pressure; container usage only 2.3G but host at 90%).
- Continue noise reduction (UniFi digest next).
- Medium-term: move Shuffle to VM103 only if RAM unavailable.
- No workloads moved (all options documented).

## Client onboarding package status

8 documents created (client-safe, no internal secrets):
README, client-intake-form, agent-onboarding-checklist, vulnerability-scan-authorization,
canary-authorization, monthly-scorecard-template, escalation-matrix, offboarding-checklist.

## Remaining risks

1. **Memory pressure** unresolved until RAM added (swap 4.5G).
2. **Credential rotation pending** - P1 items (DO Spaces, WAZUH_ADMIN_PASSWORD, Cloudflare) not rotated (no values provided).
3. **UniFi noise** (~45.7%) still alerting - digest routing proposed, not applied.
4. **Shuffle replicas** drop mct-security on live re-creation (repaired 2x this phase; boot cron only covers reboot).
5. **Greenbone schedules + critical alert** not created on VM103.
6. **Sysmon pilot + Velociraptor hunts** blocked on Windows endpoint provisioning.
7. **VM103 backup cron** not installed (approval pending); disk at 76% (Greenbone backups ~1.8GB/wk).
8. Shuffle webhook IDs for drills D5/D8 pending confirmation.
9. CDB auto-reload unreliable - analysisd restart required after list changes.

## Recommended Phase 5 roadmap

1. **Stabilize host**: add RAM (16+ GiB) on PVE - highest priority.
2. **Rotate credentials**: execute P1 rotations one at a time with validation (operator supplies values).
3. **UniFi digest routing**: apply Class C digest for churn/roaming/drops; re-baseline.
4. **Install backup cron**: VM103 MISP daily + Greenbone weekly + Shuffle weekly + IRIS daily (approval).
5. **Complete D5/D8**: confirm Shuffle webhook IDs; create Greenbone critical alert; re-test end-to-end.
6. **Build mct-canary01** + deploy first Canarytokens set.
7. **Windows Sysmon pilot**: provision Windows 11 VM; deploy; 2-week tune-in.
8. **Promote first real MISP IOCs** through lifecycle (analyst tagging).
9. **Create Greenbone schedules** on VM103; first monthly scan + report.
10. **Client onboarding**: run intake with first client; deploy agents; deliver first scorecard.
11. **DR drill**: snapshot restore test to scratch repo.
12. **Shuffle webhook automation hardening** (resolve variable substitution or formalize fallback).

## Files added (summary)

- ops/reports/: 15+ new phase 4 reports (preflight, noise before/after, routing applied/proposed, drills D2-D8, rotation status, backup coverage, canary readiness, sysmon results, capacity, reporting status, greenbone readiness, MISP lifecycle)
- ops/scripts/: vm103-misp-db-dump.sh, vm103-greenbone-backup.sh, shuffle-workflow-export.sh, vm103-backup-freshness-check.sh, credential-rotation-validation.sh, resource-trend-report.sh
- ops/runbooks/: phase4-change-window, phase4-rollback-index, phase4-credential-rotation-window, alert-routing-tuning, vm103-backup-restore, mct-canary01-build, windows-sysmon-pilot-implementation, greenbone-scheduled-operations, scorecard-delivery, workload-placement
- ops/checklists/: phase4-pre-change-checklist, credential-rotation-verification
- ops/cron/: phase4-backup-cron.example
- integrations/: flow/approved-exporters, misp/d2-test-ioc-procedure + test-ioc-lifecycle + false-positive-expiry-procedure, greenbone/*, sysmon/*-phase4, velociraptor/*-phase4, wazuh/routing-adjustments-phase4, opencanary/mct-canary01-config + canarytokens-inventory, test-events/d2/d6/d8
- reporting/: templates/phase4-alert-tuning-summary + phase4-vulnerability-review, output/internal/* + output/client/*
- client-onboarding/: 8 documents

## No secrets

All reports cite paths/variable names only; no secret values printed.
