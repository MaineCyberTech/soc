# Phase 41 Agent 013 — Sustained-Proof Window Protocol (PLAN-ONLY)

**Report ID:** phase41-21-agent013-sustained-proof
**Phase:** 41
**Title:** SUSTAIN-013-41-01 — Recovery Proof Protocol: ≥3 Fresh Keepalive Observations Over ≥30 Minutes Plus Attributable Event Flow; Window Cannot Open Before Owner Recovery (phase41-20); Protocol Frozen Now So Post-Session Execution Is Mechanical
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T04:47:00Z
**Classification:** INTERNAL
**Status:** PLAN-ONLY (protocol defined; window not openable)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-21-agent013-sustained-proof.md`

---

## 1. Purpose

A single API poll showing `active` proves nothing about stability. This protocol
defines the minimum evidence that 013's recovery is real and sustained, frozen
in advance so the post-session execution is mechanical and cannot be shaped
around whatever the data happens to show.

## 2. Window definition

- **T0** = first API observation of `013 status=active` after the phase41-20
  session (S3 pass).
- **Duration:** ≥30 minutes from T0.
- **Sampling:** `GET /agents?agents_list=013` at T0, +10, +20, +30 minutes
  (4 samples minimum). Auth pattern per existing tooling (`p33-core-alert.sh`
  style: token → Bearer GET against `https://127.0.0.1:55000`).

## 3. Pass criteria (ALL required)

1. **Keepalive persistence:** ≥3 of the 4 samples (including T+30) show
   `status=active` with strictly increasing `lastKeepAlive` timestamps.
2. **Event flow:** ≥1 event attributable to agent 013 reaches the alerts
   pipeline during the window — verified via indexer query on
   `wazuh-alerts-*` filtered `agent.id: "013"` with `@timestamp ≥ T0`, or, if
   the endpoint is quiet by nature, a benign activity marker generated during
   the window (login/heartbeat-class event) so flow is genuinely demonstrated,
   never assumed.
3. **No disconnect transition:** zero `disconnection_time` updates during the
   window.

## 4. Fail handling

- Any disconnect mid-window → window is void; a fresh window opens at the next
  reconnect. No partial credit, no averaging across attempts.
- Keepalive present but zero attributable events in 30 min → extend once by one
  additional +10 min sample; if still silent, record PARTIAL-with-explanation
  rather than PASS.

## 5. Recording template (frozen)

```
SUSTAIN-013 window T0=<ISO8601>  samples:
  T0    : status=____ KA=__________
  T+10  : status=____ KA=__________
  T+20  : status=____ KA=__________
  T+30  : status=____ KA=__________
event-flow check: query=<ref> hits=__ verdict=____
verdict: PASS | FAIL(reason) | PARTIAL(reason)
```

Filed to `ops/evidence/` and referenced by the phase41-22 certification when it
is issued.

## 6. Status honesty

The window **cannot open** until phase41-20 S1–S3 complete (owner action). As
of this report's timestamp the agent is >22h dark (baseline row in phase41-20
§2); no sample exists, none is projected, and none may be invented.
