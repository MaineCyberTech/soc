# Phase 20 Zeek Class A Routing Readiness

Date: 2026-08-19
Decision: **MANUAL-ONLY - routing remains disabled** until the clean 24h window (post-v2.2) completes.

## 1. Zeek v2.1/v2.2 validation result

- Noise controlled: post-v2.2 steady state ~0 alerts/min (from ~10-11K/hr pre-deploy).
- Class A candidates (SSH/SMB/RDP) and Class B (admin/UDP) all verified to fire correctly
  via logtest + live counts (122001: 1, 122004: 2 in 8h).

## 2. Class A candidates

| Rule | Fires | Volume | Safe to route after 24h-clean? |
|---|---|---|---|
| 122001 SSH (lvl 8) | yes | ~0 | YES |
| 122002 SMB (lvl 8) | yes (logtest) | 0 | YES |
| 122003 RDP (lvl 8) | yes (logtest) | 0 | YES |
| 122004 admin (lvl 5) | yes | 2/8h | Class B - monitor only |

## 3. Routing posture

- **MANUAL-ONLY** this phase: SOC may open IRIS cases manually for Class A events seen in
  dashboards (none occurred in window). Automated Shuffle routing stays disabled.
- Gate to auto-route: 24h clean window (total Zeek < 50) + operator approval (change control).

## 4. IRIS case template

- Updated for Phase 20: `integrations/dfir-iris/phase20-zeek-case-template.md`.
- Routing plan: `integrations/shuffle/phase20-zeek-routing-plan.md` (prepared, not enabled).

## 5. Guardrails (when enabled)

- Class A only (SSH/SMB/RDP, level 8); explicitly exclude 122004 (admin) and 122006 (UDP) from IRIS.
- One family at a time (SSH first), 24h noise capture, revert if > 5 cases/day.

## No secrets