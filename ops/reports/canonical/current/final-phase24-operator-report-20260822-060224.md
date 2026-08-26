# MCT Security Stack - Final Phase 24 Operator Report

Date: 2026-08-22
Pack: /home/user/mct-p24 (Endpoint Telemetry Completion, Controlled Detection Routing, Credential Rotation, Evidence Archival, Governance Cleanup, v1.2.0 Release)
Stack root: /opt/mct-security-stack | Release: v1.1.0 (v1.2.0 staged)

## Executive summary

Phase 24 executed the Phase 23 roadmap: **fleet restored to 3/3 active** (agent 013
reconnected 05:42 UTC - power confirmed; 015 bounded telemetry window accruing; 014 active),
**DR S3 bundle RESOLVED** (8 successful uploads vs 5 historical 403s; bundle live in S3),
**evidence archive completed** (P11-P23 finals archived with banners + hash manifest; 22/22),
**governance/CI hardening applied** (canonical manager config, client headers 33/33, brand
neutralization, fixture cleanup with YAML regression caught+fixed, REPO-MAP refresh, checklist
consolidation, health exit hardening, scanner exclusions, ShellCheck, flow/Zeek dashboard
definitions), and **v1.2.0 release gates prepared** (approval-pending). Endpoint/credential
items remain approval/replacement-gated: 013+014 Sysmon EID7 tuning (access), VT key, indexer
rotation, PVE222 token, Zeek routing, NetFlow scope, Redis, Greenbone, canarytokens.

## Endpoint workstreams

- **015**: 24h closeout PARTIAL (window from 04:22 08-22, completes 04:22 08-23; archives 0,
  buffer 0, keepalive continuous). Post-upgrade predicate control added to verify-agent015.sh.
- **014 + 013**: both Windows clients confirmed with Sysmon EID7 floods (013: 58.8K/1h, 014:
  throttled). Include-oriented policy ready; apply **BLOCKED** (endpoint access + approval).
  Baselines + after-targets + throttle-retirement criteria documented.
- **013**: **reconnected + powered-on confirmed** by client; coverage gap closed; billable-active.

## Detection routing

- Zeek Class A routing: preconditions verified (clean 304/24h, Class A-only scope, rate limit,
  dedup, rollback, template); **approval-pending** (C3). Case-volume method ready.
- Suricata: stays staged (quiet network; no forced traffic).

## Credentials / PVE

- VT key rotation: **blocked** (replacement key); env-render path ready.
- Indexer password: **approval-pending**; env abstraction in place.
- PVE222 token: **blocked** (replacement token).
- Post-rotation validation baseline captured (green auth, fresh flows, CI/secret PASS).

## Config / drift

- **Canonical sanitized `wazuh_manager.conf` created** (9 allowed-ips + api_key placeholder);
  runtime drift check: **ZERO functional drift** (closes the P22 "7 vs 9" gap).

## Evidence / governance / CI

- **Evidence archive COMPLETE**: P11-P23 finals (13) copied + bannered; 22/22 finals in
  evidence; before/after hash manifest (`evidence-archive-phase24-manifest.txt`).
- Client classification headers: **33/33**. Scorecard path governance codified.
- Brand neutralization: 3 email templates -> `{{brand.brand_name}}`. Fixture cleanup: 3 RSA
  blocks -> synthetic placeholders (**YAML regression found during audit + fixed**).
- REPO-MAP refreshed (08-22, docs/ dir, canonical config). Checklists consolidated to
  ops/checklists/ (root dir removed).
- Health scripts: **nonzero exits on failure** (healthcheck FAIL rows; alert-volume query
  failure). Secret scanner: ops/reports + vendored-JS excluded (noise gone). ShellCheck:
  added to CI + local (opportunistic).
- Flow/Zeek dashboard definitions created (monitoring only; no auto-routing).
- Windows W1/W2 + PS ScriptBlockLogging: **prepared, gated on endpoint noise control**.

## Owner-tracked (unchanged)

- NetFlow scope (operator), Redis 120537 (portal VPS), Greenbone (signed auth), DR S3 full
  restore drill (scheduled), canarytokens T1 (hosted account), W1/W2 dashboards (post-tuning).

## Regression audit

- No regressions: CI PASS, secret PASS, health 0 FAIL, all changed scripts syntax-clean,
  YAML regression caught + fixed, canonical drift MATCH.

## Release status

- **v1.2.0: GATES PREPARED - APPROVAL PENDING** (bundle rebuild, tag, release object+asset
  with PAT memory-only, rollback defined). v1.1.0 remains published.

## Remaining risks (top)

1. 013/014 EID7 floods (tuning blocked on endpoint access) - archive/signal impact.
2. Disk 84% (below low watermark; trending - watch).
3. Pending replacements/approvals: VT key, indexer rotation, PVE222, Zeek routing, v1.2.0.
4. NetFlow scope unconfirmed; Redis loop; Greenbone unsigned.
5. Canarytokens T1 hosted account.

## Recommended Phase 25 roadmap

1. **Endpoint apply windows**: 013 + 014 include-oriented Sysmon tuning -> throttle retirement
   -> W1/W2 dashboards + PS logging enablement.
2. **015 closeout** (04:22 08-23) -> scorecard inclusion.
3. **v1.2.0 release** (approval): bundle rebuild -> tag -> GitHub release.
4. **Credential rotations** (VT key, indexer, PVE222) + post-rotation validation.
5. **Zeek Class A routing enable** (approval) + case-volume window.
6. **NetFlow scope** classification -> arm alerts; **Redis** VPS fix; **Greenbone** signed auth.
7. **DR S3 full restore drill** (download + restore from S3 bundle).
8. **Disk watch**: 14d archive deletes from ~09-05; swapfile resize if > 85%.
9. **Canarytokens** hosted account -> T1 deployment.

## Files added (summary)

- 42 Phase 24 deliverables: preflight, change register, 015 closeout/upgrade check, 014
  access/apply/validation/throttle, 013 confirmation, Zeek approval/enable/case-volume,
  Suricata, VT/indexer/PVE222/post-validation, canonical config + drift, evidence archive +
  hash validation, client headers + scorecard governance, brand + fixtures, REPO-MAP +
  checklists, health exits + scanner exclusions + shellcheck, dashboards, NetFlow/Redis/
  Greenbone/DR-S3, billing, monthly ops, regression audit, release gates + release, final
  report, master status. Fixes: verify-agent015 predicate control, canonical manager config,
  dashboard JSONs, client.config.yaml fixtures (YAML revalidated), health/alert-volume exits,
  scanner exclusions, shellcheck steps, email templates, REPO-MAP, checklist moves.

## No secrets

All reports cite paths/variable names only; no secret values printed.