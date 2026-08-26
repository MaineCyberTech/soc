# MCT Security Stack - Final Phase 20 Operator Report

Date: 2026-08-19
Pack: /home/user/mct-security-18 (macOS Endpoint Recovery, Zeek/Suricata Signal Validation, Retention Verification, Full System/Code Audit)
Stack root: /opt/mct-security-stack

## Executive summary

Phase 20 completed Zeek v2.1 24h validation and **deployed a v2.2 guard extension** that
eliminated the residual subnet-broadcast noise (steady state ~0 alerts/min vs ~10-11K/hr
pre-deploy); **proved Suricata ingest** end-to-end (symlink/cron stable, 1 event decoded);
**validated retention** (archives 14d correctly applied to new indices, alerts 30d, flow 14d);
and ran the **full system, code, security, efficiency, and CI/repo audits**. The macOS agent
015 flood fix remains **blocked on Mac access** (agent offline since 08-18 09:04). **NEW TOP
FINDING: Windows client 014 is flooding archives with Sysmon EventID 7 (~514K docs/24h)** -
requires Sysmon tuning. Repo state: Phase 19/20 work uncommitted (77 files); CI release v1.0.0
is stale. Healthcheck 0 FAIL; no incidents.

## Agent 015 recovery and macOS volume status

- **NOT RECOVERED** (blocked on Mac access). Agent offline since 08-18 09:04 (~22h+).
- Final config + rollback docs delivered (`integrations/macos/phase20-*`); handoff current.
- Volume/queue validation = FAIL pre-fix; PASS criteria defined (<=50K docs/day, 0 queue-full).
- macOS telemetry not usable for scorecard until fix applied + validated.

## Zeek v2.1 validation and routing readiness

- v2.1 8h window: 4,194 total (122006 3,778 residual = subnet-broadcast `192.168.111.255:15600`).
- **v2.2 deployed** (guard extended with `\.255$`) on master+worker; logtest-verified;
  steady-state ~0/min (06:03=0, 06:04=1).
- Anchored-pcre2 fix from v2.1 confirmed working: 122001 fires (1/8h), 122004 fires (2/8h).
- Routing: **MANUAL-ONLY** - Class A auto-route gated on clean 24h window + approval. Plan +
  case template prepared.

## Suricata stability and ingest proof

- Symlink/updater/cron **STABLE** (hourly OK logs); no logcollector path errors.
- **Ingest PROVEN**: ICMP alert ingested 21:34:58 (decoded src/dst/alert/vlan, rule 86601).
- Network QUIET (1 event) - severity 1-2 map stays staged; the one event correctly maps Class C.

## Retention policy validation

- `wazuh-archives-14d` policy + template (pri 310) verified; **08-19 archives index carries
  archives-14d** (authoritative _settings). ElastiFlow 14d; alerts 30d (wazuh-retention).
- Runbook created (`ops/runbooks/index-retention-policy.md`) with verify + rollback + tradeoff.

## NetFlow scope follow-up

- ~448K flows/24h from 13 UNCONFIRMED subnets (~70% of private) - **operator decision still
  pending** (same as P19). Alerting remains unarmed. Classification table refreshed.

## Syslog 15140 policy check

- **VALIDATED**: 9-entry allowlist matches repo+runtime (no drift); UDP-only intentional;
  client subnet + UniFi entries present; active senders all in-scope. Next review: Phase 24.

## mct-portal Redis owner follow-up

- Rule 120537 **10,379/24h** (unchanged, owner-blocked). Level 3 kept; restore 5 after VPS fix.

## Client fleet health and billing readiness

- 013 offline (power), 015 offline (flood), 014 active.
- **NEW: 014 Sysmon EventID 7 archive flood** (~514K/24h, 08-18 21:00-05:00) - tuning required.
- Billing readiness = **NOT READY** (2/3 endpoints uncovered; 014 noise). No invoice until fleet restored.

## Scorecard and monthly client ops

- Scorecard draft produced; progress tracked (cycle target 09-15). Monthly ops run complete.
- 7d alert distribution dominated by now-tuned Zeek noise; next 7d window will show clean signal.

