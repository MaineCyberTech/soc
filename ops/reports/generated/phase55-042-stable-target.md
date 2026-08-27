# Phase 55: Stable Secret Target

**Prompt:** 042-stable-target
**Generated (UTC):** 2026-08-27T23:30:00Z
**Operator (EDT):** 2026-08-27T19:30:00-0400
**Verdict:** DONE

## Summary
Verify the in-container secret filename is stable and unversioned so that rotation does not break the load path. Confirmed via live service spec, runtime task inspection, and workflow reference. The target `/run/secrets/iris-shuffle.env` is an unversioned, fixed filename independent of any secret version label.

## Evidence
- EV-01 (VERIFIED): `docker service inspect shuffle-tools_1-2-0` shows the secret mount uses `File.Name = "iris-shuffle.env"` (unversioned) under `SecretID 4vpfvc92ice01x52qtc69yi2c`, `Mode 292` (0o444). Resolves to in-container path `/run/secrets/iris-shuffle.env`.
- EV-03 (VERIFIED): Runtime task `e3c9ac86...` lists `/run/secrets/iris-shuffle.env` (mode `-r--r--r--`, 78B) — the same unversioned name persists across tasks.
- EV-04 (VERIFIED): Shuffle API GET of workflow `suricata-packet-routing` (`e133a645-...`) returns `status=active` and contains the string `/run/secrets/iris-shuffle.env` as a primary load target inside `load_iris_token`.

## Backup-Rollback
If a future rotation introduces a versioned `File.Name`, roll back via `docker service update --secret-rm <new> --secret-add source=iris-shuffle-env,target=/run/secrets/iris-shuffle.env` (preserve unversioned target). No change made in this run.

## Stop conditions
None for this inspection. Any future rename to a versioned filename is itself a service-update change (gated) and MUST preserve this unversioned target to avoid breaking the workflow load path.

## Limitations
Rotation was not performed (gated, see reports 043–050). Only the *target stability* is verified against current live state. Evidence covers the packet-routing lane; Class-A uses HTTP-app header wiring (no file-string reference, see 054/055).

## Verdict rationale
DONE — stable, unversioned in-container target VERIFIED by spec (EV-01), runtime (EV-03), and workflow reference (EV-04).
