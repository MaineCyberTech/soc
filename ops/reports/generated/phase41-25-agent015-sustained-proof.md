# Phase 41 Agent 015 — Sustained-Proof Protocol (24h Clean Window, PLAN-ONLY)

**Report ID:** phase41-25-agent015-sustained-proof
**Phase:** 41
**Title:** SUSTAIN-015-41-01 — Post-Fix Acceptance Protocol: 24-Hour Zero-Unplanned-Disconnect Window With Continuous Keepalive Freshness; Clock Opens Only At Remediation Apply (phase41-24); Frozen In Advance To Prevent Post-Hoc Shaping
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:51:00Z
**Classification:** INTERNAL
**Status:** PLAN-ONLY (protocol defined; clock not started)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-25-agent015-sustained-proof.md`

---

## 1. Purpose

phase40-23 item 4 required a stability window before re-certification but left
the mechanics open. This freezes them now, before the fix exists on the device,
so acceptance cannot be negotiated after the data is in.

## 2. Window definition

- **T_apply** = timestamp recorded when phase41-24 §2/§3/§4 remediation is
  applied on the device (owner session T+10 slot or async self-apply).
- **Window** = [T_apply, T_apply + 24h], evaluated at close.

## 3. Pass criteria (ALL required)

1. **Zero unplanned disconnect transitions:** `GET /agents` for 015 must show no
   `disconnection_time` update inside the window.
2. **Continuous keepalive freshness:** sampling every ≤10 minutes shows
   `status=active` (or `lastKeepAlive` age <600s) in every sample across the
   window — a sleeping device fails this within one sample.
3. **Event-flow sanity (light):** ≥1 attributable event from 015 reaches the
   pipeline during the window, proving the sustained connection carries data,
   not just heartbeats.

## 4. Exceptions and failure handling

- **Intentional shutdown/lid-close chosen by owner mid-window** → window voids
  and restarts at next T_apply-class event; documented intentional restarts do
  not count as "unplanned" only if declared in advance in the session record.
- Any single failed sample ⇒ FAIL; flap persists ⇒ return to phase41-24
  alternatives: working-hours-only caffeinate discipline, or Option 3
  accept-with-monitoring which requires explicit owner acknowledgment that
  overnight coverage gaps are accepted (register-recorded).
- Sampling gap >30 min (operator-side outage) → window restarts; honesty over
  convenience.

## 5. Recording template (frozen)

```
SUSTAIN-015 T_apply=<ISO8601> method=<smoke|plist|energy|combo>
samples (every ≤10 min): count=__ all-active=Y/N max_KA_age_s=__
disconnect_transitions_in_window: __
attributable_events: query=<ref> hits=__
verdict: PASS | FAIL(reason) | VOID(reason)
```

PASS feeds directly into the phase41-26 certification upgrade (connectivity
dimension flips OPEN→RESOLVED with this artifact attached).

## 6. Status honesty

No sample exists. The device flapped again this morning (KA 04:20:01Z → disc
04:38:34Z, phase41-23 §2), which is precisely why the clock has not started.
Nothing in this protocol may begin until human hands touch the Mac.
