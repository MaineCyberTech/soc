# Phase 36: /tmp Cleanup Design

Date: 2026-08-25

## Proposed cleanup
- Cron job: find /tmp -name "pip-*" -mtime +1 -delete
- Frequency: daily at 03:00 UTC
- Scope: Python temp files only
- Safety: -mtime +1 (only files older than 24h)

## Alternative
- systemd timer for more control
- Or: periodic manual cleanup

## Decision: Cron job (simple, proven)

## No secrets
