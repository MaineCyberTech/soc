# Canarytoken T1 Lifecycle (Phase 9)

## Token: T1 (planned)

- Type: document/file token (fake-backup-credentials.txt)
- Content: placeholder only (no real credentials)
- Destination: Shuffle webhook (notify-only)
- Placement: controlled lab/test location (operator approved)
- Owner: MCT SOC
- Status: PENDING (blocked on hosted account)

## Lifecycle stages

| Stage | Trigger | Action | Record |
|---|---|---|---|
| Create | Account exists | canarytokens.org/generate with auth-token; webhook = Shuffle hook | inventory |
| Deploy | Operator approval | Place token in approved location | inventory + date |
| Monitor | Weekly check | Verify token not tripped; verify Shuffle/IRIS health | ops logs |
| Test | On demand | Touch token -> expect Shuffle execution + IRIS case | this doc |
| Retire | Token compromised/aged | Remove artifact; disable token in service; note in inventory | inventory |
| Incident | Token tripped | IRIS case -> triage per incident-triage runbook | DFIR-IRIS |

## Cleanup procedure

1. Delete artifact from placement location.
2. Delete token in canarytokens service (if supported) or note retired.
3. Update canarytokens-inventory.md (status=retired, reason, date).

## No secrets

No secret values printed.
