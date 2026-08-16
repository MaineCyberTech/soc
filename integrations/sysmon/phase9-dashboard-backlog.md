# Phase 9 Dashboard Backlog

## Dashboards to build (Wazuh dashboard, windows-clients)

| # | Dashboard | Data source | Status |
|---|---|---|---|
| 1 | Windows endpoint health (agent 012): agent status, Sysmon service, last events | wazuh-alerts + wazuh-archives | PENDING (needs archives indexed) |
| 2 | Sysmon event overview: EID distribution, top images, top network conns | wazuh-archives (channel Microsoft-Windows-Sysmon) | PENDING |
| 3 | Windows auth events: 4624/4634 logon types, failures, RDP | wazuh-alerts | PENDING |
| 4 | Process creation (once EID 1 unfiltered): LOLBins watchlist | wazuh-archives | PENDING |
| 5 | Level 9+ alerts timeline for agent 012 | wazuh-alerts | CAN BUILD NOW |

## Notes

- Archives shipping now enabled (P9.06 fix) - dashboards 1-4 become possible
  once the backlog indexes.
- Keep dashboards client-safe (no internal-only details).

## No secrets

No secret values printed.
