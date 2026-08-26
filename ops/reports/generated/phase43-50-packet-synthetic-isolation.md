# Phase 43: Packet Synthetic Isolation Proof

**Report ID:** phase43-50-packet-synthetic-isolation.md
**Phase:** 43
**Title:** Phase 43 Packet Synthetic Isolation Proof
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T20:00:00Z
**Classification:** INTERNAL
**Status:** BLOCKED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-50-packet-synthetic-isolation.md`

---

## 1. Purpose

Prove synthetic/test events are isolated from real counters, routing, billing, and cases.

---

## 1. Required Isolation

| Dimension | Mechanism |
|-----------|-----------|
| **Counter** | Separate keys: `p41_packet_routed_real` vs `p41_packet_routed_synthetic` |
| **Routing** | Synthetic → test route (no IRIS); Real → IRIS |
| **Datastore** | Separate keys: `p41_dedup_real_*` vs `p41_dedup_synth_*` |
| **Counter** | Separate counters: `real_routed` vs `synthetic_routed` |
| **Billing** | Synthetic tagged `MCT_SYNTHETIC=true` → excluded from billing |
| **Cases** | Synthetic → no case creation |

---

## 2. Current State (Platform Blocked)

| Isolation | Status |
|-----------|--------|
| Counter separation | BLOCKED (counter node uses `execute_python` → broken) |
| Routing separation | PARTIAL (IRIS route works but synthetic not isolated) |
| Datastore separation | BLOCKED (`check_datastore_contains` params literal) |
| Counter separation | BROKEN (`set_state` missing) |

---

## 3. Status

**BLOCKED** — Requires native rebuild (Option A) with `if_else_routing` + `filter_list` + `set_datastore_value` + `check_datastore_contains`.