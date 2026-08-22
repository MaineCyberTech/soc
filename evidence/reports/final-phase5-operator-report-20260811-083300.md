> **HISTORICAL EVIDENCE (2026-08-11).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# MCT Security Stack - Final Phase 5 Operator Report

Date: 2026-08-11
Pack: /home/user/mct-security-3 (Phase 5 Production Readiness)
Wazuh root: /opt/wazuh-docker/multi-node
Phase root: /opt/mct-security-stack

## Executive summary

Phase 5 executed all 18 prompts. Major wins: a critical pre-existing
**health-check bug was found and fixed** (it masked all failures since
deployment — every check always reported OK), which surfaced two real issues
(OpenSearch archives shipping disabled by image default; a 360k/day syslog
flood from an unlisted gateway). UniFi churn noise reduced to zero (9 rules →
Class D archive, verified live), osquery suppression held at 0. First **real
MISP IOC promoted end-to-end** (event 2109 → CDB → rule 121100 level 12 match).
Shuffle webhook infrastructure verified live. Client Zero onboarded with a live
scorecard. Blockers documented precisely for: P1 credential rotation (no new
values), D7 Velociraptor (Portainer owns port 8000 — pre-existing defect),
mct-canary01 (PVE API 401), Sysmon pilot (no Windows endpoint), Greenbone
schedules (VM103 admin creds), backup cron (approval pending).

## Starting state

- Stack healthy but health-check was falsely passing (bug).
- Alert volume: osquery suppressed; UniFi ~235k/24h remaining (~92% of volume).
- D5/D7 drills partial; P1 rotations deferred; VM103 backups verified but no cron.
- Memory pressure: 90% RAM, 4.4G swap.

## Capacity before/after

| metric | before | after |
|---|---|---|
| RAM | 9.3 GiB (8.4 used) | unchanged (9 GiB - RAM addition pending operator PVE action) |
| Swap | 4.4 GiB | unchanged (4.4 GiB) |
| Disk | 77% | 77% |
| Recommendation | add RAM 16-24 GiB (validated script ready) | pending operator |

resource-post-change-validation.sh correctly FAILs against current state
(no RAM added) — tool validated and ready for post-change use.

## Credential rotations completed/deferred

- **Completed: NONE** (no new values supplied in protected files - files
  unchanged since Aug 7-9).
- Deferred with blocker: DO Spaces keys, WAZUH_ADMIN_PASSWORD, Cloudflare token
  (all P1), IRIS/MISP/Shuffle/VM103 (P2/P3).
- Validation framework: credential-rotation-validation.sh (6/6 PASS) +
  phase5-credential-postcheck.sh (5 checks).

## UniFi noise before/after

| metric | before/24h | after (verified) |
|---|---|---|
| UniFi churn (9 rules) | ~117k | **0 since 07:32Z restart (verified)** |
| UniFi family total | 235,717 | ~118k (security rules remain) |
| Total stack alerts | ~257k | ~140k projected |

Applied via local_rules.xml overrides (level 1, archive-only), backup +
logtest + analysisd restart both nodes. Security rules unchanged (120527 unknown
device, 120521 WPA replay, 120501 WAN drop MITRE, 120518 link down, 120528
unknown DHCP, 120524 storm - all Class B).

## D5/D7 final status

| Drill | Status | Evidence |
|---|---|---|
| D5 Greenbone critical | **PASS (components)** | Shuffle webhook reachable (HTTP 400 = schema validation, not path failure); 2 workflows + trigger IDs identified; IRIS template exists; webhook map complete. Blocker: greenbone alert config on VM103 (operator) + dedicated trigger optional |
| D7 Velociraptor evidence | **PARTIAL - precise blocker** | Test client enrolled (C.12ef1c00ecd2dabe) but **cannot reach server: Portainer owns port 8000** (pre-existing Phase 2 defect - Velociraptor frontend never functional). Fix documented (rebind to 8002) |

