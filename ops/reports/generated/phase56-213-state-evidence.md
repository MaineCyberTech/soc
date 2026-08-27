# Phase 56: State Evidence Bundle

**Prompt:** 213-state-evidence
**Generated (UTC):** 2026-08-27T21:30:00Z
**Operator (EDT):** 2026-08-27T17:30:00-0400
**Verdict:** PARTIAL

## Summary
Read-only hashing of the gathered evidence artifacts was performed to anchor the state-evidence bundle. Hashing the *live 13-state run outputs* (execution result bodies) was not possible without executing the workflow (which would create IRIS objects); instead the authoritative source + run-context are hashed as the immutable bundle root.

## Evidence
- EV-EVID-1 (VERIFIED): sha256 of read-only artifacts captured this run:
  - `/tmp/wf.json` (live workflow GET) = `61595ebdfaa31d060d508401577fff91e0047da94e2cc6d83d4e3959df239fd8`
  - `/tmp/wfcode.py` (extracted node source) = `b623e8dd4fd90a4b818e3c362e457c568aba0173f9daf3ae6833fba2b577494e`
  - `phase56-run-context.md` = `772a818659fcc9e286a2276f2d1f4cefdc3ab80adaa9000b41040d3518e52e02`
- EV-WF-2 / EV-WF-5 / EV-OS-3 (VERIFIED): the hashed `wf.json`/`wfcode.py` contain the 13-state machine, cache categories, and backend endpoint — the bundle is self-describing.

## Backup / Rollback
N/A (read-only hashing). The bundle (wf.json, wfcode.py, run-context) is stored under `/tmp/opencode` and `/tmp` (outside repo); promotion to `ops/evidence/` is owner-gated.

## Stop conditions
Hashing of live execution result bodies gate (run-context §5 IRIS-object creation). Bundle currently anchors source + context, not live run output.

## Limitations
- Live per-state execution outputs not hashed (no runs performed).
- `/tmp` artifacts are ephemeral; should be copied to `ops/evidence/` by an owner-authorized step.

## Verdict rationale
Immutable bundle root hashed VERIFIED; full result-set hashing gated. PARTIAL.
