# Phase 55: Granted-Service Read Test

**Prompt:** 031-secret-read-positive
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27T20:35:00-0400
**Verdict:** DONE

## Summary
Confirm the GRANTED service (`shuffle-tools_1-2-0`) can see/read the secret file, without outputting its content.

## Evidence
- **EV-031-1 (VERIFIED):** Inside `shuffle-tools_1-2-0.1`, `ls -la /run/secrets/` shows `iris-shuffle.env` present, `-r--r--r-- 1 root root 78` (mode 0444). The file EXISTS and is readable by the granted service.
- **EV-031-2 (VERIFIED):** The file is the swarm-projected copy of `iris-shuffle-env` (Source `iris-shuffle-env`, Target `iris-shuffle.env` per EV-026-2). Read access is granted by the service spec.
- **EV-031-3 (VERIFIED):** Content was NOT read/printed (per AGENTS.md MUST NOT and run-context §5). Only existence, mode, owner, and size were inspected.

## Backup-Rollback
Read-only. No change.

## Stop conditions
None.

## Limitations
This proves existence/readability for the granted service only; it is the positive side of the denial boundary (negative side: 032–035).

## Verdict rationale
Granted service successfully resolves the secret file with correct read-only mode; content withheld. DONE.
