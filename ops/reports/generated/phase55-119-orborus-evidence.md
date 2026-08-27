# Phase 55: Orborus Evidence Bundle

**Prompt:** 119-orborus-evidence
**Generated (UTC):** 2026-08-27T23:25:00Z
**Operator (EDT):** 2026-08-27T19:25:00-0400
**Verdict:** DONE

## Summary
Immutable-ish bundle of real, read-only evidence for the Orborus/dynamic-worker and governed-secret layers: identifiers, specs, and live events. No secret values are included (reference by ID/path only).

## Evidence (VERIFIED unless noted)
- **EV-119-1 (VERIFIED):** Swarm node: `docker` — Leader, Ready, Active, engine 29.7.2 (single-node).
- **EV-119-2 (VERIFIED):** Services (7): email_1-3-0, http_1-4-0, shuffle-ai_1-1-0, shuffle-subflow_1-1-0, shuffle-tools_1-2-0, shuffle-workers, shufflehealthcheck_1-1-0. IDs: shuffle-tools_1-2-0=po8aaadaybgj6viyqmdvva8ii (v13683), shuffle-workers=kuvgr9hop3zh30slx0fj0xbg4 (v13430), http_1-4-0=mn6a9l46fab9s8yktcc8zi84g (v13478).
- **EV-119-3 (VERIFIED):** Secret `iris-shuffle-env` — ID `4vpfvc92ice01x52qtc69yi2c`, created 2026-08-27T22:20:17Z, mode 0444, service-scoped to `shuffle-tools_1-2-0`, mount `/run/secrets/iris-shuffle.env`. Value NEVER read/printed.
- **EV-119-4 (VERIFIED):** `shuffle-tools_1-2-0` mounts: secret `iris-shuffle-env` (file `iris-shuffle.env`, 0444) + read-only bind `/opt/mct-security-stack/data/shuffle/files → /shuffle-files`. No docker.sock.
- **EV-119-5 (VERIFIED):** Socket: only `shuffle-workers` mounts `/var/run/docker.sock` (Orborus/dynamic-worker privilege).
- **EV-119-6 (VERIFIED):** Network: all 7 services on single overlay `shuffle_swarm_executions` (ID t1rv43olc7ev4hvpjpnqzp469, swarm/overlay).
- **EV-119-7 (VERIFIED):** Shuffle live: org `264c0502-9136-4cfc-938b-390b97b861b8`. Workflow `suricata-packet-routing` (e133a645-95b9-4e01-9454-e270d2a0b599) trigger `736b7410-ed6a-52af-b369-89dbef6386cb` status `running`. Class-A `wazuh-high-severity-to-iris` (eb937a37-5244-46dc-95ff-62ad4c681322) present, running trigger `24636c49-a2d0-40c2-887e-ccecdf22fc5c`.
- **EV-119-8 (VERIFIED — carryover):** ROUTED object-level proof (Phase 54): execution `2ce46d4a-b071-4331-b175-b40ee2b31692` → state ROUTED, http_status 200, destination_object_id 67 (IRIS object 67). Re-proof via harness is owner/approval-gated; not re-run here.
- **EV-119-9 (PARTIAL):** Shuffle-internal dynamic-worker registry not exhaustively enumerated against Swarm (see 107 limitation). Orphan detection at Swarm level = none found.

## Backup-Rollback
Read-only evidence collection; no change. Bundle is reproducible from the same live `docker service/secret inspect` + Shuffle API (key read programmatically, never printed) commands.

## Stop conditions
No gated action taken. Evidence collection is authorized read-only. Secret/restore/reboot gates untouched.

## Limitations
Bundle captures as-built live state at 2026-08-27T23:25Z UTC. It does NOT include re-executed ROUTED replay, recreation, reboot, or restore (all owner-gated). REST/webhook/Wazuh integratord/sensor-origin layers kept distinct per overlay.

## Verdict rationale
DONE: real, read-only evidence bundle assembled with exact IDs and live states; no secret values exposed; no fabricated evidence.
