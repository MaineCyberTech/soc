# Phase 40 Packet Synthetic Isolation — Packet-Iso-40-01

**Report ID:** phase40-44-packet-synthetic-isolation
**Phase:** 40
**Title:** Isolation Design — Synthetic vs Real Namespaces (Counter Prefixes, Route Tagging, Case/Billing/Scorecard Exclusion), Cleanup TTL, Contamination Checks — BLOCKED-RUNTIME
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:29:30Z
**Classification:** INTERNAL
**Status:** BLOCKED-RUNTIME
**Record ID:** PACKET-ISO-40-01
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-44-packet-synthetic-isolation.md`
**Design anchor:** `ops/evidence/p39-workflow-export/packet-workflow-import.json` (sha256 `8242145e…37fc`)

---

## 1. Blocker (explicit)

Workflow not imported (IMP-40-01); the isolation gate has never executed against a
live synthetic event. Design + proof protocol pre-committed; **no simulated PASS.**

## 2. Control Design — As Frozen in the Artifact

Two-node gate placed EARLY in the topology (before allowlist/dedup/counter/route):

| Node | id | Behavior |
|---|---|---|
| `synthetic-isolation-check` | `b1657c3a…` | `check_regex` input `${parse-eve-json.tags}`, regex `synthetic` |
| `SINK-synthetic-logonly` | `aecb5b91…` | success arm terminal: logs `SYNTHETIC-EVENT-DROPPED sid=${normalize-fields.sid}` — workflow ends here |

Branch semantics: tags match `synthetic` → sink (nothing downstream runs);
no match → proceed to `sid-allowlist-filter`. Consequence (topology-proven):
**a synthetic-tagged event can never reach dedup, counters, or IRIS even when its
SID is allowlisted** — the exact property REPLAY-39-02 companion case pre-committed.

## 3. Phase-40 Namespace Design (amendments)

### 3.1 Counter namespaces

| Class | Key prefix | Example | Notes |
|---|---|---|---|
| synthetic | `syn_packet_` | `syn_packet_routed_total`, `syn_packet_suppressed_total` | test-era instrumentation only |
| real | `real_packet_` | `real_packet_routed_total` | feeds cap logic (46) and volume window (52) |

Frozen single counter `p39_packet_counter_routed` is retired at amendment time
(migrated read-only reference kept in comments; register entry required).

### 3.2 Route tagging (test-only)

Routed alerts carry, verbatim (frozen body, era tag amended p39→p40):
title prefix `[p40-test]`, tag set `packet,suricata,sid:<sid>,class:packet,test:p40`,
`alert_customer_id=1`. Downstream exclusion filters key on `class:packet` +
`test:p40` + title prefix — triple-redundant so a single field loss cannot leak a
test alert into client-visible views.

### 3.3 Exclusion rule (case/billing/scorecard)

Any record derived from a synthetic-tagged event is EXCLUDED from:
case management aggregation, billing/scorecard inputs, SLA metrics, and the
client-facing alert surface. Mechanism: exclusion predicates filter on the
markers above AND on `syn_*` counter lineage; synthetic events additionally never
increment `real_*` counters (enforced by topology §2, not by convention).

### 3.4 Cleanup TTL

All `syn_packet_*` keys carry TTL ≤ 3600 s (day-bucket variants 86400 s) so
test instrumentation cannot accumulate; `real_packet_*` totals persist (46).

## 4. Contamination Checks (run after every synthetic-heavy test session)

| # | Check | Pass condition |
|---|---|---|
| C1 | `real_packet_routed_total` delta across session | 0 while ONLY synthetic events were submitted |
| C2 | IRIS alerts query for session window | rows exist only with `[p40-test]` titles + `test:p40` tag; count == sanctioned routed count |
| C3 | Dedup namespace scan | no `real-` prefixed dedup keys created by synthetic submissions |
| C4 | Billing/scorecard source queries (pre vs post) | byte-identical outputs |
| C5 | Sink visibility | every synthetic run's terminal node == `SINK-synthetic-logonly`; zero runs reached `iris-test-route-*` |

## 5. Proof Protocol (expectations only)

1. Submit allowlisted-sid canary WITH `tags:["synthetic","MCT_TEST_ONLY=true",
   "MCT_TEST_ID=P40-ISO-001"]`.
2. Assert C1–C5 (execution exports + datastore reads + IRIS psql delta + scorecard
   snapshot diff).
3. Negative control: identical event WITHOUT synthetic tag → proceeds past gate
   (reaches allowlist/dedup/route chain), demonstrating the gate discriminates on
   the marker alone.
4. Positive-isolation storm: 10 synthetic submits rapid-fire → 10 sink terminals,
   zero IRIS rows, zero `real_*` movement, zero new dedup keys.
5. Export all executions to `ops/evidence/p40-packet-runtime/iso/`; hash into
   successor report. Results columns EMPTY until run.

## 6. AGENTS.md Alignment

Implements the MUST: "Keep synthetic events isolated from production counters,
cases, billing, and scorecards." The design isolates by topology (gate placement),
namespace (key prefixes), tagging (triple-redundant), and TTL hygiene — four
independent layers; failure of any one layer is detectable via §4 checks.

## Verdict

**BLOCKED-RUNTIME.** Isolation architecture specified end-to-end from the frozen
artifact plus registered amendments; contamination checks and proof protocol
pre-committed; zero runtime evidence exists today.
