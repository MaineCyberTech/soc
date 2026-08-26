# Phase 41 Monitor Hardening — Missed-Schedule Watchdog Implemented And Tested

**Report ID:** phase41-39-hardening
**Phase:** 41
**Title:** HARD-MON-41-01 — Staleness Watchdog Shipped (p41-monitor-watchdog.sh + cron 3,18,33,48): Detects >20min Monitor Stall Within One Slot; Self-Masking Defect Caught In Test And Fixed Before Install; Hardened P40 Script Untouched
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:31:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (implemented, tested, installed)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-39-hardening.md`

---

## 1. Gap addressed

The monitor itself was silent-proof but not *presence*-proof: if its cron slot
stopped firing entirely, the log simply stopped growing and nothing complained.
Overnight audit (phase41-36) relied on a human noticing.

## 2. Implementation (tiny wrapper — hardened script NOT modified)

New file: `ops/scripts/p41-monitor-watchdog.sh` (additive only).

- Signal: age of `shuffle-delivery-monitor.log` mtime vs now.
- Threshold: **1200s** (> one */15 slot); cadence of watchdog: slots
  `3,18,33,48 * * * *` — offset 3 minutes behind the monitor so every monitor
  slot is checked ~3 min after it should have written.
- Alert sink: dedicated `ops/reports/p41-monitor-watchdog.log` — **not** the
  monitored log (see §3). Repeat-guard: at most one alert per hour per
  continuous stall episode (state file `/tmp/opencode/p41-mon-watchdog.state`);
  freshness clears the episode.
- Secret-free by construction (no tokens, no API calls); exit 0 always so the
  watchdog can never fail a cron slot noisily.
- Test seams: `MCT_MONITOR_LOG` / `MCT_WATCHDOG_LOG` env overrides keep tests
  sandboxed away from production files.

Crontab delta (verified by diff against saved pre-image `/tmp/opencode/crontab.before`):
exactly two appended lines — comment + schedule. No pre-existing entry touched.

## 3. Defect caught during test (honest record)

First draft appended the ALERT line **into the monitored log**, which refreshed
its mtime and masked the very stall being reported (observed live: stale run
followed by "fresh age=0s"). Fixed before install: alerts go to the dedicated
watchdog log; staleness measurement stays pure.

## 4. Verification matrix [VERIFIED]

| Path | Setup | Result |
|------|-------|--------|
| Healthy | real production log (age=210–246s) | `OK … fresh`, exit 0, no writes |
| Stale | sandboxed log aged 4711s | alert line written to watchdog log with UTC timestamp + age, exit 0 |
| Repeat-guard | immediate second stale check | `already alerted this episode`; still exactly 1 alert line |

Rollback: remove the two crontab lines + delete the script; zero coupling to
the P40-hardened monitor.

## 5. Residual design note

Per-line timestamps in the monitor's own output remain unbuilt (P42 candidate);
until then the watchdog measures presence (mtime), not content correctness.
