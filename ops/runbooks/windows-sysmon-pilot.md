# Windows Sysmon Pilot Runbook

## Scope

One Windows 11 test endpoint ONLY. No broad deployment without explicit operator approval.

## Pilot endpoint stack

```text
Windows 11 test VM
├── Wazuh agent (enrolled to wazuh.master)
├── Sysmon (SwiftOnSecurity-derived config, trimmed for MCT detections)
└── Velociraptor client (enrolled to local server)
Optional later: osquery/Fleet
```

## Step 1: Provision endpoint

1. Create Windows 11 VM on PVE (or test hardware).
2. Join test network; assign static IP; document in asset inventory.
3. Install Wazuh agent, enroll to master (agent group `windows-sysmon-pilot`).
4. Install Velociraptor client (see `ops/runbooks/velociraptor-client-rollout-windows.md`).

## Step 2: Deploy Sysmon

1. Download Sysmon64 from Microsoft Sysinternals.
2. Validate config (start from `sysmon-mct.xml` baseline in integrations/sysmon).
3. Install: `Sysmon64.exe -accepteula -i sysmon-mct.xml`
4. Verify: `sc query Sysmon64`; `Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational -MaxEvents 5`.

## Step 3: Configure Wazuh agent collection

- Use `integrations/sysmon/wazuh-agent-sysmon-collection.xml` (agent group
  `windows-sysmon-pilot`): reads `Microsoft-Windows-Sysmon/Operational` via
  the Windows eventlog module.

## Step 4: Validate collection

1. Generate safe test events per `integrations/sysmon/test-event-checklist.md`:
   - Event 1 (process create) - run notepad from temp
   - Event 3 (network) - netstat/curl to local webhook
   - Event 22 (DNS) - nslookup of a test domain
2. Confirm events arrive in Wazuh:
   - `docker exec multi-node-wazuh.master-1 grep -c 'sysmon' /var/ossec/logs/archives/archives.json`
   - Search `event.id` fields in the alerts index.
3. Confirm Velociraptor client is online in the GUI.

## Step 5: Enable detections (2-week tune-in)

- Keep Sysmon Wazuh rules at log-only levels 6-8 for 2 weeks.
- Review FP rate weekly; raise levels per `sysmon-rule-plan.md`.
- CDB-dependent rules (101011/101070) stay disabled until MISP CDB is validated.

## Acceptance

- Event IDs 1/3/22/11/12-14 collect and archive.
- Dashboard `sysmon-dashboard-plan.md` shows the endpoint.
- Zero noise rules at level >= 9 for 2 weeks.

## Rollback

1. Uninstall Sysmon: `Sysmon64.exe -u` (or stop service + remove driver).
2. Remove agent group `windows-sysmon-pilot`; re-add endpoint to default group.
3. Remove Sysmon rules from local_rules.xml (backup first), restart analysisd.
4. Remove dashboard/alerting references.
5. Verify Wazuh ingest continues on the endpoint (no config loss).
