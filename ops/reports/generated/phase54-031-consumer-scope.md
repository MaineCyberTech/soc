# Phase 54: Workflow Consumer Scope

**Prompt:** 031-consumer-scope
**Generated (UTC):** 2026-08-27T21:28:41Z
**Operator (EDT):** 2026-08-27T17:28:41-0400
**Verdict:** DONE

## Summary
Enumerated which workflows/tasks can read the IRIS credential.

## Evidence
- E1-packet-wf — `suricata-packet-routing` (e133a645-95b9-4e01-9454-e270d2a0b599) executes Python that loads the token from `/shuffle-files/iris-shuffle.env` and POSTs to IRIS; ROUTED proven (alerts 63/64/66).
- E2-classa-wf — `wazuh-high-severity-to-iris` (eb937a37-5244-46dc-95ff-62ad4c681322) also consumes the token to forward Class-A alerts to IRIS.
- E3-exec-app — Both run via Shuffle execution app (shuffle-tools) which inherits the backend's `/shuffle-files` bind, hence both can read the file.
- E4-breadth — Because the mount is the backend's directory bind, ALL workflows executed on that backend (not just the two IRIS workflows) could in principle read the file — over-broad consumer scope.

## Backup / Rollback
N/A.

## Stop conditions
None.

## Limitations
Exact per-node reference resolution (R-PKT-PLATFORM: execute_python cannot receive template vars) confirmed in run-context; the token is read from file, not from a workflow variable.

## Verdict rationale
Only two workflows need the credential, but the directory bind exposes it to all; narrowing reduces consumer scope to the IRIS paths only.