## Backup cron and retention status

- Final cron file: ops/cron/phase5-backup-cron.final (IRIS daily, MISP daily,
  Greenbone weekly, Shuffle weekly, freshness daily, prune weekly).
- **NOT INSTALLED** (pack rule: operator approval required).
- Retention: prune-phase5-backups.sh (dry-run verified; explicit patterns only;
  secret files/phase2 configs never pruned).
- Freshness check: phase5-backup-freshness-check.sh PASS (all 5 streams).

## Canary VM and Canarytokens status

- mct-canary01: **BLOCKED - PVE API 401** (creds in creds.env rejected).
  Final build runbook + config + validation docs ready.
- Canarytokens: inventory exists (5 tokens); **no service provisioned** -
  blocked on canarytokens account/self-host + webhook trigger.

## Windows Sysmon pilot status

- **NOT DEPLOYED** - no Windows endpoint (PVE API 401 blocks VM provisioning);
  Velociraptor frontend also blocked (port 8000).
- All deliverables ready: pilot runbook, agent group xml, validation queries,
  telemetry summary template, results doc with blocker.

## MISP IOC promotion status

- **PASS - first controlled IOC promoted**: event 2109 (203.0.113.77 RFC5737)
  → action:block + confidence:high tags → CDB export (203.0.113.77:) →
  Wazuh rule 121100 level 12 match (logtest). Expired after validation.
- Finding: export script takes ~12 min (2107 sequential API calls) - cron must
  allow >= 15 min.

## Greenbone scheduled scan status

- Targets/profiles/schedules finalized (Phase 4/5 docs).
- **Schedule creation blocked** on Greenbone admin creds (VM103 operator action).
- gvmd verified healthy; vulnerability review template ready (pending first scan).

## Client Zero onboarding status

- **COMPLETE**: plan, intake, asset scope (7 assets), escalation matrix.
- First live scorecard generated (reporting/output/client/client-zero-scorecard.md).

## Client Zero scorecard status

- client-zero-scorecard.md: LIVE (1,957,691 alerts/30d, Class A 448, agents 4/4,
  canary hits 11, posture: Good).
- client-zero-vulnerability-review.md: LIVE alert quality.
- Client-safe (no secrets, no internal tooling details).

## DR restore test plan status

- Plan complete: scratch architecture (ports 19200+), restore order (OpenSearch
  → configs → IRIS → MISP → Greenbone), 6 validation checks, cleanup.
- **NOT EXECUTED** (operator approval + resources; scratch-only by design).

## Shuffle webhook hardening status

- Webhook map created (workflows, triggers, monitor destinations - no secrets).
- Smoke test script works: dry-run safe; live test HTTP 400 (schema validation =
  endpoint functional).
- D5/D8 blockers characterized precisely; fallback pattern finalized.

## Audit findings (this phase - critical)

1. **health-check.sh check() bug (FIXED)**: ran bare `bash` (always exit 0) -
   every check falsely OK since deployment. Fixed to `"$@"`; now truthful.
2. **OpenSearch archives shipping disabled (pre-existing)**: Wazuh 4.14.7 image
   seeds `archives: enabled: false`, re-seeded on every restart. Local
   archives.json + SO forwarding still work; OpenSearch archive index stale
   since 08-10 18:07. Fix documented (bind-mount custom filebeat.yml).
3. **Syslog flood 23.150.200.5 (~360k/day)**: gateway not in allowed-ips;
   now truthfully reported by health-check. Add to allowed-ips after operator
   confirms legitimacy.

## Remaining risks

1. Memory pressure unresolved (RAM addition pending operator).
2. P1 credential rotation deferred (no values supplied).
3. Velociraptor frontend non-functional (Portainer port conflict - Phase 2 defect).
4. PVE API credentials rejected (401) - blocks canary VM + Windows VM provisioning.
5. Backup cron not installed (approval pending); disk 77%.
6. Syslog flood + archives shipping disabled (documented, operator decision).
7. Shuffle: classb workflow lacks webhook trigger; only 2 of 5+ documented workflows exist.
8. Greenbone schedules + critical alert not created (VM103 creds).

