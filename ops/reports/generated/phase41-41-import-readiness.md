# Phase 41 Packet Workflow Import Readiness — Artifact Integrity And The Curated-Body Lesson

**Report ID:** phase41-41-import-readiness
**Phase:** 41
**Title:** IMP-READY-41-01 — Import Preconditions Assembled: P40 Trailing-Newline Mystery Closed And Codified; Full-Artifact POST Known-Untrustworthy From Prior Probes; Curated-Subset Body Strategy Declared Before Execution
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:35:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (readiness record; execution recorded in phase41-42)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-41-import-readiness.md`

---

## 1. Why readiness gets its own report

The P40 import attempt failed mysteriously (intermittent 401) and the failure
consumed a session before root cause surfaced. This record pins the
preconditions so the import attempt (phase41-42) starts from solved ground.

## 2. Precondition 1 — token handling [RESOLVED, codified]

Root cause from P40: reading the API key with `$(cat file)` embeds a trailing
newline into the `Authorization: Bearer` header → intermittent 401. Fix
(`tr -d '[:space:]'` / correct `source` handling) is codified in AGENTS.md
(Credential Handling) and applied in all Phase-41 tooling. Status: CLOSED — no
401 of this class may be attributed to transport again without re-proof.

## 3. Precondition 2 — artifact integrity

Import source: the packet-routing workflow JSON as built for the suricata lane,
13 actions, test-only intent, trigger designed stopped. Identity checks
performed at import time: action count == 13, workflow name
`suricata-packet-routing`, no credential-bearing fields in body, status field
asserted `test`. Post-import verification (phase41-43) re-reads the object from
the API rather than trusting the request payload.

## 4. Precondition 3 — curated-body strategy (declared ahead of need)

Prior probe history showed full-artifact POSTs failing where curated bodies
succeeded. Strategy declared in advance:

- POST only: `name`, `description`, `actions`, `branches`, `triggers`,
  `start`, `is_valid`.
- Deliberately stripped: `owner`, `configuration`, and server-owned metadata.
- If POST fails anyway: offender-field isolation **by elimination** — halve the
  included set, bisect, never guess.

## 5. Exit criteria handed to phase41-42

Workflow object retrievable by ID; `status=test`; `is_valid=true`; action count
13; estate count unchanged except +1. All were subsequently met and are
verified live there.
