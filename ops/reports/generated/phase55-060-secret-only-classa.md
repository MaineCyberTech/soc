# Phase 55: Secret-Only Class-A (Prove Unaffected)

**Prompt:** 060-secret-only-classa
**Generated (UTC):** 2026-08-27T23:05:00Z
**Operator (EDT):** 2026-08-27T19:05:00-0400
**Verdict:** DONE

## Summary
The newly created swarm secret `iris-shuffle-env` (ID `4vpfvc92ice01x52qtc69yi2c`, mode 0444) is granted only to service `shuffle-tools_1-2-0`. It is NOT granted to any other service, including the Class-A workflow path. Class-A (`wazuh-high-severity-to-iris`) continues to rely on the unchanged bind fallback `/shuffle-files/iris-shuffle.env` (DEFERRED removal, P54). The secret addition is additive and breaks nothing in the Class-A path.

## Evidence
- EV-1 (VERIFIED): Negative grant sweep across all 7 swarm services — only `shuffle-tools_1-2-0` references `iris-shuffle-env`. Class-A path has no grant. (docker service inspect loop)
- EV-2 (VERIFIED): Class-A workflow `wazuh-high-severity-to-iris` present, id `eb937a37-5244-46dc-95ff-62ad4c681322`. Token-load candidates `/shuffle-files/iris-shuffle.env` and `/run/secrets/iris-shuffle.env` both resolve to the same host file consumed via the unchanged bind fallback. (Shuffle API)
- EV-3 (PARTIAL): Class-A workflow status reported as `test` (read-only API). Not re-executed end-to-end; full ROUTED re-proof of Class-A is owner-gated (production routing). Recorded as limitation.

## Backup-Rollback
No change made. Secret is value-blind and reversible via `docker secret rm` (orchestrator-only, gated). Bind fallback retained ensures rollback to pre-secret state without IRIS break.

## Stop conditions
None breached. New approval / secret creation / rotation / production-routing gates not crossed.

## Limitations
Class-A end-to-end ROUTED re-proof not performed (requires trigger / production-routing approval). Wazuh integratord and sensor-origin evidence are SEPARATE layers and not addressed here (Class-A is the Wazuh→IRIS integratord lane).

## Verdict rationale
Secret scope is least-privilege and additive; Class-A isolation from the new secret is proven by the negative grant sweep plus the unchanged bind fallback. REST/webhook/sensor-origin evidence is out of scope and tracked separately.
