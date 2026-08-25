# Phase 37 — /tmp Threshold Design

**Date:** 2026-08-25

## Threshold Definitions

| Level | Threshold | Value |
|-------|-----------|-------|
| DEGRADED | >50% usage | >3.8GB |
| FAILED | >70% usage | >5.3GB |
| INODE WARNING | >80% inode usage | >80% |
| FILE COUNT | >50,000 files | >50,000 |
| CREATION RATE | >1,000 files/hour | >1,000/hr |

## Deduplication

- **State Change Rule:** Requires 2 consecutive readings at or above threshold to trigger state change
- **Purpose:** Prevent flapping from transient spikes

## Recovery

- **Auto Recovery:** Yes — state resets automatically after cleanup reduces usage below threshold

## Ownership

- **Owner:** SOC

## Runbook

1. Check cron status (`crontab -l` or systemd timer)
2. Run manual cleanup if cron failed: `find /tmp -name 'pip-*' -mtime +1 -delete`
3. Investigate producer if usage remains elevated after cleanup

## Summary

Threshold design for /tmp monitoring. DEGRADED at 50%, FAILED at 70%. Additional thresholds for inodes, file count, and creation rate. Dedup requires 2 consecutive readings. Recovery is automatic post-cleanup. Owner: SOC.

## No secrets
