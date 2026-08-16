# Phase 10 Sysmon Archive Catch-Up

Date: 2026-08-15

## Status: COMPLETE

| Item | Value |
|---|---|
| Filebeat archives shipping | ENABLED (since P9.06) |
| Backlog (P9.06) | 2.4GB |
| Filebeat offset vs file size | CAUGHT UP (offset == size) |
| Latest archive indexed | current (23:53+) |
| Sysmon events in indexer | 24k+ today, growing |

## What was done

1. Verified archives shipping enabled (filebeat.yml archives: true).
2. Verified filebeat caught up (offset at file end).
3. **Fixed agent 012 stall** (logcollector stopped at 21:00 UTC; WazuhSvc restart
   restored flow - logged in phase10-change-control.md).
4. Confirmed sysmon events index (EventID breakdown query works).

## Before/After

- Before: sysmon channel events invisible (archives shipping disabled + agent stall).
- After: all sysmon events indexed and queryable (24k today).

## Notes

- The 2.4GB backlog drained over ~3h after enabling shipping (P9.06).
- Archive index retention: monitor with capacity-threshold-check.sh (disk 66%).

## No secrets

No secret values printed.
