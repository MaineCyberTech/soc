# Phase 35: Phase 35 Remediation Backlog

Date: 2026-08-25

## P0 (Critical — must fix before production routing)
None identified.

## P1 (High — blocks Phase 36)
| Item | Evidence | Risk | Owner | Dependencies | Acceptance |
|---|---|---|---|---|---|
| Build Shuffle detection workflow | No workflow exists | Cannot route alerts | soc@mainecybertech.com | Shuffle UI access | Workflow receives rule 86601 alerts |
| Implement dedup key | No dedup | Alert storms possible | soc@mainecybertech.com | Workflow | Dedup key = rule+agent+hour |
| Daily counter | No counter | Unlimited routing | soc@mainecybertech.com | Workflow | 20/day limit enforced |
| Increase decoder_order_size | 522-field stats cause errors | Log noise | soc@mainecybertech.com | Manager restart | No "Too many fields" errors |

## P2 (Medium — improves operations)
| Item | Evidence | Risk | Owner |
|---|---|---|---|
| Agent 013 reconnection | Disconnected 12h | No coverage | operator-RMM |
| Agent 015 reconnection | Disconnected | No coverage | operator-RMM |
| /tmp Python temp cleanup | 10,195 dirs, 1.6GB | RAM pressure | soc@mainecybertech.com |
| Retention wave monitoring | 08-15 still present | Disk pressure | soc@mainecybertech.com |

## P3 (Low — future improvements)
| Item | Evidence | Risk | Owner |
|---|---|---|---|
| Canary token injection | SPAN read-only | No packet-level canary | soc@mainecybertech.com |
| W1/W2 dashboard views | No custom views | Operator UX | soc@mainecybertech.com |
| PS4104 pilot | Not started | Project scope | soc@mainecybertech.com |

## Phase 36 effect
- P1 items are Phase 36 deliverables
- P2 items are operational maintenance
- P3 items are future phase candidates

## No secrets
