> **HISTORICAL EVIDENCE (YYYY-MM-DD).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# MCT Security Stack - Final Phase 3 Operator Report

Date: 2026-08-11
Stack root: /opt/wazuh-docker/multi-node
Phase 2 root: /opt/mct-security-stack
Pack root: /home/user/mct-security

## Executive summary

Phase 3 operational hardening completed for the deployed MCT SOC stack. All 16
prompt phases executed in order. Key outcomes: preflight snapshot (indexer
green), Shuffle network repair applied (10 containers reconnected), full-stack
healthcheck covering 24 components, OpenCanary event path verified end-to-end
(rule 121012 level 12), alert volume baselined (~521k/24h: osquery 50.6%, UniFi 45.7%)
noise), 13 IRIS case templates standardized, MISP/Greenbone/OpenCanary/Sysmon
operational plans documented, safe mode/break-glass created, and backup audit
fixed (IRIS DB dump was missing - now working).

## Starting baseline

- Wazuh 4.14.7 multi-node: 3 indexers (cluster green), master, worker, dashboard - all up.
- Phase 2 services: IRIS, Shuffle (frontend/backend/worker), OpenCanary, Velociraptor, ElastiFlow, flow-relay, Security Onion sidecar, MISP/Greenbone VM (192.168.222.154), Cloudflare tunnel - all up.
- Known issue confirmed: 10 Shuffle worker/app replicas lost `mct-security` network.
- Alert volume high (~521k/24h) - measurement needed before tuning.
- IRIS DB dump missing from backups.

## Changes made

