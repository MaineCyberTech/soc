# Phase 40 Packet Dedup Control — Packet-Dedup-40-01

**Report ID:** phase40-45-packet-dedup
**Phase:** 40
**Title:** Dedup Design — Deterministic Key (sid+src+dst+port+hourbucket), Datastore Get/Set Pattern, TTL 3600 s, Suppress Branch, Instability Fallback, Fail-Closed on Datastore Errors — BLOCKED-RUNTIME
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:31:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-RUNTIME
**Record ID:** PACKET-DEDUP-40-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-45-packet-dedup.md`
**Design anchor:** `ops/evidence/p39-workflow-export/packet-workflow-import.json` (sha256 `8242145e…37fc`)

---

## 1. Blocker (explicit)

Workflow not imported (IMP-40-01); no dedup decision has ever executed. The design
below is fixed now so post-import testing is mechanical and unbiased.
**No simulated PASS.**

## 2. Control Design — As Frozen in the Artifact

| Node | id | Verbatim parameters |
|---|---|---|
| `datastore-dedup-set` | `94ad342b…` | `set_state`; key `${normalize-fields.sid}-${normalize-fields.src_ip}-${normalize-fields.dst_ip}-epoch300`; value `${normalize-fields.timestamp}`; ttl `300` |
| `duplicate-suppressed-logonly` | `3ad890d4…` | failed arm terminal: `DUP-SUPPRESSED key=${…sid}-${…src_ip}-${…dst_ip}-epoch300` |

Frozen semantics: set-on-existing-key failure ⇒ duplicate ⇒ suppress+count;
success ⇒ first-seen ⇒ proceed to counter/route. Suppression is log-only — the
event is dropped from routing but fully recorded in the execution history.

## 3. Phase-40 Amendment Set (target design per tasking)

| # | Element | Frozen value | P40 target |
|---|---|---|---|
| D1 | Key formula | `sid-src-dst-epoch300` (3 components + rolling suffix) | **sid+src+dst+port+hourbucket** — deterministic: `<sid>-<src_ip>-<dst_ip>-<sport>:<dport>-<YYYYMMDDHH UTC>` |
| D2 | TTL | 300 s | **3600 s** (aligned to hourbucket width; key dies with its bucket) |
| D3 | Pattern | set-fails-if-exists inference | **explicit get-first**: `get_state(key)` → found ⇒ duplicate branch; not-found ⇒ `set_state` then proceed. Rationale: removes reliance on error-semantics of set for the suppression decision; set-failure then means DATASTORE FAULT, never "duplicate" |
| D4 | Instability fallback | none | any key component failing validation guard V5 (phase40-43) ⇒ event rejected to dead-letter BEFORE dedup; a dedup decision is NEVER made on a degenerate/unstable key (`---`, template residue, oversized) |
| D5 | Datastore errors | implicit | **fail-closed**: get/set error ≠ duplicate ≠ unique — run diverts to TARGETFAIL-family dead-letter with error text; nothing routes un-deduplicated and nothing suppresses on fault (see DSF-PKT-01, phase40-50) |
| D6 | Metrics | none | day-bucketed TTL'd counters: `p40_packet_dedup_hit_<date>`, `_miss_` |

Determinism note (D1): hourbucket derives ONLY from the normalized event timestamp
UTC-truncated to hour — never from arrival time — so identical events map to one
key regardless of submission jitter inside the bucket.

## 4. Expected Behavior (acceptance semantics)

| # | Behavior | Pass condition |
|---|---|---|
| B1 | First-seen tuple in bucket | get=not-found → set OK → counter+route path taken |
| B2 | Repeat tuple within TTL/hourbucket | get=found → `duplicate-suppressed-logonly` terminal with the exact key echoed; zero IRIS calls; zero counter movement |
| B3 | Bucket rollover | new hourbucket ⇒ fresh key ⇒ routes again (bounded re-alert cadence = 1/hour/tuple) |
| B4 | Component instability | rejected pre-dedup (dead-letter), never suppressed-as-success nor routed |
| B5 | Datastore fault | fail-closed dead-letter; operator-visible; recovery clean (phase40-50) |

## 5. Proof Protocol (pre-committed; expectations only)

Three-identical replay core (full matrix in REPLAY-PKT-01, phase40-48):

1. POST canonical marked canary (sid 2027967, fixed 5-tuple) three times, 2 s apart.
2. Assert: exactly 3 executions; **exactly 1 routed**, **2 suppressed** at
   `duplicate-suppressed-logonly`; all three runs reference a **single identical
   key string** (capture from node I/O); IRIS row delta == 1.
3. Datastore read-back: exactly one live key matching the tuple pattern; TTL field
   ≈ 3600 (amended build).
4. TTL respected: wait ≥ TTL (+60 s margin); submit 4th identical → routes again;
   old key expired (not resurrected).
5. Instability probe (post-D4): submit well-formed-but-guard-failing component
   (e.g., port value `"high"`) → dead-letter terminal; assert no key materialized.
6. Export executions + datastore dump excerpt to
   `ops/evidence/p40-packet-runtime/dedup/`; hash into successor report.

## 6. Known Ordering Limitation (honest disclosure, carried to 51)

Frozen order is dedup-set BEFORE route. A downstream failure AFTER a successful
first-set consumes the key: an immediate manual replay inside the window would be
suppressed despite non-delivery. Mitigations (either acceptable, pick at amendment):
(a) documented operator procedure "replay only after TTL expiry"; or (b) reorder
route-before-final-suppress-commit. Decision logged at import session; REPLAY-PKT-01
step 4 doubles as the regression test for whichever option lands.

## Verdict

**BLOCKED-RUNTIME.** Deterministic key, explicit get/set pattern, TTL, instability
fallback, and fail-closed datastore semantics fully specified; proof protocol
pre-committed; zero runtime evidence exists today.
