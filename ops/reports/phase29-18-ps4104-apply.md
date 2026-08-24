# Phase 29 PowerShell 4104 - Apply (Method)

Date: 2026-08-24
Status: **NOT APPLIED - approval pending** (C5).

## Enable procedure (on approval)

1. On 012 only: enable EventID 4104 collection in Sysmon/Wazuh config.
2. Reload agent + verify collection (query alerts for rule/event 4104 from agent 012).
3. Record baseline counts. Rollback = revert config on 012.

## Evidence to post-apply

- 4104 event count from 012 (per window), sample of rule hits, buffer health.

## No secrets