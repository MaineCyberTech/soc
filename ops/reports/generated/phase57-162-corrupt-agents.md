**Report ID:** phase57-162-corrupt-agents
**Phase:** 57
**Title:** Corrupt Agents
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T03:54:26Z
**Classification:** INTERNAL
**Status:** VERIFIED
**Source Path:** ops/reports/generated/phase57-162-corrupt-agents.md

## Execution
- Contract: read AGENTS + Phase 57 overlay; real, reversible, authorized work; stop at gates; never GET a Shuffle webhook; never expose secret values.

## Evidence (layered)
AGENTS: notes eb937a37 corrupted artifact.

## Ground truth
- UTC: 2026-08-28T03:54:26Z | ET: 2026-08-27 23:54:26 EDT
- Class-A: c6b3fcd8-13e5-44a8-a818-024e4ae4422b (wazuh-high-severity-to-iris) status=test is_valid=True trigger e3fec000-555f-4e81-9497-77b7c91c5b98 running LITERAL_IRIS_KEY=False
- Packet: e133a645-95b9-4e01-9454-e270d2a0b599 (suricata-packet-routing) trigger 736b7410-ed6a-52af-b369-89dbef6386cb running LITERAL_IRIS_KEY=False
- Corrupt eb937a37: GET=400 (DELETE=401 RBAC)
- integratord running: True | hook_url=http://shuffle-backend:5001/api/v1/hooks/webhook_e3fec000-555f-4e81-9497-77b7c91c5b98 | level>=10
- Swarm secret iris-shuffle-env mounted (value-blind)
