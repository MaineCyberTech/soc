# Phase 55: Orborus Durability Certificate

**Prompt:** 116-orborus-cert
**Generated (UTC):** 2026-08-27T23:25:00Z
**Operator (EDT):** 2026-08-27T19:25:00-0400
**Verdict:** PARTIAL

## Summary
Durability certificate for the Orborus/dynamic-worker layer, itemizing proven layers (verified read-only) versus deferred layers (owner-gated recreation/recovery). "Orborus" in this deployment is the Shuffle dynamic-worker orchestrator realized as the `shuffle-workers` service plus the backend scheduler; no separate `orborus` Swarm service exists.

## Evidence (proven layers — VERIFIED)
- **EV-116-1 (VERIFIED):** Swarm topology: single Leader node `docker` (Ready/Active/Leader, engine 29.7.2). Manager quorum intact.
- **EV-116-2 (VERIFIED):** Service resilience: 7 services, 6 at 2/2 replicas, `shuffle-workers` at 1/1; all Running. (email_1-3-0, http_1-4-0, shuffle-ai_1-1-0, shuffle-subflow_1-1-0, shuffle-tools_1-2-0, shuffle-workers, shufflehealthcheck_1-1-0.)
- **EV-116-3 (VERIFIED):** Socket privilege bounded: only `shuffle-workers` mounts `/var/run/docker.sock` (Orborus function); secret-bearing `shuffle-tools` does NOT (see 109).
- **EV-116-4 (VERIFIED):** Secret durability at spec level: `iris-shuffle-env` (ID 4vpfvc92ice01x52qtc69yi2c, mode 0444) granted service-scoped to `shuffle-tools_1-2-0` and mounted as `/run/secrets/iris-shuffle.env` (Phase 54 carryover).
- **EV-116-5 (VERIFIED):** Live ROUTED readiness: trigger `736b7410-ed6a-52af-b369-89dbef6386cb` on workflow `suricata-packet-routing` (e133a645-...) status `running`; Class-A `wazuh-high-severity-to-iris` (eb937a37-...) present with a running trigger (id 24636c49-...). (ROUTED object-level PARITY is Phase 54 VERIFIED: exec 2ce46d4a → IRIS object 67; re-proof via harness is owner/approval-gated.)
- **EV-116-6 (VERIFIED):** Least-necessary networking: every service on single overlay `shuffle_swarm_executions` (110).

## Evidence (deferred layers — UNVERIFIED, owner-gated)
- **EV-116-7 (UNVERIFIED):** Service recreation — not executed (111/112 owner-gated).
- **EV-116-8 (UNVERIFIED):** Orborus/`shuffle-workers` recreation after failure — not exercised.
- **EV-116-9 (UNVERIFIED):** Host reboot recovery (113/114) and manager recovery (115) — not executed.
- **EV-116-10 (UNVERIFIED):** Full restore rehearsal — NO-GO until owner-approved external target (AGENTS.md known blocker).

## Backup-Rollback
Proven layers are read-only. Deferred layers each have a documented rollback path in 111/113/115 plans. No mutation performed in this batch.

## Stop conditions
Service deletion, host reboot, full restore, and recreate drills are owner-gated (run-context §4). This certificate documents proven vs deferred without executing any gated action.

## Limitations
Durability is certified for the as-built live spec (current-state proven), NOT for disaster-recovery recreation/recovery, which remains owner-gated and unexercised. REST/webhook/Wazuh/sensor-origin evidence kept separate.

## Verdict rationale
PARTIAL: as-built Orborus/dynamic-worker layers are verified durable (replication, socket scoping, secret spec-persistence, trigger running, single network); recreation/recovery/restore layers are deferred to owner approval and unverified. No fabricated DR evidence.
