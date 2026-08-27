# Phase 44: Restore Target Decision

**Report ID:** phase44-30-restore-target
**Phase:** 44
**Title:** Phase 44 — Restore Target Decision
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T23:05:00Z
**Classification:** INTERNAL
**Status:** AWAITING-OWNER
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase44-30-restore-target.md`

---

## 1. Candidate Targets

| Target | Spec | Pros | Cons | Status |
|--------|------|------|------|--------|
| **Cloud VM** (8vCPU/32GB/300GB) | Elastic, isolated, matches prod | Recurring cost; provisioning time | **RECOMMENDED** |
| Workstation Hypervisor | 8-16 vCPU, 16-32GB, 500GB | Zero cost; local | Not isolated; resource contention | SECONDARY |
| Spare LXC Host | 8vCPU/16GB/200GB | Zero cost; same platform | Shared hardware; capacity risk | TERTIARY |

---

## 2. Decision Matrix

| Criterion | Cloud VM | Workstation | LXC Host |
|---------|----------|-------------|----------|
| Isolation | ✅ Full | ❌ Shared | ❌ Shared |
| Capacity | ✅ 300GB | ✅ 500GB | ❌ 200GB |
| Network | ✅ Isolated VPC | ⚠️ NAT | ⚠️ Bridge |
| Cost | $150-300/mo | $0 | $0 |
| Provisioning | 15 min | 0 min | 0 min |

---

## 3. Decision Record (Awaiting Owner)

| Field | Value |
|-------|-------|
| Decision | [CLOUD_VM / WORKSTATION / LXC_HOST / DEFER] |
| Approved By | [Name] |
| Date | [YYYY-MM-DD] |
| Provisioning Deadline | [Date] |
| Budget Approved | [Y/N] |

---

## 2. Status

**AWAITING-OWNER** — Decision memo in phase44-31-target-approval.md; awaiting owner signoff.