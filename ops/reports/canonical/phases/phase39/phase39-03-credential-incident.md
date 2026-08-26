# Phase 39 Credential Incident Record — INC-39-01

**Report ID:** phase39-03-credential-incident  
**Phase:** 39  
**Title:** INC-39-01 — Confirmed Disclosure of Shuffle Admin Bearer and IRIS Bearer in Repo-Tracked Artifacts  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T22:26:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Severity:** HIGH (contained)  
**Owner:** MCT SOC  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-03-credential-incident.md`  

---

## 1. Incident Summary

| Field | Value |
|---|---|
| Incident ID | INC-39-01 |
| Type | Credential disclosure (repository-tracked artifacts) |
| Classification | **CONFIRMED DISCLOSURE** |
| Credentials affected | Shuffle admin bearer token (API key); IRIS API bearer token |
| Disclosure window | Since ~P36/P37 commit era (`7bd3b82` / `04e689d`) for the Shuffle bearer; P37/P38 export commits for the IRIS bearer |
| Current state | CONTAINED (rotation + invalidation + tracked-set redaction complete) |
| Severity | HIGH — admin-level SOAR API credential in plaintext history and working tree |
| Owner | MCT SOC |

No secret values are reproduced in this or any phase39 report. All values are rendered
as `[REDACTED-SHUFFLE-TOKEN]`, `[REDACTED-IRIS-TOKEN]`, `[REDACTED-PW]`.

## 2. Discovery Chain

1. **P38 security audit** (phase38-84 lineage) flagged 3 locations referencing the
   Shuffle bearer in generated reports, with the value printed at:
   - `phase38-00-master.md:63`
   - `phase38-01-preflight.md:131`
   - `phase38-73-shuffle-hardening.md`
2. **P39 recursion** (this arc, phase39-10 method) expanded the finding set:
   - **13 files** containing the IRIS bearer (`stCG-…` prefix family) across p37/p38
     workflow exports, ingest-pipeline inventory markdown, two p28 txt scan outputs,
     and `phase38-74-shuffle-inventory.md`.
   - **3 additional TRACKED files** still carrying the FULL old Shuffle bearer
     (37-byte match, prefix `0c953f60…`): `phase36-10-shuffle-workflow-status.md:22`,
     `phase36-11-shuffle-auth-failure.md:16`, `phase36-12-shuffle-create-test-manifest.md:6`
     — found during report production and redacted same-session (see phase39-09 §4).
   - `.env:12` (`SHUFFLE_API_KEY=`) — gitignored path, verified untracked.
   - Untracked local backups under `ops/backups/` containing the IRIS bearer
     (6 files) — confirmed NOT git-tracked; retained on disk per protected-evidence
     policy.
3. Aggravating factor: a prior-phase redaction replaced the real IRIS bearer INSIDE the
   live workflow parameter (literal `<REDACTED>` string in the Authorization header),
   corrupting the high-severity workflow's HTTP action JSON. This converted a document
   hygiene problem into an availability fault (delivery chain silent failure).

## 3. Affected Integrations and Consumers

| Consumer | Dependency | Exposure impact |
|---|---|---|
| Ops scripts calling Shuffle REST API | old Shuffle bearer | Full admin API access if reader possessed value |
| `.env` consumers (SHUFFLE_API_KEY) | old Shuffle bearer | Same as above |
| Operator browser sessions | password-based UI login | UNAFFECTED by rotation (password unchanged) |
| Workflow HTTP actions → IRIS | IRIS bearer | Outbound-only credential; leaked via export files |
| Evidence archives (backups dir) | both | Local-only; untracked |

## 4. Containment Actions (executed 2026-08-25 21:58–22:20Z unless noted)

1. **Rotation** of the Shuffle admin bearer (ROT-39-01): datastore update of `users.apikey`
   doc `39dd09d3-7874-46a0-8672-e7acb8827b2c` + backend restart to flush in-memory auth cache.
2. **Invalidation proof** (INV-39-01): old token → HTTP **401** on `GET /api/v1/getusers`
   post-restart; new token → HTTP **200**. Pre-restart old token still returned 200 from
   cache (~22:11Z), demonstrating why restart was mandatory.
3. **Redaction** (RED-39-01..N): all TRACKED secret-bearing files sanitized to placeholders;
   post-redaction grep counts = **0 value hits in tracked set**.
4. **Storage hardening:** new bearer stored ONLY in
   `config/shuffle-api-key` (mode 600, verified `-rw-------`), added to `.gitignore`,
   and updated in `.env` (`SHUFFLE_API_KEY`).
5. **Exposure reduction (compensating):** frontend publish bound to mgmt interface only;
   loopback/docker0 access blocked (live-tested).
6. **Workflow repair:** live Authorization parameter restored to valid JSON (G6) —
   removes the corrupted-artifact vector and re-enables delivery.

## 5. Rotation Prerequisites Checklist (all met before ROT-39-01)

- [x] New storage location prepared with restrictive permissions (mode 600).
- [x] `.gitignore` covers the key file path (verified entry present).
- [x] Dependency map enumerated (phase39-04) so every consumer could be updated.
- [x] Rollback policy decided: forward-only; rollback-to-compromised prohibited.
- [x] UI password login confirmed independent of API key (operator lockout risk = none).
- [x] Restart window acceptable (backend restart ~seconds; no workflow execution in flight).

## 6. Invalidation Test Results (summary; full table in phase39-07)

| Step | Test | Result | Time (UTC) |
|---|---|---|---|
| 1 | Old bearer, pre-restart, GET /api/v1/getusers | HTTP 200 (in-memory cache) | ~22:11Z |
| 2 | Backend restart executed | completed | ~22:12Z |
| 3 | Old bearer, post-restart | **HTTP 401 INVALIDATED** | ~22:13Z |
| 4 | New bearer, post-restart | **HTTP 200 VALID** | ~22:13Z |

## 7. Root Cause

Two compounding process failures:

1. **Report-generation pipeline echoed live credentials** into versioned reports
   (P36–P38 era) instead of placeholders.
2. **A later redaction pass edited live system parameters** rather than documents,
   injecting a placeholder string into a functioning workflow header.

Fixes: rotation (done), tracked-set redaction with grep-zero verification (done),
process rules encoded for AGENTS.md (planned G8): (a) generators must substitute
placeholders before write; (b) redaction never targets runtime configuration.

## 8. Residual Risk (accepted)

- Git **history** retains pre-redaction values (commits ≤04e689d). Mitigation: both
  tokens rotated → historical values are inert. History rewrite evaluated and ruled
  out-of-scope this arc (phase39-10 §6).
- Untracked local backups retain original values on disk; protected-evidence policy
  keeps them local-only, never committed.

## 9. Consolidated Incident Timeline (UTC, 2026-08-25)

| Time | Event | Source |
|---|---|---|
| ≤08-15 | IRIS bearer functioning in delivery chain (alerts 34–35 era) | historical DB rows |
| P36–P37 commits (`7bd3b82` era) | Shuffle bearer printed into tracked generated reports; phase36 reports carry full value | git history |
| ~P37/P38 exports | IRIS bearer echoed into p37/p38 workflow export files | evidence tree |
| P38 window | a redaction pass writes literal `<REDACTED>` INSIDE live workflow parameter → high-severity flow HTTP action JSON becomes invalid → deliveries silently stop | INC root cause #2 |
| P38 audit | security scan flags 3 Shuffle-bearer locations | phase38-84 lineage |
| 21:58–22:05Z | P39 recursion opens: DNS root cause isolated on swarm overlay | ops log |
| 22:06–22:07Z | G5 network connect applied; G6 header repair via API PUT | ops log |
| 22:08:24Z | alerts 37/38/39 created — chain restored, 3 executions FINISHED w/ IRIS 200 | IRIS DB |
| ~22:10–22:11Z | ROT-39-01 datastore write; key file persisted mode 600 | phase39-06 |
| ~22:11Z | INV row 2: old token still 200 pre-restart (cache) | phase39-07 |
| ~22:12Z | backend restart | phase39-06 |
| ~22:13Z | INV rows 4–5: old=401 INVALIDATED / new=200 VALID | phase39-07 |
| 22:14–22:23Z | tracked-set redaction completed incl. phase36 trio found during reporting; catalogs/SUMS refreshed; CI PASS ×2 | phase39-09/11/12 |

## 10. Indicator Handling

No network indicators are associated (disclosure was at-rest, not observed exfil).
The two credential VALUES themselves are treated as burned indicators: both must be
treated as permanently public for this deployment. Detection guidance: alert on any
successful API auth using the OLD bearer prefix family going forward — any such hit
would indicate history-aware attacker activity, not residual validity.

## 11. Communications Record

- MCT SOC owner notified in-window (containment approval basis).
- No client-facing impact: affected credentials are internal operator/integration
  credentials; no client data paths depend on them.
- Operator workforce note: UI password login unaffected; no action required by
  non-SOC staff.

## 12. Lessons Learned Register

| # | Lesson | Corrective item |
|---|---|---|
| L1 | Report generators must substitute placeholders BEFORE writing versioned output | AGENTS.md rule (G8) + generator lint idea (P40) |
| L2 | Redaction tooling must never target runtime parameters — documents only | AGENTS.md rule (G8); caused availability fault |
| L3 | Auth caches make revocation two-step (write + restart) | rotation runbook updated via ROT-39-01 §3 |
| L4 | Scan-for-one-secret finds others: recursion tripled the finding set | recursive sweep now standard arc step (phase39-10) |
| L5 | Evidence exports need hash manifests refreshed whenever sanitized | phase39-11 procedure |

## 13. Verdict

**COMPLETE / CONTAINED.** Disclosure confirmed, root-caused, rotated out, invalidated
with proof, redacted to grep-zero in the tracked set, and exposure compensating-controls
applied. Follow-ups tracked under G8/G11/G12 and Phase 40 pointer items.
