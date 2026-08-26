# Phase 25 Zeek Routing Approval

Date: 2026-08-22
Status: **APPROVED (operator, 2026-08-22) - ENABLED.**

## Preconditions verified

| Item | State |
|---|---|
| Class A-only scope | SSH/SMB/RDP only (122001-122003) |
| Dedup keys | rule.id + src + dst + 1h window |
| Replay/idempotency | webhook filter idempotent on (rule.id,timestamp); no replay on retry |
| Rate limit | stop at 5 cases/day + notify |
| Kill switch | disable webhook filter (rollback path documented) |
| IRIS template | phase20-zeek-case-template.md (current) |
| Clean window | 284/24h (holds) |
| Approval marker | **GRANTED 2026-08-22** |

## Decision

- **APPROVED** - see phase25-16 for the enable record.

## No secrets