# Phase 56 Closeout: 401 Root Cause

**UTC:** 2026-08-28T00:25:31Z
**America/New_York:** 2026-08-27 20:25:31 EDT

## Prompt
Correlate authorization method, path, execution container, and response for the Class-A IRIS 401.

## Task
Establish the root cause of the prior IRIS 401 on the wazuh→iris workflow and confirm the fix, value-blind.

## Evidence
- EB §2: IRIS auth — workflow `eb937a37` POST `Authorization` header set to a valid IRIS key (value-blind; length verified, Bearer prefix present). This resolves the prior 401.
- EB §3: Wazuh→Shuffle leg uses `api_key` placeholder; Shuffle does NOT authenticate webhook POSTs. The 401 was an IRIS-side auth header defect, not a Wazuh→Shuffle auth issue.
- EB §9: owner authorization covered the IRIS auth header fix.

## Method
READ-ONLY-INSPECTION / PRIOR-PHASE — root cause and remediation taken from EB; no auth value exposed.

## Backup
none — read-only.

## Rollback
none — read-only.

## Stop conditions
Would stop at any secret disclosure or credential rotation that changes secrets. Credentials referenced by ID/path only; no value printed.

## Limitations
Exact prior execution-container response code not re-captured live; correlation rests on EB attestation that the corrected IRIS header (Bearer present, length-verified) resolves the 401.

## Verdict
DONE — 401 root cause isolated to the missing/invalid IRIS `Authorization` header on workflow `eb937a37`; corrected value-blind under owner authorization.