## Full system audit findings

- 0 FAIL healthcheck. Cluster green; retention correct; suricata/zeek/syslog healthy.
- New: **PVE222 API auth FAIL (401)** (token needs refresh); thin-pool report node
  discrepancy to reconcile. See `phase20-full-system-audit.md` + risk register.

## Full code/config audit findings

- All 65 shell scripts pass `bash -n`; all 9 Python tools compile; no rule ID conflicts;
  **no config drift** repo-vs-running.
- **HIGH**: hardcoded credential defaults in 3 scripts + inline creds in
  docker-compose.override.yml + VirusTotal key in wazuh_manager.conf. See code-quality backlog.

## Security/secret hygiene audit

- No secret values in reports/docs/commits this phase. Scans: only false positives +
  value-hidden review hits. Approval gates correctly held (routing/suricata/netflow/greenbone
  gated; Zeek + retention were approved with before/after + rollback).

## Efficiency/capacity audit

- RAM 72%, disk 76%, **swap 49% WARN** (sustained). Indexers (~1.5-1.8GB each) dominate.
- Biggest storage risk now: 014 EventID 7 flood. Low-resource action plan created.

## CI/release/repo integrity audit

- v1.0.0 tag exists but release is 62 commits/Phases 18-20 stale.
- CI workflow valid; local CI has false-PASS gap; unpinned-image check RED + stale (21 refs,
  wazuh-docker compose not covered).
- **Phase 19/20 work uncommitted** (77 files; HEAD = Phase 18) - top repo-integrity issue.
- Source-of-truth docs frozen at v1.0.0.

## Remaining risks (top)

1. macOS 015 flood unresolved + offline (Mac access).
2. **Windows 014 Sysmon EventID 7 flood** (new, ~1.6M/day while active).
3. Phase 19/20 repo state uncommitted; v1.0.0 release stale.
4. NetFlow unknown subnets (~448K/24h) unconfirmed.
5. 013 offline (power) - coverage gap.
6. mct-portal Redis loop (~10K/day) owner-blocked.
7. Unpinned images (21 refs) + PVE222 API token broken.
8. Greenbone client scan unauthorized.
9. Swap pressure (49%) sustained.
10. DR S3 bundle local-only (no new keys).

## Recommended Phase 21 roadmap

1. **Commit + tag Phase 19/20** (repo hygiene), refresh source-of-truth docs, re-pin/cover
   unpinned images (extend checker to wazuh-docker compose), fix hardcoded credential defaults.
2. **Windows 014 Sysmon tuning** - exclude EventID 7 (operator/Velociraptor); before/after capture.
3. **macOS 015 fix** (operator on Mac) -> reconnect + 24h volume/queue PASS -> scorecard + billing ready.
4. **Zeek**: complete clean 24h window -> approve Class A (SSH/SMB/RDP) IRIS routing.
5. **NetFlow**: operator answers subnet scope questions -> arm new-subnet/unknown-exporter alerts.
6. **Suricata**: on first sustained events, enable severity 1-2 rules (122011/122012) + volume measure.
7. **Redis**: portal VPS fix -> restore 120537 to level 5.
8. **Capacity**: refresh PVE222 token, reconcile thin-pool node, recheck disk/swap post-noise fixes.
9. **Client ops**: signed Greenbone auth -> client schedule -> invoice (3 endpoints).

## Files added (summary)

- 43 Phase 20 deliverables: preflight/status-review, macOS recovery (apply/rollback/recovery/
  volume/queue/telemetry), Zeek validation (v2.1/v2.2 decision, routing readiness, routing plan,
  case template), Suricata (stability, ingest proof, severity map), retention (validation +
  runbook), NetFlow follow-up, syslog quarterly, Redis follow-up, fleet + billing readiness,
  scorecard + monthly ops + monthly scorecard, full system audit + risk register + debt backlog,
  full code/config audit + code-quality backlog + config-drift audit, security/secret hygiene +
  approval-gate + client-safe audits, efficiency/capacity + low-resource plan, CI/release/repo
  audit + source-of-truth status, final report.

## No secrets

All reports cite paths/variable names only; no secret values printed.