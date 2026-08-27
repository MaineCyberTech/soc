# Phase 53: IRIS Baseline

**Prompt:** 078-iris-baseline
**Generated (UTC):** 2026-08-27T20:08:35Z
**Operator (EDT):** 2026-08-27T16:08:35-0400
**Verdict:** PARTIAL

## Summary
IRIS baseline: token existence (mode 600), and API health as proven by the LIVE ROUTED PROOF. Version/services/proxy URL not discoverable from safe read-only sources in this batch.

## Evidence
- E1: token file /opt/mct-security-stack/data/shuffle/files/iris-shuffle.env — mode 600 (rw-------), owner user:user, 78 bytes, contains variable IRIS_API_KEY (value NOT printed, gitignored, external to repo).
- E2: LIVE ROUTED PROOF — workflow e133a645 -> IRIS created alert destination_object_id=60 with http_status=200. This proves IRIS API was reachable and accepted the alert at proof time (positive API health).
- E3: .env SHUFFLE_ORG_ID=264c0502-9136-4cfc-938b-390b97b861b8 matches the single org; workflow eb937a37 (wazuh-high-severity-to-iris) and e951db98 (classb) both target IRIS.

## Backup / Rollback
N/A.

## Stop conditions
Owner/TLS-exposure gate if IRIS proxy or service config must be inspected/changed.

## Limitations
IRIS host URL, product version, and proxy configuration are not present in the safe read-only sources available (.env/secret file contain only the key). API health is inferred from the ROUTED proof (object 60), not from a fresh IRIS health call.

## Verdict rationale
Token store verified (600, external) and IRIS API health proven via ROUTED proof; version/services/proxy not enumerable read-only. PARTIAL.
