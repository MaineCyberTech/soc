# Phase 56: IRIS Object

**Prompt:** 275-canary-iris
**Generated (UTC):** 2026-08-27T23:29:49Z
**Operator (EDT):** 2026-08-27T19:29:49-0400
**Verdict:** BLOCKED

## Summary
Read-only inspection of IRIS object id/content/label requirements for the canary. No new IRIS object created. Carryover ROUTED IRIS object ids cited; synthetic-labeling policy enforced.

## Evidence
### REST / Webhook (read-only; IRIS token file referenced by path ONLY, never read/printed)
- EV-IRIS-01 (VERIFIED, carryover): Phase 54 ROUTED → IRIS object 67; Phase 55 ROUTED → IRIS object 68. Authoritative ROUTED proofs (run-context §3).
- EV-IRIS-02 (VERIFIED): IRIS token sourced from `/opt/mct-security-stack/data/shuffle/files/iris-shuffle.env` (gitignored, 600); candidates `/shuffle-files/iris-shuffle.env`, `/run/secrets/iris-shuffle.env` (swarm secret `iris-shuffle-env`, ID `4vpfvc92ice01x52qtc69yi2c`, mode 0444, granted to `shuffle-tools_1-2-0` only — Phase 55). Token VALUE never read/printed (AGENTS MUST NOT).

### Synthetic-isolation policy
- EV-SYN-02 (VERIFIED): any canary IRIS object MUST be labeled synthetic and excluded from production billing/scorecards/notifications/client views/queue accounting (overlay + AGENTS). Carryover objects 67/68 must be so labeled.

### Sensor-origin / Wazuh integratord (read-only)
- EV-SNR-14 / EV-INT-17 (VERIFIED): Class-A IRIS object would be created by `wazuh-high-severity-to-iris` (`eb937a37…`, test) reached via integratord `webhook_eb937a37` (non-live, 272) — lane currently broken.

## Backup-Rollback
No mutation (read-only). N/A. If IRIS object later created: immediate synthetic label + exclusion; dead-letter/notification categories `p53_deadletter`/`p53_notifications` guard failures (AGENTS known).

## Stop conditions
Canary EXECUTION (266-288) requires signed Class-A approval + Class-A certified; creating an IRIS object is canary work → BLOCKED. Do NOT create new IRIS objects this pack (run-context §5). Marked BLOCKED — legitimate gate.

## Limitations
No IRIS object created; ids/content from carryover only. Live object content/label not re-derived without execution.

## Verdict rationale
IRIS object creation is canary-execution, gated + synthetic-isolation; read-only carryover + policy inspection only. Verdict BLOCKED.
