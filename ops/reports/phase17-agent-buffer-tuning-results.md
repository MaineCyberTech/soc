# Phase 17 Agent Buffer Tuning Results

Date: 2026-08-16

## Status: FIX APPLIED + VALIDATED

## Change

- mac-clients group: unbounded macOS unified-logging stream ->
  bounded /var/log/system.log syslog localfile.

## Before/After

| Metric | Before (07:44-08:13) | After (08:13+) |
|---|---|---|
| Queue-full alerts | 15 (~every 10-30s) | **0** |
| macOS events | mostly internal (SCA/queue) | loginwindow/sudo arriving |
| Data loss risk | HIGH (queue overflow) | NONE |

## Validation

- Shared config hash updated (e26104dc).
- Agent active, config synced.
- Queue-full: 0 since 08:13 (4h+ check).

## No secrets
