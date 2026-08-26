# Phase 22 Agent 015 Reconnect, Volume, and Queue Validation

Date: 2026-08-22
Status: **NOT VALIDATED - agent offline** (repair blocked on Mac access).

## 1. Keepalive / group

- 015 `disconnected` since 08-18 09:04 UTC (~4 days). Group: `mac-clients` (unchanged).

## 2. Volume (pre-fix baseline for comparison)

- Flood baseline: 08-16 1,387,891 / 08-17 1,195,709 archive docs/day; peak 127,504/hr.
- Current: ~0 (offline).

## 3. Queue

- Queue-full pattern documented (P18 ~204/24h under flood); no queue events while offline.

## 4. Post-repair validation targets

| Check | Target |
|---|---|
| 15m volume | < 3,000 docs |
| 1h volume | < 10,000 docs |
| 24h volume | <= 50,000 docs (>=95% vs flood baseline) |
| queue-full | 0 in 24h |
| Bounded telemetry present | auth/sudo/loginwindow/securityd events visible (rules 203/204/533/5407) |
| Keepalive | continuous, no gap > 5 min |

## 5. Decision

- **FAIL (pre-repair)**. Re-run after operator applies `integrations/macos/remediation-bundle/`.

## No secrets