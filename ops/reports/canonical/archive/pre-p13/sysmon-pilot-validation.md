# Sysmon Pilot Validation

Date: 2026-08-11
Status: **NOT RUN - no Windows endpoint (blocked)**

## Acceptance

- One endpoint only: CONFIRMED (scope)
- Sysmon data visible OR blocker precise: BLOCKER (no VM; PVE 401)
- Velociraptor check-in works OR blocker precise: SERVER READY (8002 validated with Linux client); Windows client pending VM

## Validation plan (when VM exists)

1. Install Wazuh agent -> group windows-sysmon-pilot.
2. Sysmon64.exe -accepteula -i sysmon-mct.xml.
3. Test events 1/3/22 (test-event-checklist.md) -> verify archives.
4. Velociraptor client install (client-config-port-8002.md) -> GUI check-in.
5. 2-week tune-in at log-only levels.
