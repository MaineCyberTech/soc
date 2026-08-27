# IRIS ROUTED Fix — Report

**Report ID:** RPT-20260827-iris-routed-fix-01
**Phase:** 53 (real-work) — IRIS ROUTED remediation
**Title:** ROUTED now creates a real IRIS alert — root cause was a missing value-blind token file, not the Shuffle result-passing quirk
**Date:** 2026-08-27
**Timestamp:** 2026-08-27T19:30:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (fix verified via exact-POST replay → HTTP 200 + real IRIS alert; full workflow execution still gated on UI trigger start)
**Source Path:** /opt/mct-security-stack/ops/reports/generated/phase53-iris-routed-fix.md

## 1. Symptom
The `suricata-packet-routing` workflow (`e133a645-95b9-4e01-9454-e270d2a0b599`) emitted
`AUTH_FAILED` for its `ROUTED` state instead of creating an IRIS alert. Prior diagnosis
attributed this to a Shuffle result-passing quirk (execute_python output not unwrappable
into an HTTP body). **That was incorrect** — the real cause is below.

## 2. Root cause (corrected)
The workflow's single `execute_python` action (`722fb255-…`, Shuffle Tools) performs the
IRIS POST itself via `requests.post(...)` and loads the token from a file:

    def load_iris_token():
        candidates = ["/shuffle-files/iris-shuffle.env", "/run/secrets/iris-shuffle.env"]

During the Phase 53 value-blind pivot the IRIS token was moved to the HTTP-app **header**
(Class-A pattern) and the on-disk token file was never (re)created. With no file present,
`load_iris_token()` returned `None` → `AUTH_FAILED`. The Shuffle result-passing quirk was a
red herring for THIS workflow (it uses raw Python `requests`, not an HTTP-app body built
from execute_python output).

## 3. Fix (value-blind, minimal, durable)
Created the token file at the location the workflow already expects, sourcing the secret from
the approved runtime store and keeping it out of code/repo/exports:

- Path: `/opt/mct-security-stack/data/shuffle/files/iris-shuffle.env`
  (bind-mounted into the backend as `/shuffle-files/iris-shuffle.env`).
- Content: `IRIS_API_KEY=<value from /opt/wazuh-docker/multi-node/ops/creds.env>`.
- Perms: `600` (uid 1000, the backend runtime uid — verified the backend can read it).
- `data/` is gitignored (`.gitignore:11`), so the secret file never enters the repository;
  the workflow CODE contains no secret (it only reads the file).

`execute_python` runs inside the backend process (it calls `self.set_cache_value`,
`self.check_cache_contains`, `self.full_execution`), and the backend has `/shuffle-files`
mounted, so the file is visible at runtime. The mount is a host bind-mount, so the file
survives container recreation (only `docker compose down -v` / volume loss would remove it;
both are out of policy).

## 4. Verification (VERIFIED to the extent possible without UI)
A standalone replay of the EXACT POST the workflow makes (same token, same IRIS URL, same
body) from a container on the `mct-security` network returned:

    HTTP 200
    {"status":"success","data":{"severity":{"severity_id":6,...},"status":{"status_id":2,...}}}

i.e. a real IRIS alert was created (severity Critical, status New). This proves the token is
valid, IRIS is reachable from the Shuffle network, and `iris_post()` will now return 200/201
→ the workflow emits `ROUTED` with a populated `destination_object_id`. A synthetic test alert
was created in IRIS as validation evidence (may be closed/ignored).

## 5. Remaining (UI-gated, unchanged)
- **Trigger start is still UI-only.** REST `POST`/`PUT`/`/start`/`/triggers` all 404/405;
  `suricata-eve-in` (`736b7410-…`) is restored but **stopped**. The owner must Start it in the
  Shuffle UI (runbook `phase53-trigger-start.md`). Once started, the ROUTED path now works.
- The longer-term "correct" migration (HTTP-app node using `${body:…}` references + a branch,
  per AGENTS Credential Handling) remains optional future work; the file-based token is the
  workflow's documented "approved runtime store" pattern and is fully functional.

## 6. Rollback
Remove `/opt/mct-security-stack/data/shuffle/files/iris-shuffle.env` (revert to AUTH_FAILED
behavior). The Shuffle data rollback volume `shuffle-database-rollback-20260827-191004Z`
remains available from the rebuild.
