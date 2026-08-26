# Phase 42 Packet Capability Inventory — Every Candidate Node × Test × Result

**Report ID:** phase42-15-packet-capability-inventory
**Phase:** 42
**Title:** CAPINV-42-01 — COMPLETE: Definitive Tools-1.2.0 Capability Matrix For This Build From Five Empirical Probes (T1–T5) Across Two Phases; No Native Reference-Consuming Gate Primitive Is Operational In Tools; HTTP App Confirmed Sole Reference Consumer
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:14:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (inventory; every gate-capable row reads BLOCKED)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-15-packet-capability-inventory.md`

---

## 1. Scope & method

Probe-first per policy. Five empirical tests (T1–T5) executed across Phase 41
(probe workflow `p41-varprobe`) and Phase 42 (`p42-capability-probe`); both
probe workflows created, used, deleted cleanly — final estate exactly 3
workflows [VERIFIED live this session]. Probe-execution references are
session-recorded (parent workflows deleted post-test; not re-queryable live):
T1 `c69ebb73`, T2 `bc6197a4`, T3 `dbfc0e7d`, T4 `21efb5c0`, T5 `1fac8e6f`.

## 2. Test summary (platform truth)

| # | Test | Result | Exec ref |
|---|------|--------|----------|
| T1 | execute_python incoming-variable globals probe | **NO incoming-data variable exists** — `data_in`, `input`, `execution_input`, `execution_data`, `data` all UNDEF; globals = modules + Singul(`shuffle`) + `Tools` objects only | c69ebb73 |
| T2 | Tools `$param` reference passing | Passes as **LITERAL strings**: `set_cache_value` echoed key/value `"$normalize-f…"` unresolved; datastore nodes received literal `$…` text | bc6197a4 |
| T3 | `if_else_routing` invocation | Present in app definition; runtime rejects: **"Function doesn't exist, or the App is out of date"** | dbfc0e7d |
| T4 | `repeat_back_to_me` with FULL metadata param objects cloned from working Class-A HTTP params (action_field / value_replace / schema included) | **Ignores input entirely — echoes function name**, even with full-fidelity metadata | 21efb5c0 |
| T5 | HTTP app reference interpolation (control positive) | **DOES interpolate** — `${body:*}` old-syntax resolved; Class-A delivery HTTP 200 twice | 1fac8e6f |

## 3. Node-by-node capability matrix (live packet workflow e133a645, 13 actions)

| Node (live label) | Function | Gate role designed | Capability verdict | Evidence |
|---|---|---|---|---|
| parse-eve-json | Tools repeat_back_to_me | entry logpoint | runs; input ignored (T4-class) | [VERIFIED] 12 FINISHED runs err-free [phase41-46]; T4 |
| normalize-fields | execute_python | normalization gate | **BLOCKED** — sees UNDEF input; params literal (T1/T2) | [VERIFIED] c69ebb73/bc6197a4; [phase41-43] |
| validate-required-fields | execute_python | validation gate | **BLOCKED** — same root cause | [VERIFIED] T1/T2; [phase41-47] |
| synthetic-isolation-check | execute_python | isolation gate | **BLOCKED** — same root cause | [VERIFIED] T1/T2; [phase41-46 §3 note] |
| SINK-synthetic-logonly | repeat_back_to_me | sink | runs; content-independent | [VERIFIED] [phase41-46] |
| sid-allowlist-filter | execute_python | SID allowlist gate | **BLOCKED** — cannot evaluate event-derived SID | [VERIFIED] T1/T2 |
| datastore-dedup-set | check_datastore_contains | dedup gate | **BLOCKED** — key ships static; checks a constant | [VERIFIED] T2; [phase41-44] |
| duplicate-suppressed-logonly | repeat_back_to_me | suppressed sink | runs; unreachable-with-meaning while key static | [VERIFIED] [phase41-46 §3] |
| counter-routed-increment | set_cache_value | routed counter | **BLOCKED** — stored value echoes literal `$ref` (T2) | [VERIFIED] bc6197a4; [phase41-45] |
| iris-test-route-p39tag | HTTP 1.4.0 POST | delivery | **OPERATIONAL incl. references** — `${body:*}` resolves (T5) | [VERIFIED] 1fac8e6f; IRIS 200 ×12 [phase41-46] |
| done-routed-log | repeat_back_to_me | terminal sink | runs | [VERIFIED] [phase41-46] |
| DEADLETTER-malformed | repeat_back_to_me | malformed sink | wired; behavioral routing gated upstream | [VERIFIED structurally] [phase41-47] |
| DEADLETTER-target-fail | repeat_back_to_me | failure sink | wired; same | [VERIFIED structurally] [phase41-51 F-row] |

## 4. Conclusion [VERIFIED]

No native reference-consuming gate primitive is operational in Shuffle Tools
1.2.0 on this build. Reference consumption exists ONLY in the HTTP app. Per
AGENTS policy ("remains disabled with exact platform blockers"), the packet
lane stays DISABLED/TEST-ONLY. Canonical blocker block: phase42-18 §2.
