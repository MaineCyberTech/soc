**Report ID:** phase58-024-rotation-01
**Phase:** 58
**Title:** Rotation 01
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T05:13:44Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** ops/reports/generated/phase58-024-rotation-01.md

## Execution
- Contract: read AGENTS + Phase 58 overlay; real, reversible, authorized work; stop at gates; never GET a Shuffle webhook; never expose secret values.

## Evidence (layered)
Rotation plan: classify consumers -> Class-A, Packet, any other. True rotation = generate new IRIS key via web UI, update iris-shuffle-env secret, verify workflows. Reference migration done in P57; this is true rotation.


## Stop conditions
Credential gate: true underlying IRIS token rotation requires IRIS web UI (no admin API). Owner authorized 'Rotate now'.


## Verdict
EXECUTED - rotation runbook documented; manual web UI step required for true underlying token rotation; reference migration completed in P57; workflows value-blind.

## Ground truth
- UTC: 2026-08-28T05:13:44Z | ET: 2026-08-28 01:13:44 EDT
- Class-A: c6b3fcd8 (wazuh-high-severity-to-iris) status=test is_valid=True trigger e3fec000 running LITERAL_IRIS_KEY=False
- Packet: e133a645 (suricata-packet-routing) trigger 736b7410 running LITERAL_IRIS_KEY=False
- Corrupt eb937a37: GET=400 (DELETE=401 RBAC)
- integratord running: True | hook_url=http://shuffle-backend:5001/api/v1/hooks/webhook_e3fec000... | level>=10
- Watchdog: deployed, tested (detects failure, restarts with backoff, max 5/5min)
- IRIS token rotation: runbook documented (manual via web UI required)
