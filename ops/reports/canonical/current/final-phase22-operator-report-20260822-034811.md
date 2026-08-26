# MCT Security Stack - Final Phase 22 Operator Report

Date: 2026-08-22
Pack: /home/user/mct-security-20 (Endpoint Telemetry Remediation, Credential Rotation, Detection Routing Promotion, Image Hardening, Full-System Assurance)
Stack root: /opt/mct-security-stack | Release: v1.1.0 (published)

## Executive summary

Phase 22 closed the credential/env-abstraction and image-hardening backlogs, corrected
source-of-truth and retention drift, and ran the full assurance audits. Key outcomes:
**compose secrets templated to `${VAR}` refs** (wazuh-docker .env, mode 600, verified),
**runtime images digest-pinned** with an enforced classification policy (0 violations),
**archives ISM retention re-attached** (stale `wazuh-retention` attach found + fixed to
`wazuh-archives-14d`), **macOS repair bundle reviewed/fixed/packaged** for operator handoff,
**Zeek v2.2 3-day clean-window validated** (99.9% noise reduction; Class A routing
approval-pending), and a full system/code/security/performance/docs audit completed with
targeted fixes. Endpoint blockers persist: 014 Sysmon flood (throttled at analysis, tuning
blocked on access), 015 offline (Mac access), 013 power (client). New WARN: root disk 86%,
swap 64%.

## Release / source-of-truth

- v1.1.0 confirmed published (API-verified). Stale "pending" wording removed from
  RELEASE-NOTES + README ("Current release: v1.1.0 (2026-08-19)").
- Release record + checklist consistent (bundle sha256 25d35eb6...).

## Windows 014 Sysmon analysis/tuning

- **State change**: archive flood (573K/24h) now suppressed by Wazuh rule-11 throttle; agent-
  side flood continues (13 buffer events/24h, EID7 alerts still arriving). Throttle hides the
  signal -> tuning remains required.
- Precheck done; apply **BLOCKED** (endpoint access + approval). Applied-config recorded
  (`integrations/sysmon/phase22-windows014-applied-config.xml`). Before/after methodology
  documented (agent-side counts; archives unusable while throttled). Telemetry decision: DEGRADED.

## Agent 015 macOS repair

- Bundle reviewed + **fixed** (block-safe tempered regex verified with multi-localfile sample),
  packaged at `integrations/macos/remediation-bundle/` (repair/verify/rollback/diagnostics).
- Apply **BLOCKED** (Mac access). Reconnect/volume/queue validation = FAIL pre-repair; targets
  defined (>=95% reduction, 0 queue-full, bounded events present).

## Agent 013 coverage

- Consistent with powered-off (abrupt disconnect 08-16 13:45, zero signal 6d). Cannot confirm
  remotely (client net unroutable). Owner: client power check. Uncovered billable endpoint.

## Zeek / Suricata routing

- **Zeek v2.2 3-day clean window: 948 events (~316/day)** - 99.9% reduction; guards verified
  (unicast-only residuals); Class A logtest + live verified. Decision: KEEP, **routing-ready**;
  controlled Class A enable plan prepared, **approval-pending** (not enabled).
- Suricata: ingest proven, network quiet (1 event); severity 1-2 rules staged; routing gated.
  No invasive traffic.

## Credential rotation / env abstraction

- Rotation plan + checklist created (inventory by variable, owners, sequence, validation,
  rollback).
- VirusTotal: **blocked on replacement key**; env-render script created
  (`render-virustotal-integration.sh`, fail-fast, idempotent, no value prints).
- Indexer/compose: **templated** (INDEXER_PASSWORD, API_PASSWORD, DASHBOARD_PASSWORD,
  EF_OUTPUT_OPENSEARCH_PASSWORD, ES_PASS -> ${VAR} refs; values in wazuh-docker .env 600,
  gitignored; `docker compose config` RC=0; no recreation). **Rotation approval-gated.**
- `docs/WAZUH-DOCKER-SECRET-ABSTRACTION.md` + report: skip-worktree now defense-in-depth.

## Image policy

- Classification (R/F/V/C) implemented: 5 runtime images **pinned by digest** (opencanary,
  cloudflared, nginx, elastiflow, python); 21 feed/versioned/cache exceptions documented.
- CI policy enforced (violations FAIL, exceptions warn): checker 0 violations; local CI PASS.
- `docs/CONTAINER-IMAGE-POLICY.md` + machine-readable exceptions file.

## NetFlow scope

- ~423K flows/24h unknown subnets; operator confirmation still outstanding; alerting unarmed.

## Client fleet / billing / Greenbone

- Fleet: 1/3 healthy (014 degraded). **Billing NOT ready** (2/3 uncovered; 014 quality).
- Greenbone client scan: NOT AUTHORIZED (no scan).

## Full system audit findings

