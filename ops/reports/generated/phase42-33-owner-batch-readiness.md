# Phase 42 Owner Batch Readiness — Final Packaged Session Agenda

**Report ID:** phase42-33-owner-batch-readiness
**Phase:** 42
**Title:** OWNER-BATCH-42-FINAL — Single-Sitting Agenda Updated From P41-19 With Live Baselines: 013 Power-On (T+0), 015 Caffeinate-Plist Via Screenshare (T+10), DEC-40-01 Signature (T+20), Restore-Target Decision Unchanged (T+35), Fleet+Signature Verify/Filing (T+50); Every Artifact Staged And Ready — Nothing Executed, No Owner Available
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:55:00Z
**Classification:** INTERNAL
**Status:** AWAITING-SCHEDULING
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-33-owner-batch-readiness.md`

---

## 1. Status

**AWAITING-SCHEDULING.** No owner is available (automation-only environment).
This report supersedes phase41-19 as the canonical session package: same
60-minute shape, refreshed with today's live baselines and the morning's
repair-churn closure (which removed one background-noise item owners used to
see). Everything below is precisely packaged; nothing has been executed and no
signoff exists or may be fabricated.

## 2. Live baselines at packaging time (API pull 2026-08-26T08:49:39Z)

| Agent | Name | Status | lastKeepAlive | Age |
|---|---|---|---|---|
| 013 | SAMSUNG | **disconnected** | 2026-08-25T06:20:29Z | **26.5h** |
| 015 | Julians-Air | disconnected-at-pull (flap) | 2026-08-26T06:58:49Z | 1.8h |
| 006/007/011/012/014/016 | — | active | ≤08:49:38Z | <1min |

## 3. Ordered agenda (60 minutes, hard slots)

### T+0 — Agent 013 power-on + network verify (10 min)
- **Prerequisites:** physical access to the SAMSUNG laptop; known network
  credentials. Server side verified good (phase40-15 §2–3; enrollment identity
  preserved, id 013 unchanged).
- **Steps:** power on → join network → `sc query WazuhSvc` (start only if
  stopped) → wait ≤10 min for keepalive.
- **Evidence:** API poll showing `013 active`, fresh `lastKeepAlive` (<600s);
  phase40-16 postcheck re-run same day; transcript filed to `ops/evidence/`.
- **Stop conditions:** `WazuhSvc` fails twice → STOP, escalate; never reinstall
  over preserved enrollment.
- **Rollback:** none required — read-only server-side.

### T+10 — Agent 015 caffeinate plist install via screenshare (10 min)
- **Prerequisites:** screen-share onto Julians-Air (macOS), admin rights.
  Package ready verbatim: `caffeinate -dis -t 28800` smoke, then launchd plist
  `com.mct.soc.caffeinate` (`RunAtLoad`+`KeepAlive`) or Energy GUI path —
  phase41-24 §2–3, unchanged.
- **Evidence:** plist path + `launchctl list | grep mct`; first sustained
  keepalive logged; 24h clean-window clock opened (phase42-38 protocol).
- **Stop conditions:** no admin creds / share refused → hand package over for
  async self-apply; slot closes PARKED.
- **Rollback:** `launchctl unload -w` + delete plist; GUI-reversible; zero
  server-side change.

### T+20 — DEC-40-01 signature walk-through (15 min)
- **Prerequisites:** populated sheet (phase41-27) open/printed; recommendations
  pre-filled ADOPT.
- **Evidence:** signed sheet scanned into `ops/evidence/`; register entry with
  per-row dispositions.
- **Stop conditions:** any rejected row parks individually — not all-or-nothing.
- **Rollback:** unsigned sheet changes nothing; DRAFT-TARGET governance remains.

### T+35 — Restore-target decision (15 min) — recommendation unchanged
- **Prerequisites:** candidate matrix (phase41-29), assessment (phase41-30),
  memo (phase41-31) open side-by-side.
- **Recommendation unchanged:** PRIMARY cloud VM 8 vCPU / 32GB / 300GB SSD,
  isolated; SECONDARY workstation-hypervisor VM.
- **Evidence:** countersigned memo filed; provider/account/sizing registered;
  Stage0 checklist opens.
- **Stop conditions:** no budget/account → stays AWAITING-APPROVAL with blocker
  named; no provisional approval.

### T+50 — Verify fleet + signatures filed (10 min)
- **Steps:** `GET /agents` fleet snapshot (expect 013 active, 015 sustained);
  file all signatures in register; book checkpoints: 013 sustained-proof polls
  (+10/+20/+30 min, phase42-35), 015 24h window close (phase42-38), Stage0 on
  target landing.

## 4. Global stop conditions

1. Any credential request beyond device/network access → stop.
2. Server-side change outside approved scope → park.
3. Suspected hardware fault on 013 → escalate, do not force.

## 5. Scheduling ask — carried VERBATIM from phase41-19 §4 (send as-is)

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

## 6. Non-goals

This report executes nothing, signs nothing, provisions nothing, and schedules
nothing. It exists so the session, once scheduled, is short, ordered, and
evidence-producing.
