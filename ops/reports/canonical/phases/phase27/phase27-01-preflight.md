# Phase 27 Preflight

Date: 2026-08-24 06:35 UTC
Stack root: /opt/mct-security-stack | Releases: v1.0.0/v1.1.0/v1.2.0 (v1.3.0 staged)

## 1. Health / CI / secret / git / release

- Healthcheck 0 FAIL. CI PASS. Secret PASS. Git HEAD cb8ca76 (P26). v1.2.0 published.

## 2. Fleet (3/3 active)

- 013 SAMSUNG active (06:34); 014 active (06:34); 015 active (06:22, macOS cadence).
- **EID7: 0/30m on BOTH 013 and 014** (sustained quiet). EID1 flowing (013: 39/30m, 014: 7/30m).
- Sysmon policy marker confirmation (operator `sysmon -s` check) still pending for both.

## 3. Zeek / guardrail

- Class A real alerts 24h: **0**. Guardrail: 4 executions/24h (under 5 limit); integration
  enabled; kill switch proven (P26).

## 4. Retention / capacity

- Archives 08-10..08-18 **deleted by ISM** (only 08-19+ remain) - 14d retention rolling.
- Disk: root 81%, node 81.0% (slightly up from 79.5% - daily ingest ~1GB/day + elastiflow;
  plateau assessment required, phase 29).

## 5. Snapshots / PVE / owners

- Snapshots: 42 (latest snap-20260824-0517). PVE222: FAIL (401). 120537: ~10K/24h.

## 6. Open items (Phase 27 targets)

- DOABLE: multi-index restore drill (p27-restore-*), RTO/RPO update, retention followup +
  capacity plateau, Shuffle workflow backup + dedup/rate-limit design attempt, audits,
  billing/scorecard/monthly ops, v1.3.0 gates (approval).
- OPERATOR/APPROVAL: 013/014 marker confirmation + 24h certification, throttle retirement,
  PS4104 pilot, v1.3.0 release.
- BLOCKED: VT/indexer/PVE rotations, NetFlow scope, Redis, Greenbone, canarytokens.

## No secrets