# Phase 56: Destination History

**Prompt:** 036-classa-destination-history
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27 20:30:00 -0400
**Verdict:** PARTIAL

## Summary
Searched for recent IRIS object-linked executions on the Class-A path. Suricata ROUTED is verified via carryover; Class-A IRIS delivery is failing (401), so no successful Class-A ROUTED object is confirmed in this read-only pass.

## Evidence
- EV-ROUTED-001 (VERIFIED, carryover): Phase 54 exec `2ce46d4a-b071-4331-b175-b40ee2b31692` → IRIS object 67; Phase 55 exec `19791f62…` → IRIS object 68 (HTTP 200). Both on the `suricata-packet-routing` path.
- EV-EXEC-003 (VERIFIED): Class-A (`eb937a37`) execution results return `401` from `iriswebapp_nginx:8443/alerts/add` — no successful Class-A ROUTED object id observed in sampled executions.
- EV-NOTIF-001 (VERIFIED, read-only): `ops/.../shuffle-opensearch-backup-20260827-190604Z/notifications-000001.json` references Class-A executions (`44a81bb8…`, `482ca695…`, `6e8d1753…`, `00030b7a…`) with `workflow_id=eb937a37-…` — monitoring artifacts exist but no IRIS object id linkage shown.

## Backup-Rollback
No mutation. No new IRIS objects created (HARD rule: do not create ROUTED objects via replay).

## Stop conditions
GATE: live ROUTED re-proof / canary (266-288) NOT performed. Carryover evidence used.

## Limitations
Class-A IRIS destination history not positively verified as delivered (401 observed). Suricata ROUTED verified only via prior-phase carryover, not re-proven here.

## Verdict rationale
Suricata destination history VERIFIED via carryover; Class-A destination history shows auth failure, not delivery. PARTIAL.