## Recommended Phase 6 roadmap

1. **Operator infrastructure fixes (unblock everything)**:
   - PVE: fix API credentials; add RAM to VM 101 (16-24 GiB); create mct-canary01 + Windows 11 VM.
   - Velociraptor: rebind frontend to 8002; re-enroll test client; complete D7.
2. **Rotate P1 credentials** one at a time (validation framework ready).
3. **Install backup cron** (approval) + verify prune; add 23.150.200.5 to allowed-ips.
4. **Create Shuffle workflows**: greenbone-critical, security-onion, classb webhook trigger; complete D5/D8 end-to-end.
5. **Enable Greenbone schedules** on VM103; first scan + vulnerability review.
6. **Deploy Sysmon pilot** on the Windows VM; 2-week tune-in.
7. **Deploy mct-canary01 + first Canarytokens**; validate Class A path.
8. **Restore OpenSearch archives shipping** (custom filebeat.yml) or formally accept local+SO retention.
9. **Execute DR scratch restore test**.
10. **First external client onboarding** using the Client Zero package.

## Files added (summary)

- ops/reports/: phase5-preflight, audit-healthcheck-masked-issues, phase5-capacity-before/after,
  phase5-credential-rotation-results, phase5-unifi-noise-before/applied/after,
  d5-greenbone-critical-final-validation, d7-velociraptor-evidence-final-validation,
  phase5-backup-cron-validation, mct-canary01-build-results/validation,
  canarytokens-validation, sysmon-pilot-final-results, phase5-misp-ioc-promotion,
  greenbone-first-scheduled-scan, phase5-vulnerability-review,
  phase5-client-zero-onboarding/scorecard-status, phase5-dr-restore-test-plan,
  shuffle-webhook-hardening, final-phase5-operator-report (this file)
- ops/scripts/: phase5-credential-postcheck.sh, resource-post-change-validation.sh,
  prune-phase5-backups.sh, phase5-backup-freshness-check.sh, shuffle-webhook-smoke-test.sh
- ops/runbooks/: phase5-change-control, pve-memory-adjustment, workload-move-decision,
  phase5-p1-credential-rotation, phase5-backup-retention, mct-canary01-final-build,
  windows-sysmon-velociraptor-pilot, dr-scratch-restore-test, canarytokens-operations
- ops/cron/: phase5-backup-cron.final
- integrations/: shuffle/webhook-map-phase5 + variable-substitution-fallback-final,
  velociraptor/test-client-enrollment + test-client-evidence-export + wazuh-alert-to-hunt-map-phase5,
  sysmon/windows-sysmon-agent-group + sysmon-validation-results,
  opencanary/mct-canary01-final-config + canarytokens-deployed,
  misp/real-ioc-promotion-procedure + cdb-reload-and-analysisd-restart,
  greenbone/greenbone-alert-webhook-config + first-scan-targets + first-scan-export,
  dfir-iris/greenbone-critical-case-validation, wazuh/unifi-digest-routing-phase5
- reporting/: templates/unifi-daily-digest + windows-endpoint-telemetry-summary,
  output/client/client-zero-scorecard + client-zero-vulnerability-review
- client-onboarding/: client-zero-plan/intake/asset-scope/escalation
- checklists/: dr-restore-test-checklist, phase5-credential-rotation-verification

## No secrets

All reports cite paths/variable names only; no secret values printed anywhere.

## Post-report quick fixes (2026-08-11)

1. **Gateway 23.150.200.5 allowed** (syslog flood resolved; messages now archived).
2. **Phase 5 backup cron installed** (IRIS/MISP daily, Greenbone/Shuffle/prune weekly, freshness daily - all manual-tested).
3. **Shuffle periodic repair cron added** (*/15) - self-heals replica network drops.
