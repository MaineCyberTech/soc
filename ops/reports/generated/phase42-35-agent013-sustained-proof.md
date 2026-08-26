# Phase 42 Agent 013 Sustained Proof — Protocol Armed (BLOCKED-AWAITING-OWNER)

**Report ID:** phase42-35-agent013-sustained-proof
**Phase:** 42
**Title:** SUS-013-42-01 — Sustained-Proof Protocol Pre-Committed Before Any Evidence Exists: ≥3 Keepalives Over ≥30 Minutes All Fresh; Zero Evidence Today Because Zero Uptime Today; Polls Execute Automatically Once 013 Returns
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:57:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-AWAITING-OWNER
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-35-agent013-sustained-proof.md`

---

## 1. Status

**BLOCKED-AWAITING-OWNER.** A sustained-proof claim requires sustained uptime,
and 013 has none: disconnected 26.5h at the 08:49:39Z pull. This report issues
the protocol in advance so the pass/fail bar cannot move after evidence starts
arriving. It contains zero fabricated observations by construction.

## 2. Protocol (pre-committed, ≥3 keepalives over ≥30 minutes)

| Gate | Requirement | Measurement |
|---|---|---|
| G1 — count | ≥3 distinct keepalives received | `GET /agents` poll every 10 min after return |
| G2 — span | first→last poll ≥30 min | wall-clock timestamps of polls |
| G3 — freshness | every polled `lastKeepAlive` <600s old at its poll instant | per-poll age computation |
| G4 — stability | `status=active` on every poll; zero flap transitions | per-poll status field |

PASS requires all four gates green on the same recorded poll series. Any red
gate → series documented, protocol restarts from a fresh T0. Partial series is
reported as partial, never averaged into a pass.

## 3. Poll schedule (starts automatically at 013 return)

- T0 = first fresh keepalive observed (agenda slot T+0, phase42-33).
- Polls at T0, T+10, T+20, T+30 minimum; extra polls if any gate is marginal.
- Each poll appended raw (timestamp, status, lastKeepAlive, age) to the
  successor evidence record; no post-hoc editing.

## 4. Why pre-commitment matters here

The prior arc issued this exact discipline (phase41-21) and it was consumed by
a device that went back to sleep before three polls could land. Re-issuing it
against today's 26.5h baseline makes two things explicit: the bar did not drop
during the outage, and the outage itself is measured (baseline row in
phase42-34 §2), not hidden.

## 5. Exit condition

On PASS, certification matrix gate 2 goes green (phase42-36 row R2) and the
remaining gates are evaluated. Until then: blocked, honest, waiting on a
power button.
