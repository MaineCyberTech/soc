# Phase 43: Packet SID Decisions

**Report ID:** phase43-58-packet-sid-decisions.md
**Phase:** 43
**Title:** Phase 43 Packet SID Decisions
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T22:00:00Z
**Classification:** INTERNAL
**Status:** DEFERRED
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase43-58-packet-sid-decisions.md`

---

## 1. Candidate SIDs

| SID | Description | Source | Priority | Status |
|-----|-------------|--------|----------|--------|
| 2027967 | ET MALWARE LiLocked Ransomware Note | ET Open / Canary | P0 (canary) | APPROVED |
| 2027968 | ET MALWARE ... | ET Open | P1 | PENDING |
| 2260001 | SURICATA Applayer Wrong Direction | Suricata | P2 (natural) | DEFERRED |
| 2210038 | ... | Suricata | P2 | DEFERRED |
| 2100366 | ... | Suricata | P2 | DEFERRED |

---

## 1. Decision Criteria

| Criterion | Threshold |
|-----------|-----------|
| FP Rate | < 1% in 30-day window |
| Volume | < 100/day per SID |
| Detection Value | High (malware/C2/exploit) |
| Investigation Cost | Low (auto-triage) |

---

## 2. Status

**DEFERRED** — Awaits packet lane remediation (Option A/B/C) and FP baseline ≥50 natural alerts.