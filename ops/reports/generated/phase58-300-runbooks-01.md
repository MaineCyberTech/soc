**Report ID:** phase58-300-runbooks-01
**Phase:** 58
**Title:** Runbooks 01
**Date:** 2026-08-28
**Timestamp:** 2026-08-28T05:13:44Z
**Classification:** INTERNAL
**Status:** VERIFIED
**Source Path:** ops/reports/generated/phase58-300-runbooks-01.md

## Execution
- Contract: read AGENTS + Phase 58 overlay; real, reversible, authorized work; stop at gates; never GET a Shuffle webhook; never expose secret values.

## Evidence (layered)
Risks: integratord auto-start gap (mitigated by watchdog), corrupt eb937a37 (harmless).

## Ground truth
- UTC: 2026-08-28T05:13:44Z | ET: 2026-08-28 01:13:44 EDT
- Class-A: c6b3fcd8 (wazuh-high-severity-to-iris) status=test is_valid=True trigger e3fec000 running LITERAL_IRIS_KEY=False
- Packet: e133a645 (suricata-packet-routing) trigger 736b7410 running LITERAL_IRIS_KEY=False
- Corrupt eb937a37: GET=400 (DELETE=401 RBAC)
- integratord running: True | hook_url=http://shuffle-backend:5001/api/v1/hooks/webhook_e3fec000... | level>=10
- Watchdog: deployed, tested (detects failure, restarts with backoff, max 5/5min)
- IRIS token rotation: runbook documented (manual via web UI required)
