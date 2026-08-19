# Phase 21 Zeek v2.2 Decision

Date: 2026-08-19
Based on: `ops/reports/phase21-zeek-v22-24h-validation.md`

## Decision: KEEP v2.2 - routing-ready for Class A

| Rule | Action | Evidence |
|---|---|---|
| 122000 base | KEEP | ~0/min post-v2.2 |
| 122001 SSH | KEEP / route-ready | fires (logtest + live) |
| 122002 SMB | KEEP / route-ready | fires (logtest) |
| 122003 RDP | KEEP / route-ready | fires (logtest) |
| 122004 admin | KEEP (Class B, monitor) | fires |
| 122005 subnet | KEEP | ~0/min |
| 122006 UDP | KEEP | unicast-only; rare valid events |

## Routing readiness

- Zeek noise: proven controlled (17 alerts/~75min post-v2.2; ~0/min steady).
- Class A (SSH/SMB/RDP) verified firing with low volume -> **candidate for IRIS routing**.
- Final gate: complete the full 24h clean window + operator approval (Phase 21.14).

## No secrets