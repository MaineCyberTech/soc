# Phase 41 Restore Target Approval Request — AWAITING-APPROVAL

**Report ID:** phase41-31-restore-target-approval
**Phase:** 41
**Title:** RT-APPR-41-01 — Approval Request Record: Decision Memo DRAFTED Verbatim Naming Recommended Primary (Cloud VM 8 vCPU / 32GB / 300GB SSD, Isolated); Four Explicit Owner Asks; Status AWAITING-APPROVAL — No Approval Exists And Automation Cannot Self-Approve
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:57:00Z
**Classification:** INTERNAL
**Status:** PENDING (AWAITING-APPROVAL)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-31-restore-target-approval.md`

---

## 1. Status

**AWAITING-APPROVAL.** Provisioning any target is an owner-gated action under
the pack rules and AGENTS.md approval gates. The memo below is complete,
decision-ready, and deliberately short. Nothing has been provisioned, spent, or
contacted on the strength of it.

## 2. Decision memo (drafted verbatim, awaiting countersignature)

> **To:** MCT SOC owner
> **From:** Phase 41 automation (opencode/ox-alpha)
> **Subject:** Approval request — restore-drill target (recommended: cloud VM)
>
> **Ask:** approve one isolated machine for the full-cluster restore rehearsal.
> Recommendation of record: **cloud VM, 8 vCPU / 32GB RAM / 300GB SSD**, in a
> private network with no route to production. This is the PRIMARY candidate;
> a workstation-hypervisor VM is the documented SECONDARY if you prefer data
> never leaves premises.
>
> **Why this shape:** it exactly meets the minimum spec we froze in Phase 39
> (RESTORE-CRIT-39-01), can exist minutes after your confirmation, gives the
> cleanest isolation evidence, and disappears at teardown per the cleanup
> contract — no permanent hardware decision hiding inside a drill.
>
> **I need four things from you:**
> 1. Provider + account to use (this is literally the only open input — the
>    candidate is labeled "could-you-confirm" for that reason).
> 2. A spend ceiling for the rehearsal window (on-demand hourly plus egress
>    when we pull snapshots down).
> 3. Agreement on the secrets path: restore material only, injected at the
>    documented Stage2 step, nothing broader leaves the vault.
> 4. Authorization that provisioning + passing its Stage0 checklist opens the
>    rehearsal GO/NO-GO evaluation.
>
> Reply "APPROVED AS RECOMMENDED" plus items 1–2 and I will file it verbatim
> with timestamp and start the checklist.

## 3. Disposition rules once returned

- Countersigned memo → register entry (verbatim) → K1–K6 checklist in
  phase41-30 begins filling for the named candidate only.
- Any modification (different sizing/archetype) → memo re-issued as -R1 with
  delta noted; original request preserved unedited.
- Decline/no-response → status remains AWAITING-APPROVAL with blocker named;
  NO-GO posture unchanged; no provisional or implied approvals recognized.

## 4. Non-goals

This record neither executes Stage0 nor pre-commits the rehearsal verdict. It
converts "someday we need a target" into a single signable page.
