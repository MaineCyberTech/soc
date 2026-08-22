# Phase 22 Zeek v2.2 Final Clean-Window Validation

Date: 2026-08-22
Window: 08-19 06:02 UTC -> 08-22 03:30 UTC (~3 days, 3h+ of clean data)

## 1. Full-window counts

| Rule | Count (3d) | Verdict |
|---|---|---|
| 122000 (base) | 689 | informational, unicast only |
| 122005 (subnet) | 209 | unicast internal traffic |
| 122006 (UDP) | 46 | rare unicast UDP (valid) |
| 122001 (SSH) | 2 | Class A - fires, minimal |
| 122004 (admin) | 2 | Class B - fires, minimal |
| 122002 (SMB) / 122003 (RDP) | 0 | clean |
| **Total** | **948 (~316/day)** | vs 417K/24h pre-tuning = **99.9% reduction** |

## 2. Noise guards confirmed

- Remaining 122005/122006 destinations: unicast only (192.168.111.61, public IPs; ports
  443/80/554/44818). Only 6 events to 192.168.111.255 (subnet-broadcast) in 3 days (was 3K+/day).
- logtest: mDNS multicast and subnet-broadcast samples -> NO MATCH. Guards hold.

## 3. Class A sample tests (logtest, safe)

- SSH 22 -> 122001 level 8: FIRES
- SMB 445 -> 122002 level 8: FIRES
- RDP 3389 -> 122003 level 8: FIRES

## 4. Over/under-detection

- No over-suppression (Class A/B fire on unicast targets). No under-detection found.

## 5. Decision

- **ROUTING-READY**: clean-window evidence satisfied (3 days, noise < 1% of pre-tuning, Class A
  minimal + verified). Final enable is approval-gated (Phase 22.11).

## Files

- `ops/reports/phase22-zeek-v22-final-validation.md` (this)
- `integrations/security-onion/phase22-zeek-v22-decision.md`

## No secrets