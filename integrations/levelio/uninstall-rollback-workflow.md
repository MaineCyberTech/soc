# Uninstall / Rollback Workflow (level.io)

## When

- Offboarding (per offboarding-checklist.md).
- Pilot failure / reinstall.
- Wrong group assignment.

## Flow

1. Run matching uninstall script (idempotent).
2. Remove agent from Wazuh: agent_control -r <id> (or UI) - AFTER uninstall confirmed.
3. Update inventory + group membership in level.io.
4. If reinstall: fix variables, re-run installer.

## Rollback safety

- Uninstall scripts never touch data volumes.
- Wazuh agent removal keeps local ossec data (purge optional with --purge flag).
- Sysmon uninstall via -u (clean driver removal).
- Velociraptor service remove + config deletion.

## Verification after uninstall

- Service gone (sc query / systemctl).
- No agent in Wazuh active list.
- level.io device shows script success.
