# Phase 55: Packet Lane Baseline

**Prompt:** 171-packet-baseline
**Generated (UTC):** 2026-08-27T23:08:14Z
**Operator (EDT):** 2026-08-27T19:08:14-0400
**Verdict:** DONE

## Summary
Capture the current packet lane baseline: hook -> workflow -> auth -> destination object.
Re-verified live from the trigger object, workflow code, the Swarm secret mount, and the
historical ROUTED execution.

## Evidence (REST / webhook / Wazuh integratord / sensor-origin kept separate)
- E1 (VERIFIED) — hook: `suricata-eve-in` (`736b7410-ed6a-52af-b369-89dbef6386cb`) `status=running`, trigger_type WEBHOOK, bound to workflow `e133a645-…`.
- E2 (VERIFIED) — workflow: `suricata-packet-routing` (`e133a645-…`) `is_valid=true`, single `execute_python` action `parse-eve-json`.
- E3 (VERIFIED) — auth (value-blind): `load_iris_token()` reads candidates `/shuffle-files/iris-shuffle.env` and `/run/secrets/iris-shuffle.env` (the service-scoped Swarm secret `iris-shuffle-env` mount). Token value NEVER read/printed; reference by path/ID only.
- E4 (VERIFIED) — object: historical ROUTED execution `2ce46d4a-…` -> state ROUTED, http_status 200, destination_object_id 67 (IRIS alert), re-read live from `workflowexecution-000001`.
- E5 (VERIFIED) — durability: counter/dead-letter/notification categories live in OpenSearch `org_cache-000001` (160/161/162).

### Separate evidence layers
- REST/webhook: the `736b7410` webhook intake (host `.149` TLS `:3443` per AGENTS) is the test ingress; production bind to Wazuh/Suricata forwarders is owner action (UI-only start).
- Wazuh integratord / sensor-origin: NOT part of the packet lane (Class-A only); packet lane intake is the Shuffle webhook, independent of Wazuh forwarding.

## Backup / Rollback
Read-only; N/A. Workflow reversible revision; secret is service-scoped (no repo secret).

## Stop conditions
None for inspection.

## Limitations
Live replay of a fresh packet not re-fired (see 165); baseline established from trigger + code + secret mount + historical ROUTED.

## Verdict rationale
Packet lane hook/workflow/auth/object all live-verified. Verdict DONE.
