# Phase 41 Datastore-Failure Proof — Design Only; NOT EXECUTED With Reason Stated

**Report ID:** phase41-48-datastore-failure
**Phase:** 41
**Title:** DSFAIL-41-01 — NOT EXECUTED By Deliberate Choice: The Only Reachable datastore-dedup Failure Surface Sits On The Shared Production OpenSearch (Stop = Production Outage); Unreachable-Endpoint Simulation Designed And Deferred To Owner UI Session
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:49:00Z
**Classification:** INTERNAL
**Status:** PLAN-ONLY (NOT EXECUTED — rationale recorded)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-48-datastore-failure.md`

---

## 1. Why this proof did not run

The dedup node's backing store is the stack's shared OpenSearch. The only
faithful failure simulation available from automation is stopping/degrading it
— which is a **production outage of the evidence platform itself**, touching
every lane, dashboard, and retention job simultaneously. Risk/benefit fails:
the design property being proven (fail-closed on datastore error) is already a
platform-level behavior, and the blast radius is the whole SOC stack.
AGENTS approval gates exist precisely to stop improvisation like that.

## 2. Designed simulation (documented for the owner UI session)

1. Clone packet workflow into throwaway test copy (estate returns to 3 after).
2. Point its datastore node at an **unreachable endpoint** (RFC5737 host or
   stopped sidecar) — no production service touched.
3. Fire valid synthetic event; assert: node errors → execution does NOT count
   delivered; route lands in dead-letter path per design; monitor accounting
   agrees (no HTTP200-in-results).
4. Restore endpoint; assert clean run resumes; teardown clone.

## 3. What partial evidence exists today [VERIFIED]

Fail-closed discipline is not hypothetical on this stack: the delivery monitor's
transport layer demonstrably exits non-zero emitting no counters when an API
read fails (04:15Z ERROR cycle, phase41-36), and ABORTED-with-downstream-SKIPPED
chains were observed and correctly classified same-day (phase41-38 §2.3). The
*datastore-specific* leg remains unproven.

## 4. Verdict

PLAN-ONLY, honestly labeled NOT EXECUTED. This is a scope refusal, not an
oversight; the alternative simulation removes every reason to ever touch the
shared store for testing.
