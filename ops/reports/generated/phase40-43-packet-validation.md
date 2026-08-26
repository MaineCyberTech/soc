# Phase 40 Packet Validation Control — Packet-Validate-40-01

**Report ID:** phase40-43-packet-validation
**Phase:** 40
**Title:** Validation Control Specification — Reject Rules (Missing Fields / Unknown event_type / Unstable-Key Guard), Bounded Metrics Counters, Evidence Capture, Fail-Closed Ordering — BLOCKED-RUNTIME
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:28:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-RUNTIME
**Record ID:** PACKET-VALIDATE-40-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-43-packet-validation.md`
**Design anchor:** `ops/evidence/p39-workflow-export/packet-workflow-import.json` (sha256 `8242145e…37fc`)

---

## 1. Blocker (explicit)

Workflow not imported (IMP-40-01); the validation node has never executed.
Specification and proof protocol are pre-committed here; runtime verdicts remain
unproven. **No simulated PASS.**

## 2. Control Design — As Frozen in the Artifact

Node `validate-required-fields` (Shuffle Tools, id `39e7673f-2775-5c6a-910c-067a25b661c5`),
implemented as `regex_capture` over a composite string:

```
input : ${normalize-fields.sid}|${normalize-fields.src_ip}|${normalize-fields.dst_ip}
regex : ^[0-9]+\|.+\|.
```

Semantics: rejects when `sid` is absent or non-numeric, or `src_ip`/`dst_ip`
empty — i.e., **missing-field rejection for sid/src/dst**. Branch topology:
failed arm → `DEADLETTER-malformed` (`1fd9d0cb…`, captures `raw=${exec}`);
success arm → `synthetic-isolation-check`. There is no path from this node to
datastore, counters, or routing except via success.

## 3. Control Design — Phase-40 Amendment Set (reject rules)

| # | Rule | Frozen? | Planned implementation |
|---|---|---|---|
| V1 | missing/empty sid | YES (regex) | keep |
| V2 | missing src_ip / dst_ip | YES (regex) | keep |
| V3 | missing src_port / dst_port | NO | extend composite to 6-tuple `sid\|src\|dst\|sport\|dport\|proto` with strict regex `^[0-9]+\\|.+\\|.+\\|[0-9]+\\|[0-9]+\\|[A-Za-z0-9]+$` (depends on amendments A1–A3 of phase40-42) |
| V4 | unknown `event_type` | NO | prepend check: `${parse-eve-json.event_type}` matched against `^(alert)$`; anything else → reject |
| V5 | unstable-key guard | NO | every dedup-key component must match `^[A-Za-z0-9_.:-]{1,64}$`; empty/template-residue/garbage component → reject (prevents degenerate keys like `---` from ever reaching dedup, see 45) |
| V6 | non-allowlisted but well-formed events | handled downstream | NOT a validation reject — routed to dead-letter by allowlist-miss drop-with-record semantics (frozen; preserved) |

## 4. Bounded Metrics Counters (amendment)

Rejection evidence must be countable without unbounded datastore growth:

| Counter key pattern | TTL | Purpose |
|---|---|---|
| `p40_packet_malformed_<YYYYMMDD>` | 86400 s | malformed-rejected total per UTC day |
| `p40_packet_reject_v4_<YYYYMMDD>` / `_v5_` | 86400 s | per-rule reject breakdown |

Day-bucketing + TTL guarantees key-space is bounded regardless of attack volume;
each rejection increments exactly one bucket (single set_state on the
DEADLETTER-malformed success path). No per-event keys are created for rejections.

## 5. Evidence Capture Design

- `DEADLETTER-malformed` logs `P39DL MALFORMED raw=${exec}` (frozen) — full raw
  payload retained in execution record; P40 amendment prefixes the log line with
  the matching rule id (V4/V5) and day-bucket counter value.
- Operator notice thresholding: if any daily reject bucket crosses 100 within an
  hour, treat as possible probe/flood → operator notice (log node), never auto-route.

## 6. Fail-Closed Ordering (load-bearing, frozen topology)

Canonical order proven by branch edges in the artifact:

```
parse → normalize → VALIDATE → isolation-check → allowlist → dedup-set → counter → route
                       │
                       └─(fail)→ DEADLETTER-malformed   [terminal]
```

Validation executes BEFORE datastore write, BEFORE counter increment, BEFORE any
routing decision; the fail arm has exactly one terminal target and zero edges to
side-effectful nodes. Any amendment edit MUST preserve this ordering (checked by
structural diff at import-back, phase40-41 §7 step 7).

## 7. Proof Protocol (expectations only — BLOCKED)

For each sample below (POSTed once, ≥5 s apart, to captured webhook):

| Sample | Expectation |
|---|---|
| S1 missing sid | terminal DEADLETTER-malformed; zero datastore writes; zero counter deltas |
| S2 empty dst_ip | same as S1 |
| S3 `event_type:"flow"` (post-V4) | rejected by V4 arm; pre-amendment honest note: frozen build would NOT reject this if fields present — amendment mandatory before certification |
| S4 sid containing template residue `"${x}"` (post-V5) | rejected by V5; no dedup key materialized |
| S5 well-formed canary (control) | passes validation; proceeds to isolation/allowlist chain |

Per-case verification: export execution JSON; assert terminal node label;
assert datastore scan shows no new persistent keys beyond expected day-buckets;
assert IRIS row delta = 0. Record results in successor report with hashes.

## Verdict

**BLOCKED-RUNTIME.** Reject matrix, bounded-counter design, evidence capture, and
fail-closed ordering fully specified from the frozen artifact + registered
amendments; all pass/fail columns remain unfilled until real executions exist.
