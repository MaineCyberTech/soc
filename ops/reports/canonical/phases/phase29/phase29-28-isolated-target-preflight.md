# Phase 29 Isolated Target Preflight

Date: 2026-08-24
Status: **CANDIDATE FOUND - NO-GO THIS PHASE** (not operator-approved; resource-constrained for full stack).

## Candidate (reachable)

| Item | Value |
|---|---|
| Host | mct-soc-scan (192.168.222.154) - Debian 13 amd64 |
| CPU/RAM | 4 cores / 5.8GiB (3.4 available) |
| Disk | 118G, 51G free |
| Access | root SSH (dedicated key) |
| Isolation | internal LAN 192.168.222.0/24 (logical, not air-gapped) |

## Assessment

- **Adequate for a reduced single-node proof** (single-node Wazuh + subset) - NOT for the
  full multi-node production stack (3 indexers + managers + IRIS + Shuffle + flow require
  far more than 5.8GiB).
- Operator has NOT designated/approved it as the isolated deployability target.
- Snapshot access to /snapshots volume not arranged; teardown plan not approved.

## Decision

- **NO-GO** for full-stack fresh-target deployment this phase. Documented as the Phase 30
  candidate pending: operator approval, resource upgrade (or reduced-scope proof), and
  snapshot/repo access.

## No secrets