# Install -> Verify -> Report Workflow (level.io)

## Flow

1. Trigger: run installer on target device (manual or automation on enrollment).
2. Installer exits: 0 = success, 1 = failure (clear error message).
3. Verify: run verify script (PASS/FAIL per check, exit 1 on any FAIL).
4. Report: level.io script output shows [PASS]/[FAIL]; alert on non-zero exit.
5. Confirm in Wazuh: Agents -> new agent Active; group assignment correct.

## level.io automation

- Create a "deployment" policy: install on device add -> verify after 5 min.
- Alert rule: verify script exit != 0 -> notify SOC.
- Expected runtime: install 2-5 min, verify < 1 min.

## Verification criteria (per OS)

| Check | Linux | macOS | Windows |
|---|---|---|---|
| Agent process | pgrep wazuh-agent | wazuh-control status | WazuhSvc Running |
| Enrolled | client.keys | client.keys | client.keys |
| Manager set | ossec.conf address | ossec.conf address | ossec.conf address |
| Sysmon | n/a | n/a | Sysmon64 + events |
| Velociraptor | optional | optional | optional |
