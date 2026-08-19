# Phase 21 Zeek v2.2 24h Validation

Date: 2026-08-19
Window: v2.2 deployed 08-19 ~06:00; measured to 07:15 (~75 min) + preflight window from P20.

## 1. Zeek v2.2 counts (post-restart window)

- Total since 06:02: **17 alerts** (~0.2/min): 122000 x11, 122006 x6. No Class A/B (122001-122004) events.
- Residual broadcast/multicast: **controlled**. Last 30 min (06:45-07:15): ~0.
- Compare: pre-v2.2 ~600/hr subnet-broadcast residual; pre-v2.1 ~10-11K/hr.

## 2. Residual noise assessment

- No subnet-broadcast/multicast noise since the `\.255$` guard. The 6 x 122006 are rare
  unicast UDP events (valid signal, not noise).

## 3. Class A sample tests

- logtest (P20): SSH 22 -> 122001 (lvl 8); SMB 445 -> 122002; RDP 3389 -> 122003; admin ports -> 122004. All PASS.
- Live: 122001 fired (1/8h in P20 window), 122004 fired (2/8h). Class A rules functional.

## 4. Keep/tune/disable decision

- **KEEP v2.2 as-is. Routing-READY** for Class A after the full 24h window completes (currently
  ~19h of clean data since P20 close + this window; next phase confirms the final 24h).
- No over-suppression; no under-detection identified.

## Files

- `ops/reports/phase21-zeek-v22-24h-validation.md` (this)
- `integrations/security-onion/phase21-zeek-v22-decision.md`

## No secrets