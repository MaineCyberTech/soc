# Phase 43: Packet Downstream Failure Proof

**Report ID:** phase43-56-packet-downstream-failure.md
**Phase:** 43
**Title:** Phase 43 Packet Downstream Failure Proof
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T21:15:00Z
**Classification:** INTERNAL
**Status:** BLOCKED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-56-packet-downstream-failure.md`

---

## 1. Purpose

Prove packet workflow fails closed when IRIS/downstream is unreachable.

---

## 1. Test Scenarios

| Scenario | Action | Expected |
|--------|--------|----------|
| IRIS down | `docker stop iriswebapp_nginx` | HTTP node FAIL CLOSED; no false FINISHED |
| IRIS 500 | Mock 500 response | Same |
| IRIS timeout | `tc qdisc add dev eth0 root netem delay 10s` | Timeout → ABORT |
| IRIS 400 | Send malformed body | HTTP 400 → FAIL CLOSED |

---

## 2. Expected Behavior

| Failure | HTTP Node | Workflow Status | Retry |
|---------|-----------|-----------------|-------|
| Connection refused | ABORT | ABORTED | No retry (fail closed) |
| HTTP 500 | ABORT | ABORTED | No retry |
| HTTP 400 | ABORT | ABORTED | No retry |
| Timeout | ABORT | ABORTED | No retry |

---

## 2. Precedent (Class-A Lane)

| Evidence | Finding |
|----------|---------|
| P41 DNS failures | 65 FINISHED but 31 with IRIS DNS failure → FINISHED≠Delivered |
| P42 monitor | 04:15Z & 07:45Z real fail-closed captured | Proves fail-closed detection works |

---

## 3. Current State

**BLOCKED** — Packet workflow HTTP node uses `post_request` (not available); needs `POST` function. Platform defect blocks proof.

---

## 4. Status

**BLOCKED** — Awaiting native rebuild or platform upgrade.