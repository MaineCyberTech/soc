# Wazuh Alert -> Velociraptor Hunt Map (Phase 4)

Cross-reference for launching Velociraptor hunts from Wazuh alerts.
Base map: integrations/velociraptor/wazuh-alert-to-hunt-map.md

## Windows

| Wazuh alert family | Hunt | Artifacts | Findings |
|---|---|---|---|
| Persistence (registry/services/tasks) | persistence-runkeys-services-scheduledtasks | Windows.System.Persistence, Windows.Registry.RunKeys | New run keys, services, tasks |
| Suspicious PowerShell | suspicious-powershell | Windows.Powershell.EventLogs, MicrosoftIOC | Obfuscated commands, download cradles |
| LOLBins | lolbins-execution | SuspiciousExecutables, Prefetch | certutil/mshta/powershell executions |
| RDP/logon anomalies | rdp-and-logon-artifacts | TerminalServices, Event 4624/4625 | RDP sessions, logon sources |
| Defender exclusion changes | defender-exclusions | Windows.AntiMalware.Defender | New exclusions (cover-up) |
| Browser downloads | browser-downloads | Chrome/Firefox history | Initial access artifacts |
| New admin/privilege changes | new-local-admins | Users, AdminSDHolder | Account/group changes |

## Linux

| Wazuh alert family | Hunt | Findings |
|---|---|---|
| SSH anomaly | ssh-authorized-keys | New/backdoored authorized_keys |
| Sudoers/user changes | sudoers-and-new-users | Modified sudoers, new users |
| Cron/systemd persistence | cron-and-systemd-persistence | New cron, systemd units |
| Suspicious ports | listening-ports | Unexpected services |
| Suspicious process | suspicious-processes | Unknown binaries |
| Docker abuse | docker-socket-and-privileged-containers | Privileged containers |

## Sysmon pilot (future)

Once Windows Sysmon pilot deploys, add: Event 1 (process) -> process-chain hunt,
Event 3 (network) -> external-network-connections hunt.

## Blockers

- No clients enrolled (2026-08-11). Enrollment via rollout runbooks required
  before hunts can execute. This map is the analyst reference for when clients exist.

## Phase 5 update

- Test client enrollment attempted 2026-08-11: BLOCKED by frontend port
  conflict (Portainer owns 8000; Velociraptor clients pointed at 8000).
  Fix documented in test-client-enrollment.md. Hunts below become executable
  once the client-server path is restored.
