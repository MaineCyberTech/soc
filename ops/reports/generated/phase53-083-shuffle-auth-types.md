# Phase 53: Shuffle Auth Types

**Prompt:** 083-shuffle-auth-types
**Generated (UTC):** 2026-08-27T20:08:15Z
**Operator (EDT):** 2026-08-27T16:08:15-0400
**Verdict:** PARTIAL

## Summary
Reported the authentication type actually deployed for the IRIS integration in Shuffle. Shuffle's app framework supports multiple authentication kinds (e.g. apikey, oauth2, username/password, custom), but the deployed packet-routing workflow does NOT use a Shuffle platform authentication object; it authenticates to IRIS via a runtime apikey read from a file.

## Evidence
- E6: workflow `e133a645` action `execute_python` (Shuffle Tools) has `authentication_id` EMPTY -> no platform auth object bound.
- E6: token delivered as apikey `IRIS_API_KEY` read from `/shuffle-files/iris-shuffle.env` (runtime reference), used as a Bearer/header inside the python node.
- E4: token file `iris-shuffle.env` present, mode 600 (value-blind store outside repo).

## Backup / Rollback
N/A.

## Stop conditions
None.

## Limitations
Could not conclusively enumerate the exhaustive list of Shuffle-supported app auth types via a read-only API in this session; only the deployed type (apikey via runtime file) is directly evidenced.

## Verdict rationale
Deployed auth type is confirmed (apikey via runtime reference). Exhaustive type enumeration not verified -> PARTIAL.
