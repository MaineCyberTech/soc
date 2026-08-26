# Phase 41 Owner Batch Plan — One-Session Operator Package (60 Minutes)

**Report ID:** phase41-19-owner-batch-plan
**Phase:** 41
**Title:** OWNER-BATCH-41-01 — Single-Sitting Operator Agenda Closing Every Open Owner Gate: 013 Power-On (T+0), 015 Sleep Remediation Via Screen-Share (T+10), DEC-40-01 Signature Walk-Through (T+20), Restore-Target Decision From Candidate Matrix (T+35), Wrap/Fleet-Verify/Filing (T+50); Automation-Only Run — No Human Available, Package Staged Verbatim
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:45:00Z
**Classification:** INTERNAL
**Status:** PLAN-ONLY (package staged; awaiting scheduling)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-19-owner-batch-plan.md`

---

## 0. Reality statement

No owner/operator session has occurred. This phase ran automation-only. Per pack
acceptance rules, everything below is **precisely packaged and ready to execute**
— nothing in it has been performed, and no signoff exists or may be fabricated.
One 60-minute sitting closes every currently open owner gate in this stack.

## 1. Ordered agenda (60 minutes, hard slots)

| Slot | Item | Deliverable if completed |
|------|------|--------------------------|
| T+0 → T+10 | Agent 013 SAMSUNG power-on + network verify | 013 `active`; sustained-proof window opens (phase41-21) |
| T+10 → T+20 | Agent 015 Julians-Air sleep remediation via screen-share | Fix applied; 24h clean-window clock starts (phase41-25) |
| T+20 → T+35 | DEC-40-01 signature walk-through (populated sheet, phase41-27) | Signed decision sheet; RTO/RPO values become binding |
| T+35 → T+50 | Restore-target decision from candidate matrix (phase41-29/-30/-31) | Approval memo countersigned; provisioning authorized |
| T+50 → T+60 | Wrap: live fleet verify + signatures filed + follow-up windows booked | Register entries written; checkpoints scheduled |

Slot discipline: if any item exceeds its slot by >5 minutes, park it with a
BLOCKED note (§5 stop conditions) and move to the next slot. The batch is
designed so partial completion still banks real progress.

## 2. Per-item detail

### T+0 — Agent 013 power-on + network verify (10 min)

- **Prerequisites:** physical access to the SAMSUNG laptop; known home Wi-Fi /
  Ethernet credentials. Server side already verified good (manager ports 1514/
  1515 listening, enrollment identity preserved — phase40-15 §2–3).
- **Steps:** power on → join known network → check `sc query WazuhSvc`
  (start via Services.msc only if stopped) → wait ≤10 min for keepalive.
- **Evidence captured:** live API poll showing `013 active` with fresh
  `lastKeepAlive` (<600s); phase40-16 postcheck executed same-day; screenshot
  or transcript filed to `ops/evidence/`.
- **Stop conditions:** `WazuhSvc` fails to start after two manual attempts →
  STOP, escalate. Do **not** reinstall the agent over the preserved enrollment.
- **Rollback notes:** none required — recovery is read-only server-side; a
  failed attempt leaves fleet state exactly as-is (phase40-15 §5).

### T+10 — Agent 015 sleep remediation via screen-share (10 min)

- **Prerequisites:** screen-share session onto Julians-Air (macOS 14.8.7),
  admin rights on the device. Prepared package: phase41-24 (caffeinate wrapper,
  launchd plist sample, Energy-settings GUI path).
- **Steps:** install/launch per phase41-24 §2–3 (smoke `caffeinate -dis -t 28800`,
  then persistent launchd plist or GUI Energy changes); observe API keepalive.
- **Evidence captured:** plist installed path + `launchctl list | grep mct`
  output; Energy settings state; first sustained keepalive observation logged;
  24h window start timestamp recorded (opens phase41-25 clock).
- **Stop conditions:** no admin credentials or screen-share refused → hand the
  owner the phase41-24 package for async self-apply; slot closes PARKED.
- **Rollback notes:** `launchctl unload -w` + delete plist fully reverts;
  Energy settings are GUI-reversible. Zero server-side change.

### T+20 — DEC-40-01 signature walk-through (15 min)

- **Prerequisites:** populated review sheet open/printed (phase41-27 —
  recommendations pre-filled ADOPT, evidence refs refreshed).
- **Steps:** walk rows 1–12; owner marks exactly one of A/M/R per row; sign +
  date. Modified values written inline; register entry recorded same day.
- **Evidence captured:** signed sheet scanned/photographed into
  `ops/evidence/`; change-register entry quoting each disposition verbatim.
- **Stop conditions:** owner rejects the interim-governance row → park that
  row; other rows may still be adopted individually (no all-or-nothing rule).
- **Rollback notes:** an unsigned sheet changes nothing — DRAFT-TARGET
  governance (phase40-72 §4) simply remains in force.

### T+35 — Restore-target decision (15 min)

- **Prerequisites:** candidate matrix (phase41-29), NOT-READY assessment
  (phase41-30), approval memo (phase41-31) open side-by-side.
- **Steps:** owner selects primary (recommended: cloud VM 8 vCPU / 32GB /
  300GB SSD, isolated) or names an alternative; approves provisioning spend
  and the Stage2 secrets-transfer path; countersigns memo.
- **Evidence captured:** countersigned memo filed; provider/account name +
  sizing recorded in register; Stage0 checklist (RESTORE-CRIT-39-01 §7) opened.
- **Stop conditions:** no budget/account available today → memo stays
  AWAITING-APPROVAL with the named blocker recorded; no provisional approval.
- **Rollback notes:** nothing is provisioned before approval; declining costs
  nothing and leaves the NO-GO posture untouched.

### T+50 — Wrap (10 min)

- **Steps:** live fleet verify via `GET /agents` (expect 013 active, 015 in
  sustained-keepalive, 014/016 active); file all signatures in register;
  book checkpoints: phase41-21 sustained-proof polls (+10/+20/+30 min),
  phase41-25 24h window close, Stage0 opening when target lands.
- **Evidence captured:** final API snapshot appended to the session record;
  register entries cross-linked to phase41-20/-22/-26 successors.

## 3. Global stop conditions

1. Any credential request beyond device/network access → stop; the batch
   deliberately requires none.
2. Any step needing server-side change outside approved scope → stop; park.
3. Device safety conflict (e.g., 013 battery/hardware fault suspected) → stop;
   escalate rather than force.

## 4. Scheduling ask — DRAFTED VERBATIM (send as-is)

> **Subject:** One 60-minute sitting unblocks the whole SOC backlog
>
> Hi — one hour, single sitting, and everything currently waiting on you gets
> closed. Nothing here needs preparation; bring the laptop that's been off
> (SAMSUNG) and have the Mac (Julians-Air) awake.
>
> What happens, in order:
> 1. (10 min) You power the SAMSUNG laptop on and join the usual network. That's
>    the whole step — I verify from my side while you watch.
> 2. (10 min) Screen-share on the Mac: I walk you through two clicks plus one
>    Terminal command so it stops dropping overnight. Fully reversible.
> 3. (15 min) We walk a one-page decision sheet on backup/restore targets
>    (RTO/RPO). Recommendations are pre-filled; you mark agree/change per line
>    and sign.
> 4. (15 min) Pick a restore-drill machine from a shortlist I'll show (my
>    recommendation takes 2 minutes to explain) and approve getting it stood up.
> 5. (10 min) I verify the whole fleet live, file the paperwork, done.
>
> If you can't get an hour, the minimum viable substitute: power on the SAMSUNG
> laptop and reply "ADOPT ALL" to the decision sheet email — that alone converts
> two blockers. Everything else waits, honestly labeled as waiting.

## 5. Non-goals

This report executes nothing, signs nothing, and provisions nothing. It exists
so the owner session itself is short, ordered, evidence-producing, and free of
surprises.
