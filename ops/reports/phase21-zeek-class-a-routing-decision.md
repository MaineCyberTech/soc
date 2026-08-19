# Phase 21 Zeek Class A Routing Decision

Date: 2026-08-19
Decision: **MANUAL-ONLY - auto-route NOT enabled** (gated on final 24h window + approval).

## Basis

- Zeek v2.2 noise proven controlled (~0/min; 17 alerts/~75min post-restart).
- Class A candidates (122001 SSH / 122002 SMB / 122003 RDP) verified firing via logtest + live.
- Class B (122004 admin, 122006 UDP) keep monitor-only.

## Routing posture

- **Manual-only**: SOC may open IRIS cases manually for Class A events (none this window).
- **Auto-route enable**: after the full 24h clean window completes (target: total Zeek < 100
  and Class A < 5) AND operator approval via change control. No broad routing.

## Plan

- `integrations/shuffle/phase21-zeek-class-a-routing-plan.md` prepared (Class A only, excludes
  122004/122006). Not enabled.

## No secrets