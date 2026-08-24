# Phase 31 Monthly Client Ops

Date: 2026-08-24

| Item | Status |
|---|---|
| Health | **0 FAIL** (SO RETIRED) |
| CI | PASS |
| Endpoints | 3/3 coverage (013/015 transient; 014 active) |
| Packet visibility | Suricata-minimal benchmarked (31MB/0 drops); production SPAN-gated |
| Routing | Zeek Class A live + guardrail operational |
| Backups | fresh (daily 02:30, S3 < 48h, 42 snapshots) |
| Capacity | disk 84% watch (wave ~08-29); memory PSI 0 (swappiness 10) |
| Release | v1.3.0 published |
| Blockers | SPAN, markers, Shuffle UI, target, credentials |

## Retrospective

- Best: SO retirement cleaned health/CI (0 FAIL); Suricata benchmark proved sub-2GiB;
  CI hardening (pinned checkout + gates).
- Watch: disk, RAM, SPAN approval, markers.

## No secrets
