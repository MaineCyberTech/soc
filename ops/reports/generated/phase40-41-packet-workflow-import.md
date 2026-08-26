# Phase 40 Packet Workflow Import Attempt — IMP-40-01

**Report ID:** phase40-41-packet-workflow-import
**Phase:** 40
**Title:** Import Attempt Record IMP-40-01 — Creation-API Retest Executed Live With MATERIAL DEVIATION (POST Returned 200, Not 401); Artifact Revalidated; Backup/Owner/Rollback Defined; One-Session UI Runbook Retained
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:25:00Z
**Classification:** INTERNAL
**Status:** PARTIAL
**Expected status (tasking):** BLOCKED-UI-GATED — invalidated by live differential, see §3
**Record ID:** IMP-40-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-41-packet-workflow-import.md`

---

## 1. Purpose

Re-execute the packet-workflow import attempt record for Phase 40: (a) live retest of
`POST /api/v1/workflows` with full headers, (b) revalidation of the frozen P39
import-ready artifact, (c) backup/hash/owner/rollback definitions, and (d) retention
of the exact one-session UI import runbook as fallback path.

## 2. Artifact Revalidation (live, today)

```
$ sha256sum ops/evidence/p39-workflow-export/packet-workflow-import.json
8242145e2cf4a24d6d0390e039e50efe7ab79b585faf055468d096fa883d37fc  packet-workflow-import.json
$ python3 -c "import json; json.load(open(...))"
json-valid: OK
size: 20 107 bytes | actions: 13 | branches: 13
name: wazuh-suricata-packet-to-iris | status: "test"
trigger: WEBHOOK custom_url=p39-suricata-test (NOT bound to Wazuh integration)
created/exported: 2026-08-25T22:40:00Z (P39)
```

Hash recomputed 2026-08-26 matches the P39 build record byte-for-byte
(phase39-39 §1). Evidence root treated as immutable; no edits made.

## 3. Live Creation-API Retest — RESULT DEVIATES FROM STANDING FACT

Standing fact carried into this arc (from WF-39-02 / ROUT-39-02): `POST
/api/v1/workflows` → 401 even with valid admin bearer. **Today's controlled
retest did not reproduce the 401.** Probes executed 02:13:30–02:22Z against
`shuffle-backend` (127.0.0.1:5001):

| # | Probe | Auth | Result |
|---|---|---|---|
| A1 | `POST /api/v1/workflows`, minimal probe body, Content-Type set | bearer (container wget) | **200 OK — WORKFLOW CREATED**, id `88456829-068b-48b2-9906-3f3d183ca185`, name `p40-import-probe-minimal` |
| A2 | `GET /api/v1/workflows?limit=3` | bearer | 200 OK; probe present (first entry) |
| A3 | `POST /api/v1/workflows`, same body, **no** Authorization header | none | **401 Unauthorized** (control: auth is enforced) |
| B1 | `DELETE /api/v1/workflows/{probe-id}` (host curl) | bearer | **401** `{"success": false}` — deletion scope-denied |
| C1 | python urllib `GET …limit=1`, raw key **with trailing newline** | bearer(raw) | 401 × repeated (one earlier identical call: 200) |
| D1 | container wget `GET …limit=1`, env-passed key | bearer | 200 OK |
| E1 | host curl `GET`, whitespace-stripped key | bearer | 200 OK |
| F1 | `GET /api/v1/workflows/{id}/executions` | bearer | `{"success": false}` both paths |

### Interpretation (honest, cause UNVERIFIED)

1. **Creation is NOT hard-blocked on this build today.** A fully-formed authorized
   POST succeeded (A1). The P39-era "read works, create does not" conclusion does
   not hold as stated.
2. **Auth middleware behaves inconsistently per verb/client.** DELETE denied while
   POST/GET allowed with the identical key (B1 vs A1/D1); executions sub-endpoint
   denies (F1).
3. **Leading root-cause hypothesis for the historical 401s (UNVERIFIED):** client-side
   key handling — `$(cat config/shuffle-api-key)` embeds a trailing newline into the
   Authorization header for manual curl/python calls (C1 reproduces 401s this way),
   while script/env-sourced usage strips cleanly (D1/E1 = 200). P39's manual curl POST
   fits this pattern; its paired GET ran through different tooling. Alternative
   hypothesis: backend auth behavior changed after today's 00:53Z TLS-proxy deploy /
   restart activity. Neither proven; both recorded.
4. **No simulated PASS anywhere:** the 401 was *expected* per tasking; the 200 is what
   actually happened and is reported as such.

## 4. Residue Created and Cleanup Status (disclosed)

| ID | Item | State |
|---|---|---|
| R-IMP-40-A | Stray probe workflow `p40-import-probe-minimal` (`88456829-068b-48b2-9906-3f3d183ca185`) | PRESENT on platform; inert (default state, trigger unbound, never executed — created 02:14Z, no wiring); **cleanup blocked**: API DELETE scope-denied (B1) → operator must delete via Shuffle UI (Workflows → ⋯ → Delete) or supply a DELETE-scoped key |
| R-IMP-40-B | Per-method API scope gap (DELETE/executions deny for user key) | Documented; feeds Shuffle-hardening backlog |

## 5. Why the Real Artifact Was NOT Imported Via the Now-Working POST

Deliberate hold, three reasons:
1. Frozen artifact carries P39-era values (dedup key `epoch300`, TTL 300, single
   counter, no port/proto/agent mappings) while Phase-40 specs (reports 44–47)
   define refinements (hourbucket key, TTL 3600, syn-/real- namespaces, port/proto/
   agent fields). Importing now bakes in superseded design requiring immediate edit.
2. Given B1 (cannot delete what I create), any import performed by automation would
   leave an operator-dependent residue if wrong.
3. Import method selection (UI session vs API) is an operator-visible posture choice;
   per AGENTS.md, agents do not improvise past gates.

## 6. Backup / Hash / Owner / Rollback Definitions (pre-import, binding)

| Field | Definition |
|---|---|
| Pre-import backup | Copy artifact to `ops/backups/shuffle/packet-workflow-import.pre-import.json` + sidecar `.sha256`; take platform-side export of any prior same-name workflow if one exists (none expected — name absent from live listing) |
| Integrity anchor | sha256 `8242145e2cf4a24d6d0390e039e50efe7ab79b585faf055468d096fa883d37fc` (recomputed §2) |
| Owner | MCT SOC; SOAR ops owner executes import; automation prepares/verifies only |
| Change-register entry | Required (G40 series addendum) before import session |
| Rollback | Imported instance is deletable independently (UI delete; or scoped API key once R-IMP-40-B resolved); evidence artifact untouched; no ossec.conf/Wazuh-side change involved until ROUT-PKT pass ⇒ rollback cannot affect production lanes |

## 7. Exact One-Session UI Import Runbook (fallback / preferred-for-now path)

1. Log into Shuffle UI as operator.
2. Navigate **Workflows** → **Import workflow** (top action bar).
3. Select file `/opt/mct-security-stack/ops/evidence/p39-workflow-export/packet-workflow-import.json`.
4. On the opened canvas **verify 13 actions** present and connected:
   `suricata-eve-in` → `parse-eve-json` → `normalize-fields` →
   `validate-required-fields` → (`synthetic-isolation-check` | `DEADLETTER-malformed`)
   → (`SINK-synthetic-logonly` | `sid-allowlist-filter`) → `datastore-dedup-set` →
   (`counter-routed-increment` | `duplicate-suppressed-logonly`) →
   `iris-test-route-p39tag` → (`done-routed-log` | `DEADLETTER-target-fail`).
5. **Keep the workflow DISABLED** (toggle OFF) and confirm `status="test"`;
   do NOT bind the webhook into any Wazuh integration block.
6. **Save.**
7. Immediately **export-back** (Workflows → Export) the imported instance to
   `ops/evidence/p40-packet-import/packet-workflow-postimport.json`;
   compute sha256 and diff vs §2 anchor. Expect a NON-ZERO hash delta
   (platform normalizes ids/timestamps/positions) — acceptance = structural diff only
   (same 13 labels, same parameter values modulo id regeneration), not hash equality.
8. Record workflow UUID + exported hash + register entry; cleanup R-IMP-40-A in the
   same session if convenient.

## 8. Impact on the Arc

Reports phase40-42…52 remain BLOCKED-RUNTIME (no runtime proofs exist — nothing has
executed). Their blocker text changes from "creation API hard-gated" to "workflow
not yet imported; import path open (UI runbook §7 or API per §3)". ROUT-PKT-40-01
(phase40-53) remains DEFERRED regardless — proofs, volume window, and FP review are
the substance of the deferral, not the import mechanics.

## Verdict

**IMP-40-01: RETEST EXECUTED; EXPECTED BLOCKER INVALIDATED BY LIVE DIFFERENTIAL
(POST=200, DELETE=401); ARTIFACT VALIDATED UNCHANGED; IMPORT DELIBERATELY HELD FOR
OPERATOR SESSION WITH RUNBOOK ARMED; STRAY PROBE DISCLOSED FOR CLEANUP.**

## No secrets
Key material referenced by path only (`config/shuffle-api-key`); no bearer values,
passwords, or tokens appear in this report.
