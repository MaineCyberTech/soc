# Phase 14 Client 013 Sysmon Validation

Date: 2026-08-16

## Status: VALIDATED

## Sysmon collection (24h, agent 013)

| Check | Result |
|---|---|
| Sysmon channel flowing | PASS - 175 events/24h |
| EID distribution | EID 7 image loads: 148, EID 1 process creation: 27 |
| Config source | shared windows-clients agent.conf (added P13) |
| Collection start | 2026-08-16 ~04:36 (after shared config fix) |

## Windows channels

| Channel | Count (24h) | Status |
|---|---|---|
| Sysmon/Operational | 175 | PASS |
| Security | 35 | PASS |
| System | 30 | PASS |
| Application | 27 | PASS |

## Gaps

- None for collection. (EID 3 network, EID 6 service events not observed in the
  first 24h - normal for an idle workstation; coverage will grow with use.)

## No secrets

No secret values printed.
