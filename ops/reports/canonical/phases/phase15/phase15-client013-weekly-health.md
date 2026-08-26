# Phase 15 Client 013 Weekly Health Checkpoint

Date: 2026-08-16 ~07:00 UTC

## Status: HEALTHY - telemetry flowing; client device currently powered off

| Item | Value |
|---|---|
| Agent | 013 SAMSUNG |
| Status NOW | **disconnected** (keepalive 06:41Z - device powered off/sleeping) |
| Node | worker01 |
| 24h events | 1,301 |
| Sysmon | 213 (EID 1+7) |
| Windows channels | System 39, Security 38, Application 34 |
| Alert levels | 3-7 dominate (noise); lvl 12: 79 (SCA/canary context); lvl 10: 44 (VaultCli FPs pre-fix window) |
| Threats | NONE actionable |

## Notes

- Disconnection = client workstation off/sleep (was idle since ~06:41). Normal
  for an endpoint; Wazuh reconnects automatically on power-on.
- Suppression validation (P15.12/13) still pending next active events.

## No secrets
