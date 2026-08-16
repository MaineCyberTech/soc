# Greenbone Critical Alert Validation (Phase 9)

## D5 Alert config (verified 2026-08-15)

| Item | Value |
|---|---|
| Alert id | 0daca165-bb08-472c-a59a-4fa1e84bd5e7 |
| Name | MCT-Critical-to-Shuffle |
| Condition | Severity at least 9.0 |
| Event | Task run status changed -> Done |
| Method | HTTP Get -> Shuffle webhook (host 192.168.222.149:3001, hook path) |
| Active | 1 (enabled) |

## Validation

- Latest lab scan (report 8eeb4a46): all findings severity 0.0 -> NO critical
  findings -> alert correctly did NOT fire (condition is severity >= 9.0).
- The alert route (Greenbone -> Shuffle webhook) was validated in Phase 2/8
  config; the endpoint is reachable (Shuffle backend healthy per healthcheck).
- **Safe-payload validation option**: create a test task against a target with
  known critical findings, or temporarily set condition severity >= 0.0 with a
  test run, then revert. NOT executed (would create noise); documented pending.

## Conclusion

- D5 critical alert route EXISTS and is ACTIVE.
- Validation with real critical findings: PENDING (no critical findings in lab
  scans yet; production authorization not granted for broader scans).

## No secrets

No secret values printed (webhook URL truncated/cited by host only).
