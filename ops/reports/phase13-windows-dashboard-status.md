# Phase 13 Windows Dashboard Status

Date: 2026-08-16

## Status: W1/W2 DEFINITIONS STAGED - UI import required

| Dashboard | Panels | Data ready | Buildable now |
|---|---|---|---|
| W1 Windows endpoint health | agent status, channel flow, volume trend, syscheck | YES (1371 evts/24h) | YES |
| W2 Sysmon overview | EID distribution, top images/processes/network | YES (452 sysmon/24h) | YES |
| W3 Windows auth | 4624/4625 logons | YES (Security 322/24h) | YES (deferred) |
| W4 Process creation | LOLBin/temp/encoded | NO - needs D1-D4 rules | no |
| W5 PowerShell | EID 4104 | NO - PS logging off | no |

## Blockers

- W1/W2/W3: definitions documented (phase13-dashboard-w1-w2.md); UI import
  requires operator dashboard session (no API import tooling in stack).
- W4: detection rules backlog (measurement-first).
- W5: PowerShell ScriptBlockLogging deferred until FP baseline stable.

## Recommendation

- Operator: create W1+W2 in Wazuh dashboard from the documented definitions
  (10-15 min). W3 optional now.

## No secrets

No secret values printed.
