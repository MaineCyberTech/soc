# Wazuh Alert -> Velociraptor Hunt Map

When a Wazuh alert fires, analysts launch the corresponding Velociraptor hunt for evidence. Hunts are documented here with the artifacts to run and expected findings.

## Windows

| Wazuh alert family | Hunt | Artifacts (client) | Findings |
|---|---|---|---|
| Persistence detection (registry/run keys, services, scheduled tasks) | persistence-runkeys-services-scheduledtasks | `Windows.System.Persistence`*, `Windows.Registry.RunKeys`, `Windows.Persistence.*` | New/modified run keys, services, scheduled tasks |
| Suspicious PowerShell | suspicious-powershell | `Windows.Powershell.EventLogs`, `Windows.AntiMalware.MicrosoftIOC`* | Obfuscated commands, script blocks, download cradle |
| LOLBins execution | lolbins-execution | `Windows.System.SuspiciousExecutables`*, `Windows.Forensics.Prefetch` | MSBuild/powershell/certutil executions, prefetch hits |
| RDP/logon anomalies | rdp-and-logon-artifacts | `Windows.System.TerminalServices`*, `Windows.Forensics.Logs` (Event 4624/4625) | RDP sessions, failed/successful logons, source IPs |
| Defender exclusions added | defender-exclusions | `Windows.AntiMalware.Defender`* | New exclusion entries (cover-up behavior) |
| Browser downloads (phishing) | browser-downloads | `Windows.Applications.Chrome.*`, `Windows.Applications.Firefox.*`* | Recent downloads, browser history for initial access |
| New local admin / privilege changes | new-local-admins | `Windows.System.Users`*, `Windows.Registry.AdminSDHolder`* | New accounts, admin group membership changes |

## Linux

| Wazuh alert family | Hunt | Artifacts (client) | Findings |
|---|---|---|---|
| SSH anomaly | ssh-authorized-keys | `Linux.System.SSH.AuthorizedKeys`, `Linux.System.Users` | New/backdoored authorized_keys, user list |
| Sudoers/user changes | sudoers-and-new-users | `Linux.System.Sudoers`, `Linux.System.Users` | Modified sudoers, new users |
| Cron/systemd persistence | cron-and-systemd-persistence | `Linux.Persistence.Cron`*, `Linux.System.Systemd`* | New cron entries, systemd units |
| Suspicious listening ports | listening-ports | `Linux.Network.ListeningPorts` | Unexpected services/ports |
| Suspicious process | suspicious-processes | `Linux.System.Processes` | Unknown processes, binary paths |
| Docker abuse | docker-socket-and-privileged-containers | `Linux.Docker.*` | Privileged containers, docker.sock mounts |

## Docker hosts

| Wazuh alert family | Hunt | Artifacts | Findings |
|---|---|---|---|
| Privileged container created | privileged-containers | `Linux.Docker.Info`, `Linux.Docker.Containers`* | Privileged=true containers |
| docker.sock mounted | docker-sock-mounts | `Linux.Docker.Containers`* + mount inspection | Containers mounting /var/run/docker.sock |
| Unexpected exposed ports | unexpected-exposed-ports | `Linux.Network.ListeningPorts`, `Linux.Docker.Containers`* | New published ports |
| New image pull | recent-new-images | `Linux.Docker.Images`* | Newly pulled images not in baseline |
| Container evidence | container-file-evidence | `Linux.Docker.ContainerLogs`*, overlay FS copy | Logs/configs for IR |

* = artifact families; verify exact artifact names in the installed Velociraptor version before running a hunt.

## Launch procedure

1. From the Wazuh alert, note agent OS and alert family.
2. Open Velociraptor GUI -> Hunt Manager -> New Hunt.
3. Add the client artifacts from the table.
4. Select affected clients (or hunt over client label, e.g. `client:mct`).
5. Launch; collect results; export zip -> attach to IRIS case (`dfir-iris-evidence-workflow.md`).

## Failure modes

- Client offline: mark hunt pending, retry at next window, note in case.
- Hunt fails on one artifact: other artifacts still return; check server log for artifact version mismatch.
