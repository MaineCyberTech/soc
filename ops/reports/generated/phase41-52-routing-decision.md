# Phase 41 Packet-Lane Routing Decision — DEFERRED With Precise Blocker Statement

**Report ID:** phase41-52-routing-decision
**Phase:** 41
**Title:** ROUT-PKT-41-01 — DECISION: PRODUCTION ROUTING DEFERRED; Platform-Level execute_python Input/Kwargs Defect Named Precisely; Two Remediation Paths Staged (UI Rebuild On Native-Ref Nodes OR Platform Upgrade); SID Shortlist Unchanged (2027967 Lead); Review Phase 42
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:57:00Z
**Classification:** INTERNAL
**Status:** DEFERRED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-52-routing-decision.md`

---

## 1. Decision

**Production routing on the suricata packet lane: DEFERRED.** The lane proves
everything a transport must do — webhook trigger fires, all 13 nodes execute
error-free, IRIS accepts every clean run with HTTP 200, accounting and monitors
hold — and cannot yet prove what a *gate* must do. Deferral is a statement
about enforcement, not delivery.

## 2. Precise technical blocker (single source of truth)

On this Shuffle build, `execute_python` exposes **no incoming-data variable**
(data_in / input / execution_input / execution_data / data all UNDEF; globals =
modules + shuffle(Singul)/self(Tools)), and parameter injection fails — `$ref`
arguments arrive as literals (established empirically via probe workflow
p41-varprobe, created+used+deleted cleanly). Consequences, each carried by its
own report:

- normalize / validate / synthetic-isolation / SID-allowlist nodes run against
  undefined input → fail-open, cannot gate (phase41-43);
- dedup key never populated with resolved values (phase41-44);
- cache counter echoes literal `$ref` (phase41-45);
- cross-node python data-passing impossible on this build;
- malformed-path and datastore-failure behavioral proofs therefore blocked or
  withheld (phase41-47/-48).

Enabling production routing behind gates that provably cannot enforce would
violate both AGENTS MUSTs (fail-closed; no production routing without native
gates passing).

## 3. Remediation paths

| Path | Act | Why it works |
|------|-----|--------------|
| R-a (preferred) | Owner UI session rebuilds the gating chain using natively reference-consuming nodes — `filter_list`, `if_else_routing`, `set_datastore_value` — which DO resolve `$refs` natively (Class-A precedent); python nodes demoted to non-gating enrichment | bypasses the defective kwargs path entirely; uses only proven primitives |
| R-b | Shuffle upgrade incorporating execute_python kwargs/input injection fix | fixes root cause for all lanes at once; requires upgrade-window approval + regression re-run of this entire proof arc |

Either path re-runs the blocked proofs (44–48) before any gate claim revives.

## 4. SID shortlist — unchanged

Lead candidate **SID 2027967**, shortlist otherwise as carried from P40 packet
planning; no re-prioritization occurred because no gate capability changed.
Shortlist activates only with the remediated chain.

## 5. Estate and hygiene at decision time [VERIFIED live]

Exactly 3 workflows (`suricata-packet-routing` status=test/valid/13 actions,
Class-A, classb draft); probe artifacts deleted (datastore+cache flushed);
stray p40-import-probe gone; all events synthetic/test-marked; trigger stopped.
Zero production contamination attributable to this phase.

## 6. Review date

Re-opened automatically at **Phase 42** opening session, or immediately upon
either remediation landing — whichever first.
