# Phase 56: Identifier Map

**Prompt:** 034-classa-id-map
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27 20:30:00 -0400
**Verdict:** DONE

## Summary
Mapped the Class-A identifiers: workflow id, source trigger id, live hook id, integratord hook URL, and the suricata counterpart — clarifying the mismatch.

## Evidence (identifier map)
- `eb937a37-5244-46dc-95ff-62ad4c681322` → **Workflow** `wazuh-high-severity-to-iris` (status `test`). [EV-WF-001]
- `24636c49-a2d0-40c2-887e-ccecdf22fc5c` → **Source trigger id** (in workflow def, status `running` in source) — but NOT live. [EV-WF-001, EV-TRIG-001]
- `webhook_eb937a37-5244-46dc-95ff-62ad4c681322` → **Integratord hook_url** target (references the WORKFLOW id, not the trigger id). [EV-CFG-001]
- `webhook_24636c49-a2d0-40c2-887e-ccecdf22fc5c` → the hook URL that WOULD correspond to the live trigger id — NOT present in live trigger service. [EV-TRIG-001]
- `736b7410-ed6a-52af-b369-89dbef6386cb` → **Live** webhook `suricata-eve-in` (running), workflow `e133a645-…`. The ONLY live webhook. [EV-TRIG-001, EV-WF-002]
- `e133a645-95b9-4e01-9454-e270d2a0b599` → Workflow `suricata-packet-routing` (active, ROUTED proven). [EV-ROUTED-001]

## Backup-Rollback
No mutation. Map is documentation; any correction is owner-gated Class-A repair 048.

## Stop conditions
GATE: no trigger/hook recreation performed.

## Limitations
Map derived from API + config (read-only). Live Wazuh→Shuffle POST not replayed.

## Verdict rationale
All requested identifiers mapped with cross-references; mismatch (integratord→workflow id, live trigger absent) explicitly stated. DONE.
