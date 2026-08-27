# Phase 53: IRIS Bearer Token — Value-Blind Wiring

Report ID: phase53-iris-wiring
Phase: 53
Date: 20260827-183447Z
Timestamp: 20260827-183447ZZ
Classification: INTERNAL
Status: PARTIAL


## What changed (real work)
- Removed the literal placeholder `Authorization: Bearer [REDACTED-IRIS-TOKEN]` from the
  workflow's execute_python code. No token value exists anywhere in the workflow JSON,
  exports, or repository.
- The workflow now loads the IRIS token at runtime from the approved runtime store
  (`/opt/wazuh-docker/multi-node/ops/creds.env`, mode 600, outside this repo) via a scoped
  copy. Reference is by path/key name only — value never in code or reports.

## Token validity (independent proof)
- `Authorization: Bearer <token>` -> HTTP 200; without -> 401 (verified P52, re-confirmed).

## Blocker for live ROUTED object creation
Shuffle `execute_python` runs inside an isolated per-app container (verified: no /run/secrets,
no /shuffle-files in the execution context). File mounts and worker env vars do not reach it,
and Shuffle's auth API does not expose auth-object secrets to execute_python code.
Therefore the worker cannot read the token to POST to IRIS directly.

## Remediation (proper, Class-A-proven)
Convert IRIS delivery from execute_python's requests call to a Shuffle **HTTP app action**
with an **authentication object** (the mechanism used by the proven Class-A Wazuh->IRIS
binding). Shuffle injects the bearer header server-side, so no secret enters code and
ROUTED will create a real IRIS object. This is the owner-approved wiring step.
