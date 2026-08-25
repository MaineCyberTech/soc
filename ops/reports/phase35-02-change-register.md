# Phase 35 Change Register

Date: 2026-08-25

| ID | Change | Risk | Approval | Rollback |
|---|---|---|---|---|
| CR-35-01 | Agent 016 eve.json/eve-alert.json reconciliation (source map) | Low | Already applied P34 | Revert ossec.conf |
| CR-35-02 | EVE downstream replay (marked synthetic) | Low | Synthetic, test-only | Remove injected record |
| CR-35-03 | Canary from approved mirrored source | Medium | Requires source identification | Stop traffic |
| CR-35-04 | Disk capacity action (85% watermark) | Low | Monitoring only | N/A |

## Out of scope (unchanged)
- PVE access
- RAM expansion
- Production routing approval (deferred)

## No secrets
