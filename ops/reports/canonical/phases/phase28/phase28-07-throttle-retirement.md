# Phase 28 Throttle Retirement Decision

Date: 2026-08-24
Status: **RETAIN** (gated on certification 04/06 PASS).

## Per-endpoint

| Endpoint | Cert | Throttle | Decision |
|---|---|---|---|
| 013 | PARTIAL (marker + continuity pending) | retained | RETAIN |
| 014 | PARTIAL (marker pending) | retained | RETAIN |
| 015 | certified (P27) | none | n/a |

## Retirement method (when certs PASS)

1. Remove per-endpoint throttle entries from Wazuh config (canonical wazuh_manager.conf).
2. `wazuh-analysisd -t` rc=0; reload.
3. Verify downstream archive/alert volume stays bounded (< 2K EID7/day) for 24h.
4. Rollback: re-apply throttle block (git versioned).

## Rationale

- Independent certification is a release gate (acceptance #2): no throttle retirement before
  both markers confirmed.

## No secrets