- PASS: cluster green, rules synced, snapshots fresh, SO/agent 008, ElastiFlow (8.5M docs),
  syslog 15140 (9 IPs, UDP-only), Shuffle/IRIS/Velociraptor/MISP, CI/release.
- **FIXED**: archives ISM retention attach (wazuh-retention -> wazuh-archives-14d on 08.19-08.22).
- FAIL: pve222 API token missing (401). MED: duplicate backup crons, cache manifest placeholders.

## Code/config audit findings

- 70 scripts bash-n clean; 9 Python compile; compose/JSON valid.
- **FIXED**: opencanary decoder-plan XML -> md; CI pyc pollution (PYTHONPYCACHEPREFIX);
  relay.py ES_PASS fallback removed; credential-bearing backups chmod 600.
- Drift: no canonical wazuh_manager.conf repo copy (backlog); zeek rules byte-identical.

## Security/secret/dependency audit

- Secret scans: PASS (0 true positives); file perms 600 (all protected stores).
- **FIXED**: wazuh-docker backup files + relay.py perms; 3 legacy docs reference
  kibanaserver account NAME (documented acceptable).
- Git history: legacy literals in all 79 commits (private repo; rotation recommended; no
  secret files ever committed).
- Dependencies/cache: PASS; IRIS LGPL label mismatch + manifest placeholders (backlog).

## Performance/capacity audit

- **Root disk 86% (WARN)**, **swap 64% (WARN)**, RAM 71%. Indexers ~5.7GB combined.
- Index growth bounded (alerts 7.6K/day, archives 218K/day post-fixes); 14d deletes start ~09-05.
- Low-resource action plan created (disk relief, swap reduction, tuning levers).

## Documentation audit

- Source-of-truth: README/RELEASE-NOTES current; ARCHITECTURE/STACK-OVERVIEW stale (P1 backlog).
- Client-dir hygiene: 33/42 files missing classification headers; internal artifacts present
  (P0 backlog). Evidence banners 0/122 vs v1.0.0 claim (addendum needed). Branding
  neutralization backlog.

## Monthly client ops

- Run complete (health, backups, coverage, alert quality, posture, scorecard, billing,
  authorization, retrospective).

## Remaining risks (top)

1. 014 Sysmon flood active agent-side (throttled) - tuning blocked on access.
2. 015 offline - Mac access blocked (bundle ready).
3. **Root disk 86%** + swap 64% - capacity watch.
4. 013 offline 6d (power, client).
5. NetFlow scope unconfirmed (~423K/24h).
6. Redis loop ~10K/day (owner-blocked).
7. pve222 API token missing.
8. VT key + indexer password rotation pending (replacement key/approval).
9. Git history literals (private repo; rotation mitigates).
10. Greenbone client scan unsigned.

## Recommended Phase 23 roadmap

1. **Endpoint apply windows**: 014 Sysmon tuning + 015 macOS repair (operator) -> before/after
   validation; 013 power confirm.
2. **Zeek Class A routing enable** (approval) with case-volume monitoring + rollback.
3. **Capacity**: disk relief plan (14d deletes, prune review, target <80%), swap reduction
   (shuffle-opensearch/indexer heap review), pve222 token refresh.
4. **Credential rotation**: VT key (replacement) + indexer password (approval) using the
   env-abstraction path; verify cluster/dashboard/scripts.
5. **Doc hygiene**: STACK-OVERVIEW/ARCHITECTURE refresh; client-dir headers + internal
   artifact move; branding neutralization; evidence-banner claim addendum.
6. **NetFlow**: operator scope confirmation -> arm new-subnet alerts.
7. **Repo**: commit + push P22 work; consider v1.2.0 release (post P22 state).
8. **Greenbone**: signed auth -> first client scan.

## Files added (summary)

- 45+ Phase 22 deliverables: preflight/status-review, source-of-truth cleanup + consistency,
  windows014 precheck/apply/before-after/telemetry + applied-config, macos bundle review/apply/
  validation + bundled scripts, 013 review, zeek final validation + decision + routing (plan),
  suricata followup + readiness, secret rotation plan + checklist, VT rotation, indexer
  rotation + compose templating, env abstraction docs, image classification + pinning + CI
  policy + policy doc + exceptions file, netflow followup, fleet + billing + scorecard +
  monthly scorecard, greenbone auth, full system audit + risk register + debt backlog, full
  code/config audit + code-quality + drift, security/secret + dependency + approval-gate
  audits, performance/capacity + low-resource plan, docs/whitelabel audit + cleanup backlog,
  monthly ops run, final report. Fixes: run-local-ci.sh + verify.yml (pyc prefix), opencanary
  plan -> md, render-virustotal script, exceptions file, chmod 600 + relay.py (wazuh-docker).

## No secrets

All reports cite paths/variable names only; no secret values printed.