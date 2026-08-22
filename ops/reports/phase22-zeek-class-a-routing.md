# Phase 22 Zeek Class A Routing (Controlled Enable)

Date: 2026-08-22
Status: **READY TO ENABLE - APPROVAL PENDING** (clean-window evidence satisfied; operator approval required per safety rule).

## 1. Clean-window evidence

- 3+ days v2.2: 948 events (~316/day; pre-tuning 417K/24h = 99.9% reduction).
- Class A minimal (SSH 2/3d; SMB/RDP 0); logtest-verified firing.
- Guards: multicast/broadcast/subnet-broadcast excluded.

## 2. Proposed controlled enable (Class A only)

| Rule | Level | Route |
|---|---|---|
| 122001 SSH | 8 | Wazuh -> Shuffle webhook -> IRIS case (High) |
| 122002 SMB | 8 | same |
| 122003 RDP | 8 | same |
| 122004/122006 | 5/4 | monitor only (excluded from IRIS) |

## 3. Enable steps (on approval)

1. Shuffle: add filter `rule.groups contains mct,zeek` AND level >= 8 AND rule.id in
   {122001,122002,122003} to the existing high-severity webhook (or new webhook).
2. Test webhook with a synthetic Wazuh alert (no live traffic).
3. Enable; monitor case volume 24h (target < 5 cases/day; revert if exceeded).
4. IRIS case per `integrations/dfir-iris/phase20-zeek-case-template.md`.

## 4. Rollback

- Remove/disable the Shuffle filter; IRIS stops receiving Zeek cases. Wazuh alerting unaffected.

## 5. Decision

- **APPROVAL PENDING** - plan ready, not enabled. No automatic routing without approval.

## Files

- `ops/reports/phase22-zeek-class-a-routing.md` (this)
- `integrations/shuffle/phase22-zeek-class-a-routing-plan.md`

## No secrets