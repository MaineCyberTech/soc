# Phase 19 Client Fleet Health

Date: 2026-08-18

## Endpoint status

| id | Name | Platform | IP | Status | Role |
|---|---|---|---|---|---|
| 015 | Julians-Air | macOS | 192.168.111.77 | **disconnected** since 08-18 09:04 UTC | billable client endpoint |
| 014 | DESKTOP-MI54LFT | Windows | 192.168.111.162 | active | billable client endpoint |
| 013 | SAMSUNG | Windows | 192.168.111.166 | **offline** since 08-16 13:27 | billable client endpoint (power/offline) |
| 012 | MCT-WIN11PILOT | Windows | 192.168.222.244 | active | pilot |
| 011 | mct-linux-client01 | Linux | 192.168.222.240 | active | client pilot (Linux) |
| 008 | securityonion | Oracle Linux | 192.168.222.116 | active | SO bridge (packet) |
| 007 | mct-portal-dev | Ubuntu | 138.197.105.82 | active | portal VPS |
| 006 | docker-host | Debian | 127.0.0.1 | active | infra |
| 000 | wazuh.master | - | 127.0.0.1 | active | infra |

## Fleet health assessment

- **Billable endpoints: 3 (013/014/015).** 1 of 3 healthy (014). 015 offline due to
  unresolved unified-log flood (top priority). 013 offline since 08-16 (suspected power;
  matches P18).
- No active threats on any endpoint this period. No new incident cases.
- macOS 015 telemetry quality: flood masks signal (2.5M docs/week in archives); fix pending.
- Windows 014 telemetry nominal (Sysmon/EventChannel live).
- Backup/DR: local snapshot fresh, S3 bundle fresh (<48h), phase2 config <48h - OK.

## Actions

1. Operator: apply macOS 015 flood fix (Phase 19.02-04).
2. Operator: confirm 013 power/connectivity; re-onboard if needed.
3. Keep 014 monitoring; scorecard progress in `phase19-scorecard-progress.md`.

## No secrets