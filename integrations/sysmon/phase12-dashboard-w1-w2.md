# Phase 12 Dashboard W1/W2 Plan

Date: 2026-08-16
Status: DATA READY - dashboards buildable

## W1 - Windows endpoint health

Panels (saved searches exist, P10):
- Agent status (012 active, last keepalive)
- Sysmon service running (events in last 24h)
- Channel flow (Sysmon/Security/Application/System volumes)
- Syscheck last run

## W2 - Sysmon overview

Panels:
- EID distribution (current: EID 1=231, EID 7=162, EID 10=13)
- Top images (by EID 1 count)
- Top processes
- Top network connections (EID 3)

## Status

- W1/W2: READY to build - indexer data confirmed (agent 012 flowing, channels
  verified 2026-08-16).
- W4/W5: blocked on rules/PS logging (see phase12-windows-tuning-cycle.md).

## No secrets

No secret values printed.
