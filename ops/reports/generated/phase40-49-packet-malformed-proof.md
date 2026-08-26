# Phase 40 Packet Malformed-Input Protocol — MAL-PKT-01

**Report ID:** phase40-49-packet-malformed-proof
**Phase:** 40
**Title:** Malformed Protocol MAL-PKT-01 (BLOCKED) — Sample Definitions (Truncated JSON / Missing Fields / Wrong Types / Unknown SID), Nowhere-Routing Expectations, Zero Mutation, Thresholded Operator Evidence
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:37:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-RUNTIME
**Record ID:** MAL-PKT-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-49-packet-malformed-proof.md`
**Design anchor:** `ops/evidence/p39-workflow-export/packet-workflow-import.json` (sha256 `8242145e…37fc`)
**Companion to:** FAIL-39-02 matrix (phase39-41), cases M1-class, restated for Phase 40

---

## 1. Blocker

Workflow absent from platform (IMP-40-01); no malformed sample has ever been
processed by the packet lane. Samples and expectations are pre-committed here so
post-import testing is mechanical. **No simulated PASS; all result cells empty.**

## 2. Malformed Sample Set (definitions)

| ID | Class | Payload definition |
|---|---|---|
| P1 | truncated JSON | valid EVE prefix cut mid-object: `{"timestamp":"2026-…","event_type":"alert","src_ip":"10.66.` |
| P2 | missing sid | full EVE shape, `alert.signature_id` absent |
| P3 | missing src_ip | `src_ip` key removed |
| P4 | missing dst_ip | `dest_ip` key removed |
| P5 | wrong type sid | `"signature_id":"EICAR-NOT-NUMERIC"` |
| P6 | wrong type port | `"dest_port":"high"` (non-numeric where numeric required) |
| P7 | unknown sid | well-formed, `"signature_id":9999999` — non-allowlisted |
| P8 | unknown event_type | `"event_type":"flow"` with otherwise complete fields |

## 3. Expected Outcomes (nowhere-routing)

| ID | Frozen-build path | Amended-build path | Side effects allowed |
|---|---|---|---|
| P1 | parse/normalize fails → run takes failed arm → DEADLETTER-malformed terminal | same | none beyond execution record + day-bucket reject counter |
| P2–P4 | validation regex fail → DEADLETTER-malformed | same (6-tuple regex extends coverage to ports) | none |
| P5 | validation regex fail (sid non-numeric) → DEADLETTER-malformed | same | none |
| P6 | frozen: passes validation (ports unmapped) → allowlist decides on sid alone | amended: V3/V5 guard rejects pre-dedup → dead-letter | none in either era (honest note: frozen build's protection for P6 is incidental via allowlist/dedup-tuple coarseness — amendment makes it explicit) |
| P7 | allowlist-miss drop-with-record → DEADLETTER-malformed arm | unchanged | none |
| P8 | frozen: NOT rejected (event_type unchecked) — would flow if fields present | V4 rejects → dead-letter | frozen-era gap DISCLOSED; amendment mandatory before certification |

Universal acceptance rule (identical to FAIL-39-02): **every run terminates in an
explicitly-recorded terminal branch — never hangs, never routes garbage, never
emits a partial alert.**

## 4. Zero-Mutation Assertions (per sample)

| Surface | Required delta |
|---|---|
| IRIS alerts table | 0 rows |
| `real_packet_routed_total` | unchanged |
| dedup key-space | no new keys (P6/P8 especially must not materialize keys) |
| billing/scorecard snapshots | byte-identical |
| counters generally | only sanctioned day-bucketed reject buckets move |

## 5. Thresholded Operator Evidence Only

Malformed traffic must generate evidence WITHOUT becoming an operator-noise or
storage hazard:
- per-run evidence = dead-letter log line (`raw=${exec}` capture) inside the
  execution record — retained by platform retention, not duplicated;
- aggregate evidence = day-bucketed TTL'd counters only (phase40-43 §4);
- operator notice fires on rate threshold (≥100/hour bucket) — a single bounded
  notice, never per-event paging.

## 6. Proof Protocol

1. Post-import (+ amendments), POST each sample once, ≥5 s apart, from the test host.
2. Per sample: export execution JSON; assert terminal node matches §3 column;
   assert zero-mutation set §4 via before/after datastore reads + psql count +
   snapshot hashes.
3. Assert evidence bounds: exactly one reject-bucket increment per sample; zero
   notice emissions at this volume.
4. Record pass/fail per cell in successor report with hashes under
   `ops/evidence/p40-packet-runtime/malformed/`. Any mutation ≠ 0 ⇒ FAIL ⇒
   ROUT-PKT precondition unmet.

## Verdict

**MAL-PKT-01: BLOCKED — SAMPLES AND EXPECTATIONS FULLY DEFINED.** The P6/P8
frozen-era gaps are disclosed and converted into mandatory amendment acceptance
criteria rather than silently assumed safe.
