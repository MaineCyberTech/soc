# Phase 41 Restore Rehearsal Readiness — Scoreboard Updated, Overall NOT-READY

**Report ID:** phase41-32-restore-rehearsal-readiness
**Phase:** 41
**Title:** READY-DR-41-01 — Readiness Scoreboard Refreshed With TODAY'S UPGRADE: Asset-Custody Gate CLOSED (Published Original On-Box, Byte-Exact sha256 da72bde4… vs Published Identity) And Identity-Verification Gate GREEN Same Act; Objectives Ready-To-Sign But Unsigned; Target ABSENT ⇒ Overall NOT-READY (2 Of 7 Gates Newly Green Today)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:58:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (readiness verdict recorded: NOT-READY)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-32-restore-rehearsal-readiness.md`

---

## 1. Today's upgrade, stated precisely

Until yesterday the rehearsal-input question was stuck at PARTIAL: only a
rebuilt-labeled archive existed on-box, and gzip streams cannot be claimed equal
to the published asset. **Today the published original itself was retrieved and
verified byte-exact against its published identity:**

```
$ sha256sum ops/releases/v1.3.0/v1.3.0-published-original.tar.gz
da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c
```

That matches the published digest recorded in phase30-20 evidence and expected
by `ops/releases/v1.3.0/MANIFEST.md` (`da72bde4…`). Both artifacts now live in
`ops/releases/v1.3.0/`: the **published-original (primary)** and the
rebuilt-labeled variant (`65f794a7bc1552b5a69d4797d875c98aeecdd7e1831340f35fde66141d4dc775`,
retained as fallback). This flips two scoreboard gates green in one act — hence
"2 of 7 newly green."

## 2. Readiness scoreboard (7 gates)

| # | Gate | State | Basis |
|---|------|-------|-------|
| R1 | Adequate isolated external target provisioned | **RED — ABSENT (owner)** | No candidate provisioned (phase41-30 all-NOT-READY); host self-disqualified, re-measured today 148G/118G used/**84%** |
| R2 | RTO/RPO objectives decided | **RED — READY-TO-SIGN, UNSIGNED** | DEC-40-01-R1 sheet populated w/ ADOPT recommendations (phase41-27); transmittal issued (phase41-28); zero signatures exist |
| R3 | Rehearsal input asset custody on-box | **GREEN — NEW TODAY** | Published-original downloaded + stored `ops/releases/v1.3.0/`; sha256 verified this run |
| R4 | Asset identity verified vs published digest | **GREEN — NEW TODAY** | Byte-exact match `da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c`; rebuilt variant retained+disclosed as fallback |
| R5 | Snapshot readiness | **GREEN (maintained)** [VERIFIED live] | fs repo latest snap-20260826-0330 SUCCESS 03:30:04Z (58 idx; 42 snaps); s3 latest s3-snap-20260826-0047 SUCCESS 00:47:01Z (97 idx; 86 snaps @ fixed 5/day) |
| R6 | Isolation/data-safety plan + validation battery staged | **GREEN-on-provision (staged)** | RESTORE-CRIT-39-01 §3–4 contracts + plan v2 stage table ready; activate only when a target exists; V8 refinements added today (phase41-33) |
| R7 | Cleanup contract + execution approvals | **RED — SPLIT** | Cleanup READY by construction (Stage6 reaffirmed); execution approval absent — rehearsal authorization is an explicit owner act |

**Overall: NOT-READY.** Two gates flipped green today (R3, R4); every remaining
red gate is red for exactly one reason — no human decision has occurred yet.

## 3. What converts NOT-READY → READY

In dependency order: R1 via phase41-31 approval + provisioning checklist fill;
R2 via executed DEC-40-01-R1 (or "rehearsal runs to define RTO" authorization);
R7 via rehearsal-window authorization. All three are agenda slots T+20/T+35 of
the owner batch (phase41-19). R5/R6 require nothing — they are maintained
green by automation.

## 4. Non-goals

No rehearsal scheduled, no stage executed, no gate marked green on intent. The
scoreboard's only job is to make the distance-to-GO measurable and small.
