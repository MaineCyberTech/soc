# Phase 43: Packet Dedup Proof

**Report ID:** phase43-51-packet-dedup-proof.md
**Phase:** 43
**Title:** Phase 43 Packet Dedup Proof
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T20:15:00Z
**Classification:** INTERNAL
**Status:** BLOCKED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-51-packet-dedup-proof.md`

---

## 1. Purpose

Prove deterministic dedup: 3 identical events → 1 routed, 2 suppressed.

---

## 1. Dedup Design

| Component | Implementation |
|-----------|----------------|
| **Key** | `dedup_packet_{sid}_{src}_{dst}_{port}_{hour_bucket}` |
| **Check** | `check_datastore_contains` (key exists?) |
| **Set** | `set_datastore_value` (key + TTL 1h) |
| **Branch** | `if_else_routing` on `existed: true/false` |

---

## 2. Expected Behavior

| Event # | Dedup Check | Expected | Route |
|---------|-------------|----------|-------|
| 1 (first) | `existed: false` | ALLOW → route to IRIS | IRIS |
| 2 (dup) | `existed: true` | SUPPRESS → log only | SINK |
| 3 (dup) | `existed: true` | SUPPRESS → log only | SINK |

---

## 2. Current State

**BLOCKED** — Requires:
1. `check_datastore_contains` (params: value, key, append=false) — works but needs real refs
2. `set_datastore_value` (key, value) — works but needs real refs
3. `if_else_routing` on `existed` — MISSING in this build

---

## 3. Status

**BLOCKED** — Platform defect prevents dedup proof. Native rebuild (Option A) with `check_datastore_contains` + `if_else_routing` + `set_datastore_value` required.