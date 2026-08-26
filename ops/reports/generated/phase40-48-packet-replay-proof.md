# Phase 40 Packet Replay Protocol — REPLAY-PKT-01

**Report ID:** phase40-48-packet-replay-proof
**Phase:** 40
**Title:** Replay Protocol REPLAY-PKT-01 (BLOCKED) — Full Expected-Evidence Matrix (3 Executions / 1 Routed / 2 Suppressed / 1 Key / TTL / Zero Contamination), Ready-to-Run Steps Post-Import
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:35:30Z
**Classification:** INTERNAL
**Status:** BLOCKED-RUNTIME
**Record ID:** REPLAY-PKT-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-48-packet-replay-proof.md`
**Design anchor:** `ops/evidence/p39-workflow-export/packet-workflow-import.json` (sha256 `8242145e…37fc`)
**Supersedes protocol:** REPLAY-39-02 (phase39-40) for the Phase-40 amended design

---

## 1. Blocker

Workflow absent from platform (IMP-40-01); no executions exist. Protocol is fixed
NOW so post-import execution is mechanical and unbiased. Every result cell below is
an EXPECTATION. None has been observed. Nothing will be marked PASS without a real
execution export.

## 2. Canonical Test Event (marked canary)

```json
{"timestamp":"<now ISO8601>","event_type":"alert",
 "src_ip":"10.66.0.10","src_port":"54321","dest_ip":"172.20.0.7","dest_port":"443",
 "proto":"TCP",
 "alert":{"signature_id":2027967,"severity":2,"signature":"CANARY test sig"},
 "tags":["MCT_TEST_ONLY=true","MCT_TEST_ID=P40-REPLAY-001"]}
```

No `synthetic` tag — isolation is a separate companion case (§5). The event is
marked (`MCT_TEST_ONLY`, unique `MCT_TEST_ID`) so every hop is attributable.

## 3. Expected-Evidence Matrix

| # | Expectation | Pass condition | Evidence source |
|---|---|---|---|
| E1 | Exactly 3 executions recorded | executions API shows 3 new runs for the webhook, all FINISHED (via explicit terminal branches) | executions API export |
| E2 | Exactly 1 routed | precisely ONE `[p40-test] suricata sid 2027967` IRIS row; its run's terminal = `done-routed-log` | psql alert dump + run tree |
| E3 | Exactly 2 suppressed | two runs terminate at `duplicate-suppressed-logonly`, each logging `DUP-SUPPRESSED key=<K>` | run trees |
| E4 | Single dedup key | all three runs reference byte-identical key `2027967-10.66.0.10-172.20.0.7-54321:443-<hourbucket>` (amended formula §45-D1) | node I/O capture |
| E5 | TTL respected (3600 s proposal) | identical 4th submit AFTER expiry routes again (new bucket/expired key); a 4th submit BEFORE expiry would suppress — both sides demonstrated if window allows | runs 4(+5) |
| E6 | Zero contamination | `real_packet_routed_total` delta == +1 exactly (the single sanctioned route); IRIS non-test rows delta == 0; billing/scorecard snapshots unchanged; zero synthetic-path movement | datastore reads + snapshot diff (ISO-40-01 C1–C4) |
| E7 | Complete node outputs | all 4 runs exported full-depth (every action I/O retained) to evidence dir | export files + sha256 list |
| E8 | Counter semantics | counter increments once total across E1–E3 despite 3 submissions (dedup precedes counter in topology) | datastore before/after |

## 4. Ready-to-Run Steps (execute only post-import + amendment session)

1. Preconditions: imported workflow present, status test, amendments applied and
   register-entered; webhook URL captured; baseline snapshot taken (counter values,
   IRIS row count, scorecard hash) → `ops/evidence/p40-packet-runtime/replay/baseline/`.
2. `for i in 1 2 3; do curl -s -XPOST "<hook_url>" -d @replay-event.json; sleep 2; done`
3. Immediately verify E1–E4, E7, E8 via executions API + node exports + psql.
4. Hold ≥TTL+60 s; submit event #4 → verify E5 routed-side; if schedule permits,
   pre-expiry #4b was already covered by E3 logic.
5. Re-run contamination checks E6; write successor report with execution IDs,
   hashes, and pass/fail PER CELL. Any cell fail ⇒ ROUT-PKT precondition unmet.

## 5. Companion Micro-Cases (same session)

| Case | Input | Expected |
|---|---|---|
| Isolation | same event + `"tags":["synthetic", …]` | sink branch only; ZERO IRIS calls though sid allowlisted (ISO-40-01 proof) |
| Malformed spot | same event minus dest_ip | DEADLETTER-malformed terminal; zero side effects (full matrix: MAL-PKT-01) |

## 6. Honesty Notes

- E5's exact key string depends on amendments D1 landing; if the frozen epoch300
  form ships instead, expectations rebase to that formula BEFORE running (never
  reinterpret results afterwards).
- Ordering limitation of §45-6 applies if route fails transiently mid-replay —
  document, don't retry blindly inside the TTL window.

## Verdict

**REPLAY-PKT-01: BLOCKED — PROTOCOL READY.** Unblocks automatically upon import +
webhook capture; no further design work required; results columns intentionally
empty until real runs are hashed into evidence.
