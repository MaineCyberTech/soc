# Phase 40 Packet Normalization Control — Packet-Normalize-40-01

**Report ID:** phase40-42-packet-normalization
**Phase:** 40
**Title:** Normalization Control Specification (Field Mapping From Frozen Artifact + Phase-40 Amendment Set), Expected Behavior, and Proof Protocol — BLOCKED-RUNTIME
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:26:30Z
**Classification:** INTERNAL
**Status:** BLOCKED-RUNTIME
**Record ID:** PACKET-NORMALIZE-40-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-42-packet-normalization.md`
**Design anchor:** `ops/evidence/p39-workflow-export/packet-workflow-import.json` (sha256 `8242145e…37fc`, json-valid, 13 actions)

---

## 1. Blocker (explicit)

The workflow `wazuh-suricata-packet-to-iris` does not exist on the platform — no
import has landed (IMP-40-01, phase40-41). No normalization node has ever executed.
This report fixes the control specification and proof protocol so runtime
verification is mechanical post-import. **No simulated PASS is claimed.**

Lane context: the high-severity lane is production-proven end-to-end today via the
webhook (E2E-007 chain: flow_id 999000777 → exec b6d07492 → IRIS row 42 @01:28:57Z;
phase40-37/-40). The packet lane shares the sensor (agent 016 `mct-packet-sensor`)
→ analysisd → integratord → Shuffle path but uses its own isolated workflow,
webhook, and controls per design.

## 2. Control Design — As Frozen in the Artifact (exact values)

Node `normalize-fields` (Shuffle Tools `set_fields`, id `7a12f309-f3a0-540c-bd26-70c0a4e5a34d`),
fed by `parse-eve-json` (`json_dumps`, input `$exec`):

| Target field | Source expression (verbatim) | Present in frozen artifact |
|---|---|---|
| `sid` | `${parse-eve-json.alert.signature_id}` | YES |
| `src_ip` | `${parse-eve-json.src_ip}` | YES |
| `dst_ip` | `${parse-eve-json.dest_ip}` | YES |
| `timestamp` | `${parse-eve-json.timestamp}` | YES |
| `severity` | `${parse-eve-json.alert.severity}` | YES |

Downstream consumers of these five names (frozen): validation composite (§43),
dedup key, IRIS body (`alert_title`, `alert_source_ref`,
`alert_source_event_time`), dead-letter logs.

## 3. Control Design — Phase-40 Amendment Set (required at import/first-edit)

Tasking requires the packet lane to normalize the fuller Suricata field surface.
The following mappings are NOT in the frozen artifact and are flagged
AMENDMENT-PENDING-IMPORT (apply in the import session; register entry; artifact
re-hash afterwards):

| # | Target field | Source expression (planned) | Purpose |
|---|---|---|---|
| A1 | `src_port` | `${parse-eve-json.src_port}` | dedup key component (45), richer triage |
| A2 | `dst_port` | `${parse-eve-json.dest_port}` | dedup key component (45) |
| A3 | `proto` | `${parse-eve-json.proto}` | validation reject-rule (43), dedup precision |
| A4 | `agent` | `${parse-eve-json.agent.id}` | provenance (sensor identity, cf. agent 016) |
| A5 | `category` | derived: `${parse-eve-json.alert.category}` with literal fallback `packet` | category derivation |
| A6 | `severity_map` | fixed map: alert.severity 1→low, 2→medium, else high; IRIS `alert_severity_id` stays fixed 6 during test era | severity derivation (matches frozen IRIS body) |
| A7 | `synthetic_marker` | passthrough of `tags` array verbatim | feeds isolation check (44) |
| A8 | `test_id` | passthrough `MCT_TEST_ID` when present (empty otherwise) | replay/evidence correlation |
| A9 | `tenant` | constant `customer_id=1` (internal test tenant until certification) | tenant/client constant |
| A10 | `routing_class` | constant literal `packet` | lane tagging; exclusion filters in 44 |

## 4. Expected Behavior (acceptance semantics)

| # | Behavior | Pass condition |
|---|---|---|
| N1 | All five frozen mappings populate on a well-formed EVE alert | normalized output contains correct non-empty sid/src_ip/dst_ip/timestamp/severity matching input |
| N2 | Amendments A1–A10 populate post-edit | each present with correct type (ports/proto scalar strings, agent scalar, arrays passthrough) |
| N3 | Missing optional input (e.g., no `alert.category`) | derivation falls back per A5/A6 rules — never emits literal `${…}` template residue |
| N4 | Malformed input reaching normalization | normalization itself does NOT crash the run; downstream validation (43) owns rejection — fail-closed ordering preserved |
| N5 | Marker fidelity | `synthetic` substring and `MCT_TEST_ID` survive normalization bit-exact (isolation depends on it) |

## 5. Proof Protocol (ready-to-run post-import; expectations only)

1. Import + apply amendments (§3) in the operator session; leave disabled→enable
   only for the test window.
2. Build one marked canary sample (EVE-shaped, sid 2027967,
   `"tags":["synthetic","MCT_TEST_ONLY=true","MCT_TEST_ID=P40-NORM-001"]`,
   src/dst/ports/proto populated) and POST to the captured webhook URL.
3. Open the execution record → select `normalize-fields` node → export output JSON
   to `ops/evidence/p40-packet-runtime/norm-sample-001.json`.
4. Assert N1/N2/N3/N5 programmatically (field-by-field compare vs input sample).
5. Negative control: second sample omitting `dest_ip` → assert normalized
   `dst_ip` empty AND run terminates at `DEADLETTER-malformed` (ties to 43);
   assert nothing reached allowlist/dedup/route nodes.
6. Record execution IDs + node outputs; any mismatch = FAIL for this control and
   blocks ROUT-PKT precondition intake.

Evidence retention: raw execution exports under `ops/evidence/p40-packet-runtime/`,
hashes into the successor report. Results columns stay EMPTY until run.

## 6. Fail-Closed Ordering Note

Normalization sits strictly between parse and validation in the frozen branch
topology; there is no edge from normalization to datastore/counter/route except
through validation and isolation checks. This ordering is load-bearing for
controls 43/44/45 and must be preserved verbatim through any amendment edit.

## Verdict

**BLOCKED-RUNTIME.** Design fully specified (5 frozen mappings + 10 amendments);
proof protocol pre-committed; zero runtime evidence exists; nothing will be
asserted as passing until a real execution is exported and hashed.
