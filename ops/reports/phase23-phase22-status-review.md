# Phase 23 Phase-22 Status Review

Date: 2026-08-22
Reviewed against: `final-phase22-operator-report-20260822-034811.md` + live data.

## 1. Windows 014 Sysmon (P22: throttled flood, tuning blocked)

- **Unchanged**: throttle still active (126 EID7 alerts/24h; archives suppressed); tuning apply
  still blocked on endpoint access. P22 methodology stands.

## 2. macOS 015 (P22: offline, bundle ready)

- **RESOLVED (external)**: agent reconnected 04:22 UTC; archives 0/12h; bounded macos events
  flowing. The Mac-side repair was applied between P22 close and this preflight. P23 shifts
  from "apply" to "validate 24h" (09).

## 3. Agent 013 (P22: power-unconfirmed)

- Unchanged (offline 6d).

## 4. Zeek v2.2 (P22: routing-ready, approval-pending)

- Clean window holds (316/day; Class A 1/24h). Routing preflight (11-13) executable.

## 5. Suricata / retention (P22 held)

- Ingest proven/quiet; retention archives-14d attached (verified).

## 6. Capacity (P22 WARNs)

- **Disk 85% (worsened)** - at low-watermark threshold; top priority.
- **Swap 8.6% (RESOLVED)** - pressure cleared (was 64%); vmstat si=0.
- PVE222 token missing (unchanged).

## 7. Credentials (P22: templated, rotation pending)

- Env abstraction holds; rotations still pending (VT key, indexer password) - 22-24.

## 8. Docs (P22 backlog)

- ARCHITECTURE/STACK-OVERVIEW stale; client-dir headers; evidence banners; branding - 25-28.

## Verdict

P22 baseline largely held; the standout change is 015's reconnect (repair applied externally).
Disk at the low-watermark threshold is the new critical watch item.

## No secrets