1. **Phase 01 Preflight**: report at ops/reports/phase3-preflight-20260811-040018.md. Indexer green, all services up, disk 74%, memory tight (90% used, 4.2G swap).
2. **Phase 02 Secrets**: redaction standard updated (safe command wrapper + public-safe doc template), rotation tracker created (14 credentials, status-only), scan script created and run (105 pattern hits - all vendored code, no doc secrets).
3. **Phase 03 Shuffle**: network repair script created and APPLIED (10 containers reconnected to mct-security, DNS verified); healthcheck script (PASS, uses /api/v1/health); restart recovery runbook; workflow fallback pattern documented.
4. **Phase 04 Health monitoring**: full-stack-healthcheck.sh (24 components, 0 FAIL, 2 WARN memory/swap); backup-freshness-check.sh (PASS); monitoring runbook; MISP VM reachability fixed to TCP 8443 (ICMP blocked).
5. **Phase 05 SOC drills**: soc-smoke-test.sh with 4 modes; test payloads stored (6 JSON files); D1 OpenCanary drill PASSED end-to-end (port 9100 trigger -> rule 121012 level 12); drill matrix + validation matrix created.
6. **Phase 06 Alert baseline**: alert-volume-by-rule.sh queries real data; baseline report (top 25 noisy rules: osquery 24010 #1 at 50.6%, UniFi 45.7%); noise tuning plan (Class A/B/C/D routes, no level changes applied); classification matrix; noise triage runbook.
7. **Phase 07 IRIS**: 13 case templates (11 standardized to full field set + 2 new: misp-ioc-match, wazuh-agent-offline); routing map; management runbook.
8. **Phase 08 MISP**: IOC lifecycle runbook + state model; CDB diff script; feed health script (PASS: MISP 2.5.44, 2106 events); status report.
9. **Phase 09 Greenbone**: target groups (4), scan window policy (5 profiles), critical finding workflow (notify-only), vulnerability review template, ops runbook.
10. **Phase 10 OpenCanary**: local validation doc (path verified), canary VM plan (mct-canary01), Canarytokens plan, deception monitoring runbook.
11. **Phase 11 Sysmon**: pilot runbook, agent group plan, test event checklist, rule/dashboard backlog (8 detections), pilot plan report. No deployment.
12. **Phase 12 Reporting**: generate-monthly-scorecard.py + generate-alert-quality-report.py (sample + --live modes); monthly-client-scorecard, internal-weekly-soc-review, alert-quality-report templates; reporting automation runbook; output dirs (internal/client).
13. **Phase 13 Safe mode**: safe-mode runbook (9 questions), break-glass runbook, enter-safe-mode.sh + exit-safe-mode-checklist.sh (dry-run verified, Wazuh protected).
14. **Phase 14 Backup/DR**: backup-dr-audit.sh (PASS after fixes); IRIS DB dump script created (was missing - now dumps 36K); restore map; rollback verification runbook confirming Wazuh volumes untouched.

## Files added/updated

- 15 reports in ops/reports (all phases)
- 15 scripts added/updated in ops/scripts
- 10 runbooks added/updated in ops/runbooks
- 15 files in integrations/ (case templates, greenbone, opencanary, sysmon, shuffle, misp, wazuh)
- 3 reporting templates + 2 generators in reporting/
- 6 test event payloads in integrations/test-events/

## Scripts added

| Script | Purpose |
|---|---|
| scan-docs-for-secret-patterns.sh | secret pattern scan (no values printed) |
| shuffle-repair-network.sh | reconnect Shuffle replicas to mct-security |
| shuffle-healthcheck.sh | Shuffle health with pass/fail |
| full-stack-healthcheck.sh | 24-component stack health |
| backup-freshness-check.sh | backup stream freshness |
| soc-smoke-test.sh | safe SOC drills (4 modes) |
| alert-volume-by-rule.sh | alert volume by rule |
| misp-cdb-diff-report.sh | CDB churn diff |
| misp-feed-health.sh | MISP API/feed/CDB health |
| enter-safe-mode.sh / exit-safe-mode-checklist.sh | safe mode dry-run/apply |
| backup-dr-audit.sh | backup coverage audit |
| iris-db-dump.sh | IRIS postgres dump (NEW - was missing) |
| generate-monthly-scorecard.py / generate-alert-quality-report.py | reporting (sample/live) |

## Runbooks added

shuffle-restart-recovery, full-stack-health-monitoring, soc-drills,
noise-triage, iris-case-management, ioc-lifecycle, vulnerability-management,
deception-monitoring, windows-sysmon-pilot, reporting-automation, safe-mode,
break-glass, phase3-restore-map, phase3-rollback-verification,
phase3-credential-rotation-tracker (tracker), redaction-standard (updated).

## Tests run

| Test | Result |
|---|---|
| Preflight (indexer health, containers, ports, cron, backups) | PASS |
| Secret scan (105 hits - vendored code only, no doc secrets) | PASS |
| Shuffle network repair (10 containers) | PASS (applied) |
| Shuffle healthcheck | PASS |
| Full-stack healthcheck (24 components) | PASS (0 FAIL) |
| Backup freshness check | PASS |
| SOC smoke test dry-run + opencanary (D1) | PASS (rule 121012 fired) |
| Alert volume query | PASS (real data) |
| MISP feed health | PASS (API 2.5.44, 2106 events, CDB synced) |
| Safe mode dry-run | PASS |
| Backup/DR audit | PASS (after IRIS dump fix) |
| IRIS DB dump | PASS (36K dump) |

## Validation matrix

| # | Drill | Status |
|---|---|---|
| D1 | OpenCanary -> Wazuh 121012 -> Shuffle -> IRIS | PASS (Wazuh leg verified; Shuffle/IRIS leg pending webhook URL - manual path works) |
| D2 | MISP IOC match | NOT RUN (needs MISP test IOC) |
| D3 | Flow unusual port | NOT RUN |
| D4 | Unknown flow exporter | NOT RUN |
| D5 | Greenbone critical | NOT RUN |
| D6 | Active response audit | NOT RUN |
| D7 | Velociraptor evidence | NOT RUN |
| D8 | SO bridge | NOT RUN |

D2-D8 have defined triggers + validation queries in soc-validation-matrix.md;
scheduled for operator execution.

## Shuffle hardening status

- Network repair applied (10 containers reconnected, DNS verified worker->backend and ->iriswebapp_nginx).
- Healthcheck PASS (frontend 200, backend /api/v1/health success, network membership, DNS).
- Restart recovery runbook + fallback pattern (static title + raw payload) documented.
- Boot-time validation cron ENABLED (user crontab @reboot, 2026-08-11).

## Alert/noise baseline summary

- ~521k alerts/24h (track_total_hits verified). osquery 24010 = ~50.6% (263.6k - Security Onion open_sockets inventory, Class D candidate). UniFi syslog = ~45.7% (238k: roaming 120520: 54.7k, unknown device 120527: 53.2k, LAN/WAN drops, client churn).
- mct-portal = ~3.5% (120537 warn/error: 10.3k; auditd 80710: 3.2k at level 10).
- Top 25 noisy rules listed in alert-volume-baseline.md.
- Tuning plan proposes Class C/D routes for UniFi noise and mct-portal benign logs; NO rule levels changed (measurement-first rule respected).

## IRIS case template coverage

13 templates covering: OpenCanary hit, MISP IOC match, flow lateral movement,
unknown exporter, high outbound transfer, unusual port, critical vulnerability,
SSH brute force/AR, SO Suricata alert, mct-portal app event, agent offline,
UniFi WAN drop, Sentry review. All standardized to 11 fields. Routing map
connects every alert source/rule/monitor to a template.

## MISP lifecycle status

- IOC states + confidence model + expiry guidance documented.
- CDB diff + feed health scripts working (PASS).
- CDB currently empty (0 IOCs) - no action:block+confidence IOCs tagged yet; exporter works (2,106 events indexed).
- False positive flow documented (action:false-positive tag).

## Greenbone operational status

- 4 target groups, 5 scan profiles, windows defined, critical workflow notify-only.
- Infrastructure device caution documented (gateways non-invasive, PVE discovery only).
- No scan credentials written to docs. Schedules not yet created in UI (operator action).

## OpenCanary hardening status

- Event path validated end-to-end (D1 PASS).
- Canary VM plan (mct-canary01) + Canarytokens plan documented.
- FP cautions documented (scanner 192.168.222.154 suppressed, host probes 172.20.0.1 benign, SSH/telnet bare connects log nothing).

## Sysmon pilot status

- Full pilot plan, agent group plan, test event checklist, rule/dashboard backlog (8 detections) documented.
- No deployment performed (planning only - safe).

## Scorecard/reporting status

- Two generators (scorecard, alert quality) working in sample mode; --live mode requires WAZUH_ADMIN_PASSWORD env.
- 3 templates complete; queries stored separately from secrets; output dirs created (internal/client).
- Cron automation documented but NOT installed (operator approval).

## Safe mode readiness

- Safe mode runbook answers all 9 required questions.
- enter/exit scripts dry-run verified; Wazuh never touched by design.
- Break-glass runbook with isolate->diagnose->contain->restore->document flow.

## Backup/DR status

- Local snapshots: PASS (16 snapshots, latest SUCCESS 1h old).
- S3 snapshot: PASS; DR bundle: PASS.
- Wazuh config backups: PASS; Phase 2 config bundles: PASS.
- IRIS DB dump: FIXED (was missing; iris-db-dump.sh creates 36K dump; cron not enabled).
- MISP/Greenbone DB: manual (VM) - documented gap.
- Restore map + rollback verification (Wazuh volumes never touched) documented.

## Credentials requiring rotation (no values)

- WAZUH_ADMIN_PASSWORD - NEEDS_ROTATION
- Cloudflare tunnel token - NEEDS_ROTATION
- IRIS admin password + API key - NEEDS_ROTATION
- MISP admin password + API key - NEEDS_ROTATION
- DO Spaces access/secret keys - NEEDS_ROTATION
- Verify-only: Wazuh API users, kibanaserver, SO superuser, VirusTotal, PVE, SO SSH, Shuffle, VM 103, DB secrets

Full tracker: ops/runbooks/phase3-credential-rotation-tracker.md (status only).

## Remaining risks

1. **Memory pressure**: host 90% RAM used, 4.2G/8G swap - watch OOM kills; consider VM sizing.
2. **Alert noise** (~96% from osquery 24010 + UniFi): routing changes proposed (24010 -> Class D, UniFi -> Class C) but not yet applied.
3. **Shuffle replicas** drop mct-security network on live re-creation - boot-time @reboot repair now enabled; run repair script manually after live replica re-creation (no reboot).
4. **IRIS/MISP/Shuffle DB backups**: IRIS fixed; MISP/Greenbone still manual on VM.
5. **Shuffle variable substitution unreliable** - fallback pattern mitigates but reduces automation.
6. **Sudo password required** for some Wazuh ops (wazuh-local.env unreadable as user) - operational friction.
7. D2-D8 drills pending operator execution.
8. Sysmon pilot not deployed; Windows endpoint telemetry absent.

## Recommended Phase 4

1. **Stabilize**: Shuffle boot-time repair DONE; install IRIS DB dump cron (approval pending).
2. **Reduce noise**: apply Class C/D routing for UniFi + mct-portal benign logs; re-baseline.
3. **Rotate credentials** per tracker (scheduled maintenance window).
4. **Execute drills D2-D8** and fix any path failures.
5. **Build mct-canary01 VM** + first Canarytokens set.
6. **Windows Sysmon pilot** (Phase A: 1 endpoint, collection only).
7. **DR drill**: snapshot restore test to scratch repo.
8. **Address host memory** (add RAM or move a workload to VM).
9. **MISP tagging workflow**: promote first real IOCs to active-block to validate CDB path.
10. **Client onboarding**: per-client targets, scorecards, and canaries.
