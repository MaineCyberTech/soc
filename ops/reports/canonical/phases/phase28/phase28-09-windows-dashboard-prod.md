# Phase 28 Windows W1/W2 Production Dashboards

Date: 2026-08-24
Status: **GATED** (cert 08 must be PASS for W2).

## Gating

- W1 (operational overview): gated on 013/014 cert-final PASS (quality-aware panels specified
  P27: EID7 trend, EID1 flow, buffer, freshness, resource).
- W2 (quality/throttle): same gate; reflects throttle retirement per endpoint.

## Enable method (when gated)

1. Import/activate dashboard config (git-versioned under config/dashboards/).
2. Verify panels return data for certified agents only.
3. Rollback: disable dashboard flag.

## Current

- No activation performed this phase (gates not met).

## No secrets