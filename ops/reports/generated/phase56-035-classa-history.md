# Phase 56: Execution History

**Prompt:** 035-classa-history
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27 20:30:00 -0400
**Verdict:** DONE

## Summary
Found recent Class-A executions read-only from the Shuffle executions API, without creating new ones. 90 executions exist; results indicate IRIS auth failure.

## Evidence
- EV-EXEC-001 (VERIFIED, REST, read-only): `GET /api/v1/workflows/eb937a37-…/executions?limit=200` → array of 90 executions. Sample: `7487d78d-bd21-434d-9a9b-a5b7081293e5` (start 1787871798, FINISHED), `75e4be41-…` (1787871724), `cc397d34-…` (1787859347).
- EV-EXEC-003 (VERIFIED): execution `result` bodies show `{"status": 401, "body": {"status":"error","message":"Authentication required",…}, "url": "https://iriswebapp_nginx:8443/alerts/add", …}` — i.e. Class-A IRIS delivery returns 401 (AUTH_FAILED). Confirms Wazuh→IRIS path is not delivering.

## Backup-Rollback
No mutation. Execution history read-only.

## Stop conditions
GATE: no new executions triggered (would be a write). History inspection only.

## Limitations
Execution `result` parsed from stored JSON; 401 indicates IRIS token/auth issue on Class-A path specifically (suricata path ROUTED OK via carryover). Distal cause (token file scope for Class-A workflow) not remediated (gate 048).

## Verdict rationale
Recent Class-A executions directly retrieved; auth-failure state observed. DONE (history found), with defect surfaced.
