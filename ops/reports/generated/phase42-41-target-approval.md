# Phase 42 Restore Target Approval — Re-Presented, AWAITING-APPROVAL

**Report ID:** phase42-41-target-approval
**Phase:** 42
**Title:** RT-APPR-42-01 — Approval Memo Re-Presented Unchanged: Recommended Primary Cloud VM 8 vCPU / 32GB / 300GB SSD (Isolated), Candidates Matrix Stable Across Two Phases; Provisioning Remains Owner-Gated And Nothing Is Pre-Committed
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:03:00Z
**Classification:** INTERNAL
**Status:** AWAITING-APPROVAL
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-41-target-approval.md`

---

## 1. Status

**AWAITING-APPROVAL.** The memo (RT-APPR-41-01) is re-presented verbatim with
its candidate matrix unchanged. Automation cannot self-approve spend; declining
costs nothing and leaves the NO-GO rehearsal posture untouched.

## 2. Recommendation (unchanged)

**PRIMARY: C1 cloud VM at exact floor sizing** — 8 vCPU / 32GB RAM / 300GB SSD,
isolated segment/NAT-only, provider + account + spend ceiling named by owner.
Lead time collapses to minutes-to-hours once confirmed.

## 3. Candidates matrix (stable across P39→P41→P42)

| Archetype | Verdict |
|---|---|
| C1 — Cloud VM 8vCPU/32GB/300GB SSD | **PRIMARY (recommended)** — cleanest isolation, exact spec fit, fastest lead-time |
| C2 — Workstation-hypervisor VM | SECONDARY — $0 marginal, conditional on free disk/RAM verification |
| C3 — Spare LXC/host capacity | Backup option — verify-first, shared-kernel isolation engineering required |
| C4 — Repurposed spare-metal hypervisor | Reserve — strongest on-prem isolation if hardware exists |

Floors unchanged (RESTORE-CRIT-39-01): ≥8 cores, ≥32GB RAM, ≥300GB SSD-class,
isolated segment, compose ≥ current host, root/sudo + Stage2 secrets path.
Current-host self-disqualification stands (84% full at last measure).

## 4. Four owner asks (carried from memo)

1. Name cloud provider + account for C1.
2. Approve spend ceiling for rehearsal window.
3. Countersign approval memo.
4. Authorize Stage2 secrets-transfer path.

## 5. What approval opens / what delay costs

- Approval → Stage0 checklist opens (RESTORE-CRIT-39-01 §7); provisioning is
  still gated on the named account.
- Delay → rehearsal stays NO-GO; published v1.3.0 custody remains CLOSED
  byte-exact and ready, so zero restore-readiness is lost by waiting — only the
  drill date slips.
