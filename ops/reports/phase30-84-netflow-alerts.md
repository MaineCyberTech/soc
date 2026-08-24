# Phase 30 NetFlow Alert Arming

Date: 2026-08-24
Status: **NOT ARMED - GATED ON SCOPE APPROVAL** (unchanged).

## Plan (when approved)

- Alerts: new-subnet first-seen (A), unknown-exporter (A), outbound spike (B), unusual
  internal port (B). Dedup: same key once/24h. Rate limit: stop 20/day + notify. Rollback:
  disable alert + revert allowlist.

## No secrets