# Phase 41 Failure-Mode Catalog — Merged Proof-State Note (Supersedes Duplicate Concept)

**Report ID:** phase41-51-downstream-failure-proof
**Phase:** 41
**Title:** FAILCAT-41-01 — Unified Failure-Mode × Detection × Proof-State Catalog For The Packet Lane: What Is Proven, What Is Blocked, What Is Deliberately Not Executed — One Table So No Mode Falls Between Reports
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:55:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (catalog; concept merged with phase41-49 by design)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-51-downstream-failure-proof.md`

---

## 1. Why this merged record exists

Report 49 (history-evidence) and the originally separate 51 (live-fire proof)
described overlapping capability. Rather than duplicate, 49 carries the
evidence narrative and THIS record is the catalog of record — one row per
failure mode, its detection vehicle, and its current proof state.

## 2. Catalog

| # | Failure mode | Detection vehicle | Proof state | Evidence |
|---|--------------|-------------------|-------------|----------|
| F1 | Downstream HTTP failure under FINISHED | monitor result-status parse (`success": false`/exception scan) | **PROVEN** (historical) | failed=31 Class-A DNS era, frozen since 2026-08-10T19:24:16Z [phase41-49] |
| F2 | Terminal ABORTED | monitor ABORTED class + API status field | **PROVEN** | lifetime aborted=3 monitored lanes; +6 packet-lane ABORTEDs classified same-day with causal FAILURE nodes [phase41-38] |
| F3 | Monitor transport failure | script exit 2, ERROR line, zero counters | **PROVEN live** | 04:15Z ERROR cycle self-healed [phase41-36] |
| F4 | Monitor schedule stall (silent) | p41 watchdog, >20min mtime age → dedicated alert log | **PROVEN in test** | stale/repeat-guard matrix passed; cron installed [phase41-39] |
| F5 | Malformed input routing | validate-required-fields gate → DEADLETTER-malformed | **BLOCKED** (gate input undefined — platform) | structural wiring VERIFIED; behavioral test staged [phase41-47] |
| F6 | Duplicate event suppression | check_datastore_contains dedup key | **BLOCKED** (key never resolves — platform) | node executes err-free; semantics unprovable [phase41-44] |
| F7 | Datastore failure handling | fail-closed on datastore error | **NOT EXECUTED (deliberate)** | shared-store stop = production outage; unreachable-endpoint sim designed [phase41-48] |
| F8 | Synthetic leakage to production | isolation branch + test markers | **PASS by markers, BRANCH BLOCKED** | all events synthetic/test-titled; isolation python node itself input-blocked [phase41-46/43] |

## 3. Reading the catalog honestly

Two proof tiers exist and are never mixed: **detection/accounting proofs**
(F1–F4) stand on real evidence today; **enforcement/routing proofs** (F5–F8)
are structurally present but blocked on one platform defect. The blocker
statement and unblock paths live in exactly one place — phase41-52.

## 4. Maintenance rule

Any new failure mode observed on any lane gets a row here and a pointer from
the affected lane's next report; rows never get deleted, only re-stated with
newer evidence references.
