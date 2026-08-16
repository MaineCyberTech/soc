# Sysmon Deployment — Windows 11

Purpose: deploy Sysmon with a conservative config on Windows 11 endpoints, then collect telemetry through Wazuh.

## Preconditions

- Operator approval for a pilot group before production rollout (no production rollout without approval).
- Wazuh agent already installed and enrolled (see `windows-endpoint-onboarding.md`).

## Install

1. Download Sysmon from Microsoft Sysinternals (https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon).
2. Validate the config file locally (see config notes below) — start from the SwiftOnSecurity baseline, trimmed to the MCT detection categories.
3. Install elevated:

```powershell
# From an elevated PowerShell on the endpoint or via RMM:
.\Sysmon64.exe -accepteula -i sysmon-mct.xml
```

4. Verify service:

```powershell
sc query Sysmon64
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational -MaxEvents 5
```

## Recommended baseline config (summary)

| EventID | Category |
|---|---|
| 1 | Process creation (filter out known safe image paths) |
| 3 | Network connections (filter loopback) |
| 5 | Process terminate |
| 6 | Driver loads |
| 7 | Image loaded (filter MS paths; high volume — enable after tuning) |
| 8 | CreateRemoteThread (LOLBin/shellcode indicator) |
| 10 | Process access (credential access indicators) |
| 11 | File create (downloads, office documents) |
| 12/13/14 | Registry persistence |
| 15 | Alternate data streams |
| 17/18 | Named pipes / pipe events |
| 22 | DNS queries (QNAME — enable after tuning; high volume) |
| 25 | Change time (file timestamp changes) |

Filtering: exclude Windows/System32/Program Files known-safe image paths; exclude loopback; exclude MCT admin tooling paths after baseline.

## Config management

- Store the tuned `sysmon-mct.xml` in `integrations/sysmon/` (additive repo file).
- Version the config; log changes in `ops/reports`.
- Rollout via GPO/RMM script; verify Event 1 volume after 24h per pilot host.

## Uninstall / rollback

```powershell
.\Sysmon64.exe -u
```

Wazuh collection config removal: remove the localfile block from the agent group, restart agent.

## Acceptance

- Event 1 (process creation) visible in Wazuh after deployment (see `windows-test-events.md`).
- No change to existing Linux agent groups.
