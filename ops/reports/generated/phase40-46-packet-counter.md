# Phase 40 Packet Counter / Rate-Limit Control — Packet-Counter-40-01

**Report ID:** phase40-46-packet-counter
**Phase:** 40
**Title:** Counter Design — Persistent Synthetic/Real Counters, 50/min Real-Route Cap Proposal, Threshold Notice, At-Cap Suppression, Reset Procedure, Owner-Only Override, Guardrail Independence — BLOCKED-RUNTIME
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:32:30Z
**Classification:** INTERNAL
**Status:** BLOCKED-RUNTIME
**Record ID:** PACKET-COUNTER-40-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-46-packet-counter.md`
**Design anchor:** `ops/evidence/p39-workflow-export/packet-workflow-import.json` (sha256 `8242145e…37fc`)

---

## 1. Blocker (explicit)

Workflow not imported (IMP-40-01); no counter has ever incremented. Specification
pre-committed; **no simulated PASS.**

## 2. Control Design — As Frozen in the Artifact

Single node `counter-routed-increment` (`65406eec…`, `set_state`):
key `p39_packet_counter_routed`, value `$calc:${state.p39_packet_counter_routed|0}+1`,
placed strictly between dedup-success and the IRIS route action — increments ONLY
on events that are validated, non-synthetic, allowlisted, and first-seen.
The `|0` fallback makes the counter self-initializing and persistent across runs.

## 3. Phase-40 Counter Architecture (amendment)

| Key | Scope | Persistence | Writer |
|---|---|---|---|
| `real_packet_routed_total` | real-shaped, routed events | persistent (no TTL) | increment after dedup-pass, before route attempt |
| `real_packet_cap_suppressed_<YYYYMMDD>` | events withheld at cap | TTL 86400 | cap branch |
| `syn_packet_routed_total` / `syn_packet_suppressed_total` | synthetic class | TTL ≤3600 (per phase40-44 §3.4) | respective branches |
| `real_packet_notice_<YYYYMMDD>` | threshold notices emitted | TTL 86400, itself capped at small N | notice branch |

Namespaced per ISO-40-01; synthetic traffic can never move `real_*` keys
(topology-enforced, not convention).

## 4. Limit Proposal (value + mechanics)

- **Proposal: 50 routed real-class events/min lane cap** — matches the ROUT-39-02
  §5 suggestion ("50 alerts/min into the lane"), carried forward unchanged as the
  working proposal pending VOL-PKT-01 data.
- Mechanism (post-D3 explicit-get era): before route, read minute-bucket marker
  `real_packet_minute_<YYYYMMDDHHMM>`; if absent → set (TTL 120 s) and proceed;
  if present with count <50 → increment and proceed; if ≥50 → **at-cap branch**:
  terminate at suppress-with-record node (`CAP-SUPPRESSED sid=… bucket=…`),
  increment `real_packet_cap_suppressed_<date>` — never an error state.
- Minute-marker keys are self-expiring (TTL 120 s) ⇒ bounded key-space regardless
  of flood volume.

## 5. Threshold Notice

At ≥80% of cap (i.e., 41st event in a rolling minute) emit ONE operator notice log
(`THRESHOLD-NOTICE packet-lane count=<n> cap=50`) guarded by the
`real_packet_notice_` key so notice storms cannot themselves become noise.

## 6. Reset Procedure (documented, owner-gated)

1. Operator verifies no test/replay session is active.
2. Change-register entry: keys affected, reason, expected delta.
3. Delete/reset `real_packet_*` persistent keys via workflow datastore interface
   (or scoped API); record pre/post values in the register entry.
4. Post-check: next single marked event increments from reset base cleanly.
Synthetic-key hygiene needs no manual reset (TTL-driven).

## 7. Override Policy

Cap value and reset are **owner-only** changes (MCT SOC): recorded in the change
register with operator sign-off per AGENTS.md approval gates; automation MUST NOT
alter cap values, delete counters, or bypass the at-cap branch under any
operational pressure.

## 8. External-Guardrail Independence Statement

> All counters live exclusively in the packet workflow's own datastore namespace.
> They do NOT depend on Wazuh availability, IRIS availability, network reachability,
> or any external guardrail process. External outages cannot reset, skip, or inflate
> them; conversely, disabling/re-enabling the lane or its upstreams leaves counters
> intact unless explicitly reset via §6. This independence is what makes the cap
> enforceable during partial-outage conditions (see DSF-PKT-01) and keeps billing/
> scorecard systems structurally incapable of being fed by this lane's internals.

## 9. Proof Protocol (expectations only)

1. Drive 60 marked real-class events within one minute post-amendments.
   Expect: ≤50 reach route; remainder terminate CAP-SUPPRESSED; exactly one
   THRESHOLD-NOTICE; cap_suppressed day-counter == overflow count.
2. Synthetic storm cross-check: synthetic submits produce ZERO `real_*` deltas.
3. Persistence check: disable/enable workflow between two singles — second event's
   increment reflects prior total (no silent reset).
4. Export execution exports + datastore reads to
   `ops/evidence/p40-packet-runtime/counter/`; hash into successor report.

## Verdict

**BLOCKED-RUNTIME.** Persistent namespaced counters, 50/min cap proposal,
notice/suppression behavior, reset and override governance, and independence
assertion fully specified; zero runtime evidence exists today.
