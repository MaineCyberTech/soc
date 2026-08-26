# Phase 43: Packet Malformed Proof

**Report ID:** phase43-54-packet-malformed-proof.md
**Phase:** 43
**Title:** Phase 43 Packet Malformed Proof — Reject Invalid
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T21:00:00Z
**Classification:** INTERNAL
**Status:** BLOCKED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-54-packet-malformed-proof.md`

---

## 1. Purpose

Prove malformed/missing-field events are rejected to DEADLETTER.

---

## 1. Malformed Test Cases

| Test Case | Input Defect | Expected |
|-----------|--------------|----------|
| Missing `signature_id` | `{}` | DEADLETTER-malformed |
| Missing `src_ip` | `{"signature_id":2027967}` | DEADLETTER-malformed |
| Missing `dst_ip` | `{"signature_id":2027967,"src_ip":"1.2.3.4"}` | DEADLETTER-malformed |
| Missing `dst_port` | `{"signature_id":2027967,"src_ip":"1.2.3.4","dst_ip":"1.2.3.5"}` | DEADLETTER-malformed |
| Invalid proto | `{"signature_id":2027967,"proto":"INVALID"}` | DEADLETTER-malformed |
| Unknown SID | `{"signature_id":999999,...}` | DEADLETTER-malformed (not in allowlist) |

---

## 2. Expected Behavior

| Input | Validation | Branch |
|-------|------------|--------|
| Missing required field | `validate-required-fields` → FAIL | DEADLETTER-malformed |
| Invalid SID | `sid-allowlist-filter` → DENIED | DEADLETTER-target-fail |
| Valid | All checks PASS | ROUTE → IRIS |

---

## 2. Current State

**BLOCKED** — Validation nodes require `execute_python` (broken) or native `filter_list`/`if_else_routing` (missing).

---

## 3. Status

**BLOCKED** — Awaiting native rebuild (Option A).