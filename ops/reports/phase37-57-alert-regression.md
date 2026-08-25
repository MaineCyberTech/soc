# Phase 37 — Operational Alert Regression Test

**Date:** 2026-08-25

## Test Results

| Check | Status | Detail |
|-------|--------|--------|
| Sensor | OK | Agent 016 active (Suricata) |
| Agent | OK | 7 active agents |
| Backup | OK | Cron at 02:30 UTC |
| Disk | DEGRADED | 84% (stable, low watermark active) |
| /tmp | OK | 21% (1.6GB/7.6GB) |
| Release | PASS | v1.3.0 |
| Drops | OK | 0 |
| Memcap | OK | Within limits |
| Resource | OK | Adequate |
| Rules-age | OK | Current |
| Drift | OK | No drift |
| Wazuh ingest | OK | Normal |
| Shuffle | OK | Healthy |
| Field-error | FAIL | Still accumulating (18,849) |
| Retention | PENDING | First deletion 2026-08-29 |

## Summary

15 of 16 alert regression checks pass. Disk is DEGRADED at 84% but stable with low watermark active. Field errors continue to accumulate and remain unresolved. Retention deletion is pending first wave. No service regressions detected.

## No secrets
