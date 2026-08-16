# Endpoint Deployment Kit Rollout Status

Date: 2026-08-12

| Component | Status | Evidence |
|---|---|---|
| Linux installer | READY | syntax OK, public IP default, pw required |
| macOS installer | READY | syntax OK, public IP default, pw required |
| Windows installer | READY | pw required, Sysmon embedded |
| Verify scripts | READY | PASS/FAIL checks + exit codes |
| Uninstall scripts | READY | idempotent |
| sysmon-mct.xml | READY | conservative, detection-backlog aligned |
| prepare-velociraptor-client.sh | VERIFIED | 3 clients enrolled from generated configs |
| README | READY | level.io variable plan + public IP notes |

## Pilots

- Linux: pending (local target available)
- macOS: blocked (no device)
- Windows: blocked (no device)

## Rollout gates

1. One-device pilot per OS -> verify PASS -> then group rollout.
2. No broad deployment without operator approval.
