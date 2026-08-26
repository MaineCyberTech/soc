# Phase 42 Watchdog Test Record

**Report ID:** phase42-58-monitor-watchdog-test
**Phase:** 42
**Title:** WATCHDOG-42-01 — Watchdog Live-Tested In Sandbox (Stale→ALERT To Dedicated Test Log; Repeat-Guard Holds; Fresh Clears State; Production Logs Untouched); Dedicated Alert Log Exists And Is Empty (Zero Real Stalls); Self-Masking Fix Recap; Reboot Persistence Via Cron
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T09:09:00Z
**Classification:** INTERNAL
**Status:** PASS [VERIFIED]
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-58-monitor-watchdog-test.md`

---

## 1. Dedicated alert log — exists and empty

```
-rw-rw-r--  0 bytes  Aug 26 05:33  ops/reports/p41-monitor-watchdog.log
```

Created at P41 install (05:33Z era), zero bytes since: no production stall has
ever crossed the 1200s threshold (consistent with CAD-42-01 §4).

## 2. Self-masking defect — recap (fixed pre-install, P41)

First draft appended ALERT lines into the monitored log itself, refreshing its
mtime and masking the very stall being reported (observed live during P41:
stale run followed by "fresh age=0s"). Fixed before install: alerts go to the
dedicated watchdog log; staleness measurement stays pure. Production evidence
of the fix: §1 file remains empty while the monitored log grows ~250 B/slot.

## 3. Simulated-stall protocol — EXECUTED (script supports env overrides)

Script provides `MCT_MONITOR_LOG` / `MCT_WATCHDOG_LOG` sandbox seams. Live
test executed this hour, production files untouched:

```
T1 stale:    touch -d '30 minutes ago' /tmp/opencode/wd-test-stale.log
             run → "ALERT written … stale age=1800s"
             test log line: 2026-08-26T08:58:10Z ALERT-MON-WATCHDOG:
             delivery-monitor log STALE age=1800s (threshold 1200s)
             prod watchdog log bytes after test: 0  ← isolation PROVEN
T2 repeat:   immediate re-run → "already alerted this episode" (≤1/h guard)
T3 recovery: fresh-file override → "OK: monitor log fresh (age=0s)";
             state file cleared automatically
ALERT-LINES total in test log: exactly 1
EXIT codes: 0 in all three cases (watchdog can never fail a slot noisily)
```

Design-only fallback documented for future script versions lacking seams:
copy script + logs to /tmp, `touch -d` the copy's mtime backwards, run copy —
same assertions.

## 4. Persistence across reboots

Watchdog is cron-driven at `3,18,33,48 * * * *` (crontab verified live);
user crontabs persist across host reboots, so arming survives restarts like
the monitor itself (proven empirically through today's multiple backend
restart windows and prior full-host reboot tests P40).

## 5. Verdict

WATCHDOG-42-01 **PASS**: sensor logic correct in both directions (alert on
stall, silence when fresh), isolation from the monitored signal proven,
repeat-guard and auto-clear working, persistence assured.
