# Phase 20 Zeek v2.1/v2.2 Decision

Date: 2026-08-19
Based on: `ops/reports/phase20-zeek-v21-24h-validation.md`

## Decision summary

| Rule | Phase 20 action | Rationale |
|---|---|---|
| 122000 (base) | KEEP (v2.2 guard) | unicast-only base anchor; noise controlled |
| 122001 SSH | KEEP | fires (1/8h); high value |
| 122002 SMB | KEEP | clean; high value |
| 122003 RDP | KEEP | clean; high value |
| 122004 admin | KEEP | fires now (2/8h); fixed dead rule |
| 122005 subnet | KEEP | controlled (133/8h) |
| 122006 UDP | KEEP (v2.2) | unicast-only; scan/exfil signal retained |

## Why v2.2

- v2.1 residual 122006 (~600/hr) = subnet-broadcast `192.168.111.255:15600` discovery not
  covered by the multicast guard. Added `\.255$` to the destination guard. Verified via logtest.

## Post-v2.2 rate

- Zeek total ~0/min steady state (06:03=0, 06:04=1). Pre-deploy was ~10-11K/hr.

## Remaining action

- One clean 24h window (post-v2.2) before enabling Class A IRIS routing (Phase 20.06).
- Continue monitoring 192.168.111.72 (source of the subnet-broadcast discovery) - benign
  but a client-network device worth inventorying.

## No secrets