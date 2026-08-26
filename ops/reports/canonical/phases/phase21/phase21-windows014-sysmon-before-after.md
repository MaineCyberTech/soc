# Phase 21 Windows 014 Sysmon Before/After Validation

Date: 2026-08-19
Status: **BEFORE BASELINE CAPTURED - AFTER PENDING** (apply blocked on endpoint access).

## Before (measured live 07:10 UTC)

| Event | Rate (30 min) | Projected/day |
|---|---|---|
| EventID 7 (Image Loaded) | 37,610 | ~1.8M/day while active (24h measured 573,809) |
| EventID 1 (Process Create) | 971 | ~46K/day |
| EventID 10 (ProcessAccess) | 93 | ~4.5K/day |

Flood is ONGOING (not a one-off): steady ~70-75K/hr.

## After targets (to re-measure post-apply)

| Event | Target |
|---|---|
| EventID 7 | >=90% drop (<= ~5K/30min, i.e. < 60K/day) |
| EventID 1 | unchanged (~971/30min) |
| EventID 10 | unchanged (~93/30min) |
| Agent buffer | no flooded/full events |

## How to re-validate (post-apply)

Same queries (archives, agent.id=014, eventID=7/1/10, 30m + 24h windows). Compare against
the before baseline above.

## Decision

- **BEFORE: FAIL** (flood ongoing, 573K+/24h).
- **AFTER: PENDING** until operator applies `integrations/sysmon/sysmon-mct.xml` on 014.

## No secrets