# Phase 22 Zeek v2.2 Decision

Date: 2026-08-22

## Decision: KEEP v2.2 - ROUTING-READY (enable approval-gated)

| Rule | Verdict |
|---|---|
| 122000/122005/122006 | KEEP - noise controlled (unicast-only residuals; 99.9% reduction) |
| 122001 SSH | KEEP - fires (2/3d), Class A |
| 122002 SMB | KEEP - fires (logtest), Class A |
| 122003 RDP | KEEP - fires (logtest), Class A |
| 122004 admin | KEEP - Class B monitor |

## Routing readiness

- Clean window: 3+ days, total 948 events (~316/day), Class A minimal (2), guards verified.
- Class A verified via logtest + live. **Ready for controlled enable** per phase22-zeek-class-a-routing.md.

## No secrets