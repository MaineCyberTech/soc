# Phase 24 Preflight

Date: 2026-08-22 05:47 UTC
Stack root: /opt/mct-security-stack | Release: v1.1.0 (v1.2.0 staged)

## 1. Health / CI / secret / git / release

- Healthcheck: **0 FAIL** (20260822-054656). Local CI: PASS. Secret scan: PASS.
- Git: HEAD 431d0d5 (P23 close); 20 uncommitted entries (evidence/check-unpinned noise). Tags v1.0.0/v1.1.0.

## 2. MAJOR: Agent 013 RECONNECTED (2026-08-22 ~05:42 UTC)

- 013 SAMSUNG back **active** (lastKeepAlive 05:47; EventChannel events from 05:42). Offline 6d (power) -> powered back on.
- **NEW FINDING: 013 is flooding archives with Sysmon EventID 7** (58,841 docs/1h = 96% of volume) - same pattern as 014. EID1 (605/h) + EID10 (195/h) healthy.
- Implication: windows-clients Sysmon tuning (include-oriented policy) applies to BOTH 013 and 014 when endpoint access is available. Fleet now: **all 3 billable endpoints active** (013, 014, 015).

## 3. Agent 015 (24h window accruing)

- Active since 04:22 UTC; archives **0** since reconnect; buffer events **0**. Window completes 04:22 UTC 08-23 (closeout PARTIAL until then).

## 4. Agent 014 (unchanged)

- Active; EID7 flood agent-side (throttle active); tuning blocked on endpoint access.

## 5. Zeek / Suricata / retention / redis / netflow

- Zeek 24h: 304 (clean). Suricata: quiet (1 doc). Retention: archives-14d held. Redis: ~10K/day. NetFlow: ~424K/24h unknown (blocked). PVE222: FAIL (401, token).

## 6. Capacity

- Disk: **84%** (crept from 83%; below 85% low watermark but trending). Swap: 3.4GB/8GB (42%; si=0, minor so - idle-ish). Cluster green.

## 7. Open-item ledger (Phase 24 targets)

- DOABLE this phase: canonical manager config, evidence archive P11-P23, client headers, scorecard governance, brand neutralization, fixture cleanup, REPO-MAP, checklist consolidation, health exit hardening, scanner exclusions, shellcheck, flow/zeek dashboards, windows readiness, billing, monthly ops, regression audit, release gates.
- BLOCKED (replacements/approvals/access): 014/013 tuning apply, VT key, indexer rotation, PVE222 token, Zeek routing enable, v1.2.0 release, NetFlow scope, Greenbone, Redis, DR S3.

## Flags

1. **013 reconnected + also flooding EID7** (tuning scope doubled).
2. 015 24h window accruing (closeout at 04:22 08-23).
3. Disk 84% - watch (trending up).
4. Standard blockers unchanged (access/replacements/approvals).

## No secrets