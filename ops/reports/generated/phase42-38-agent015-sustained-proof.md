# Phase 42 Agent 015 Sustained Proof — Protocol Armed, 24h Clean Window

**Report ID:** phase42-38-agent015-sustained-proof
**Phase:** 42
**Title:** SUS-015-42-01 — 24-Hour Clean-Window Protocol Pre-Committed: Zero Disconnections And All Keepalives Fresh Across A Full Day Post-Remediation; Clock Not Started Because No Remediation Has Been Applied; Baseline Flap Documented Live
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:00:00Z
**Classification:** INTERNAL
**Status:** BLOCKED-AWAITING-OWNER
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-38-agent015-sustained-proof.md`

---

## 1. Status

**BLOCKED-AWAITING-OWNER.** The 24h window can only start when the owner applies
the device-side fix (phase42-37). Starting it now would measure an unfixed
device and prove nothing. Protocol issued in advance so the bar is fixed before
evidence exists.

## 2. Live baseline (API pull 2026-08-26T08:49:39Z)

| Field | Value |
|---|---|
| id / name | `015` / `Julians-Air` |
| status at pull instant | disconnected (asleep at pull) |
| lastKeepAlive | `2026-08-26T06:58:49Z` (1.8h prior) |
| Pattern | periodic return when device wakes = sleep-driven flap, not connectivity fault |
| Permission arc | closed durably — 0 merged.mg errors since fix (manager log scan today) |

## 3. Protocol (pre-committed)

| Gate | Requirement |
|---|---|
| W1 — duration | ≥24h elapsed between T0 (first post-remediation keepalive) and window close poll |
| W2 — continuity | zero `disconnected` observations inside the window (polls every 15 min via existing agents CI cadence) |
| W3 — freshness | every polled `lastKeepAlive` <600s old at its poll instant |
| W4 — attribution | window starts only after plist load or Energy change is confirmed on-device (agenda T+10 evidence), so a pass measures the fix |

PASS = all gates green across the full window. Any disconnect inside the window
fails W2, the observation is documented with timestamps, and the protocol
restarts after re-remediation. Partial windows are reported as partial.

## 4. Honest limits

- A single clean day does not certify battery/hardware health; it certifies
  the sleep-flap closure under observed conditions.
- If the owner declines remediation, this protocol never starts and the flap
  stays OPEN by choice — recorded as such, indefinitely if needed.

## 5. Exit condition

On PASS, decision matrix gate for 015 flips to GREEN-SUSTAINED and final-state
certification (successor to phase41-26) is evaluated with real evidence.
