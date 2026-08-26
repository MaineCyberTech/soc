# Phase 28 Preflight Baseline

Date: 2026-08-24 18:30 UTC
Status: **GREEN** (health/CI/secret) with findings below.

## Health / gates

| Check | Result |
|---|---|
| Healthcheck | 0 FAIL |
| CI | PASS |
| Secret scan | PASS |
| Cluster | green, 264 shards, 0 unassigned |
| Release | v1.2.0 current; v1.3.0 staged |
| Git | HEAD 9f09dda (P27) |

## Fleet / telemetry

- **013 SAMSUNG: disconnected** (keepalive 17:28Z, IP 192.168.111.166) - transient offline ~1h.
  EID1 62/24h, **EID7 39/24h** (well under 2K/day target), EID10 0. Marker confirmation STILL PENDING.
- **014 DESKTOP-MI54LFT: active**. EID1 99/24h (6/30m), EID7 0/24h, EID10 0. Marker confirmation STILL PENDING.
- **015 Julians-Air: disconnected** (keepalive 17:48Z, IP 192.168.111.108) - transient. 108 alerts/24h (bounded).
- Class A real routing: **0 cases/24h**. 120537 (Redis): 10000/24h (daily cap hit - still flooding).

## FINDING (new this phase): Zeek guardrail cron down ~40h

- `ops/scripts/zeek-classa-guardrail.sh` had lost its executable bit (`100644` in git index);
  cron fired "Permission denied" 161 times (~40h). Integration itself stayed enabled; the
  rate-limit/kill-switch protection was NOT active during that window.
- **FIXED this phase**: chmod +x restored; immediate `check` PASS ("under limit; integration
  enabled"). Git index will be updated to 100755 in the repo commit (prevents recurrence).
- Rollback: script file is git-versioned; re-chmod if ever lost.

## Retention / capacity

- Archives remaining: 08-15..08-24 (08-10 deleted P27). Next wave 08-15 on ~08-29 (7.4GB pending).
- Daily archive growth ~100MB (collapsed). Disk: **root 81%, node 81%**.
- Snapshots: 42 (latest snap-20260824-1517, 54 indices).

## Consolidation inventory (baseline, for 31-48)

- Compose projects (5 running): iris-web (nested git at data/dfir-iris), mct-security-stack
  (3 files), multi-node (3 files), portainer, shuffle (swarm services).
- Containers: ~30 (Wazuh multi-node, IRIS 5, Shuffle swarm, elastiflow, tenzir, opencanary,
  syslog-ng, flow-relay). Swarm mode active (shuffle_swarm_executions, ingress).
- Volumes: ~40. Indices: 65 (~21GB). Data streams: 0 (time-series via daily indices).
- **Findings**: 7 committed `__pycache__/*.pyc` (stale, should be untracked); nested git repo
  in data/dfir-iris/iris-web (gitignored deploy copy, not submodule); 2 scripts
  (`client013-baseline-report.sh`, `endpoint-count-report.sh`) embed a fallback literal
  password (placeholder) (should fail-closed instead); Velociraptor
  `server.config.yaml` holds RSA private keys (gitignored, local-only - OK but must never
  enter bundle).
- Listening: host ports 21/22/1433/1514/1515/15140/3306/8000/9443/2377/7946/33333-39 etc.

## Owner/replacement blockers (carried)

- VT key, PVE222 token (replacement); indexer rotation + PS4104 + Shuffle UI (approval);
  NetFlow scope (operator evidence); Greenbone (signed auth); Redis 120537 (owner).

## No secrets