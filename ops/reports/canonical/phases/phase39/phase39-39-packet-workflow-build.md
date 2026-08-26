# Phase 39 Packet Workflow Build Record — WF-39-02

**Report ID:** phase39-39-packet-workflow-build  
**Phase:** 39  
**Title:** Import-Ready Packet Workflow Artifact Finalized and Validated; Raw-API Creation Attempted → 401 (UI-Gated Confirmed)  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T23:00:38Z  
**Classification:** INTERNAL  
**Status:** NOT-BUILT-API-GATED — artifact COMPLETE, platform creation blocked  
**Record ID:** WF-39-02  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-39-packet-workflow-build.md`

---

## 1. Deliverable

`ops/evidence/p39-workflow-export/packet-workflow-import.json`
(20 107 bytes; sha256 `8242145e2cf4a24d6d0390e039e50efe7ab79b585faf055468d096fa883d37fc`)
— finalized from the P38 skeleton into a full import-shaped document following the
estate's real export schema (13 actions, 13 branches, webhook trigger stub
`custom_url=p39-suricata-test`, `status:"test"`).

## 2. Pipeline Coverage vs Requirements

| Requirement | Node(s) | Implementation |
|---|---|---|
| Normalization (Set-Field) | `normalize-fields` | maps `alert.signature_id`, `src_ip`, `dest_ip`, `timestamp`, `alert.severity` |
| Required-field validation | `validate-required-fields` | regex `^[0-9]+\|.+\|.+` over sid/src/dst composite → fail arm to malformed |
| Synthetic isolation branch | `synthetic-isolation-check` + `SINK-synthetic-logonly` | tags contain `synthetic` → sink/no-op BEFORE allowlist/route |
| SID allowlist | `sid-allowlist-filter` | `^(2027967)$` (canary first; ET-Open expansion pool documented in BASE-39-01) |
| Datastore dedup TTL 300 s | `datastore-dedup-set` / `duplicate-suppressed-logonly` | key `sid-src_ip-dst_ip-epoch300`; duplicate arm = suppress+log |
| Counter increment | `counter-routed-increment` | datastore key `p39_packet_counter_routed` |
| Malformed branch | `DEADLETTER-malformed` | also catches non-allowlisted sid (drop-with-record) |
| Test route with tag p39-test | `iris-test-route-p39tag` | HTTP POST `https://iriswebapp_nginx:8443/alerts/add`, title prefix `[p39-test]`, tags include `test:p39`, sev 6/cust 1 |
| Failure try/catch | success/failed arms on the HTTP action → `done-routed-log` / `DEADLETTER-target-fail` | no silent crash path |

Branch integrity machine-checked: every branch source/destination references an
existing action id.

## 3. JSON Validation (real output)

```
written ops/evidence/p39-workflow-export/packet-workflow-import.json
VALID JSON via json.load: True
name: wazuh-suricata-packet-to-iris | actions: 13 | branches: 13
branch integrity (all sources known): True | all dests known: True
```

## 4. API Creation Attempt — Honest Outcome

Attempted `POST /api/v1/workflows` with the admin key (same auth that successfully
lists workflows), full import body:

```
returncode: 1
STDERR(head):   HTTP/1.1 401 Unauthorized
STDOUT(head): <empty>
```

Differential probe to rule out key invalidity:

```
GET /api/v1/workflows?limit=5 with same key : OK
POST /api/v1/workflows minimal probe body    : HTTP/1.1 401 Unauthorized
```

**Conclusion: workflow creation via raw API is auth-blocked for user-level keys on
this build — read works, create does not.** This matches the standing estate finding
that workflow creation is UI-gated (undocumented/unstable API surface). The artifact
is therefore import-ready for the UI path (Workflows → Import) or future operator-run
API provisioning.

## 5. Import Steps (documented)

UI path:
1. Shuffle → Workflows → **Import workflow** → select
   `packet-workflow-import.json`.
2. Verify canvas connectivity (trigger → parse → … → done/dead-letters).
3. Confirm `status="test"`; leave trigger unbound.
4. Store generated webhook id (future CFG use) without wiring ossec.conf.

API path (attempted this phase): `POST /api/v1/workflows` → **401 Unauthorized**
(recorded above); retest only if Shuffle is upgraded or an integration-scoped key
becomes available.

## Verdict

**WF-39-02: ARTIFACT COMPLETE AND VALIDATED; PLATFORM BUILD BLOCKED BY AUTH GATE.**
Replay/failure matrices (phase39-40/-41) proceed as protocol-only.
