# Phase 10 Windows Dashboard Backlog

Date: 2026-08-15

## Dashboards to build (Wazuh dashboard, windows-clients)

| # | Dashboard | Panels (from saved searches) | Status |
|---|---|---|---|
| W1 | Windows endpoint health | agent status, last events, sysmon service, channel flow | READY (data available) |
| W2 | Sysmon overview | EID distribution, top images, top processes, top network | READY |
| W3 | Windows auth | 4624/4625 logons, RDP, failures by src | READY |
| W4 | Process creation | LOLBin watch, temp paths, encoded cmd | NEEDS D1-D4 rules |
| W5 | PowerShell | EID 4104 volume + detections | NEEDS PS logging enabled |
| W6 | Service/task changes | 7045/4698 + EID 6 | READY |
| W7 | Network by process | EID 3 top conns | READY |
| W8 | Level 9+ alerts timeline | rule.level>=9 agent 012 | READY |

## Priority

1. W1 + W2 (baseline visibility) - build now.
2. W3 + W7 + W8 - build after W1/W2.
3. W4 + W5 + W6 - after detection rules measured on pilot.

## Notes

- Data sources confirmed (archives caught up, sysmon indexed).
- Keep client-safe (no internal-only details).

## No secrets

No secret values printed.
