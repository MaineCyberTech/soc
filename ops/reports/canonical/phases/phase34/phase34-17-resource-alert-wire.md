# Phase 34 Sensor Resource Alert Wiring

Date: 2026-08-25

## Implementation
- Memory: MemoryCurrent via systemd show, alert on > 1.5GiB (hard ceiling 2GiB)
- CPU: CPUUsageNSec delta, alert on sustained > 80%
- PSI: /proc/pressure/memory, alert on avg10 > 0 for > 5min
- EVE disk: alert on eve.json size growth rate anomaly

## Current state
- Memory: 74MB current / 74MB peak (< 2GiB limit)
- CPU: ~1.2%
- PSI: 0 (no pressure)
- EVE disk: ~1092 lines, 17s age

## Evidence
- Wired into sensor-side alert runner + core cron
- All HEALTHY

## Runbook
- Investigate Suricata memory leak
- Check detect engine rule count

## No secrets
