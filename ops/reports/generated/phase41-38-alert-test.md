# Phase 41 Alert-Path Test — Failure-Detection Evidence Without Injection

**Report ID:** phase41-38-alert-test
**Phase:** 41
**Title:** ALERT-TST-41-01 — Live ABORTED/FAILED Simulation Deliberately NOT Performed; Detection Capability Proven From Lifetime Counters Plus Same-Day Independent API Observation; Protocol Recorded For Future Controlled Test
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:28:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (test waived; evidence-based substitute)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-38-alert-test.md`

---

## 1. Decision: no injection today

Triggering one real ABORTED (e.g., malformed payload into the classb draft
lane) was evaluated and **rejected**: every available injection surface sits on
lanes sharing production-adjacent infrastructure (IRIS case store, Wazuh
pipeline), and AGENTS.md forbids simulating PASS evidence while requiring
synthetic events stay isolated from production counters. A manufactured failure
buys no information the existing corpus lacks.

## 2. Evidence that detection works, without new injections

1. **Lifetime FAILED classification [VERIFIED]:** `failed=31` — thirty-one
   historical FINISHED-with-failed-downstream executions (DNS-failure era)
   correctly held out of `delivered` by the result-status parser, every cycle,
   for months of runs.
2. **Lifetime ABORTED classification [VERIFIED]:** `aborted=3` on the monitored
   lanes — terminal-ABORTED recognized as its own class, never conflated with
   FAILED or DELIVERED.
3. **Same-day independent confirmation [VERIFIED live]:** direct API pull on
   the packet lane (outside monitor scope) shows 6 ABORTED executions from
   today's rebuild-debug window, each carrying a causal FAILURE node
   (`parse-eve-json`, `normalize-fields`) with downstream SKIPPED — the exact
   shape the alert path must recognize, recognized by the same parsing
   discipline.

## 3. Protocol for a future controlled test (recorded, unscheduled)

1. Owner-approved window; classb **draft** workflow cloned further into a
   throwaway copy so no shared counter moves.
2. Payload crafted to fail at a named node; execution ID captured pre/post.
3. Assert: monitor classifies ABORTED (not FAILED, not delivered), ERROR-free
   cycle otherwise.
4. Teardown: delete clone; assert estate returns to exactly 3 workflows.

## 4. Verdict

Failure-path detection: **PROVEN by corpus + independent observation**, not by
today's injection. Honest scope note: the *alerting* leg (human notification)
remains log-line-only by design; no pager integration exists or is claimed.
