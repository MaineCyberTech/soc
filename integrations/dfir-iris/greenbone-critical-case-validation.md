# Greenbone Critical Case Validation (IRIS side)

## Case creation path

```text
Greenbone alert -> Shuffle webhook -> workflow -> IRIS POST /alerts/add
  (Bearer IRIS API key) -> IRIS alert -> promote to case (critical-vulnerability template)
```

## IRIS API validation (done Phase 4/5)

- `GET /api/ping` with API key: 200 pong (key valid).
- IRIS reachable at https://iriswebapp_nginx:8443 from Shuffle network (action URL confirmed in workflow).

## Manual fallback (if Shuffle/automation fails)

1. Export Greenbone report (CSV/PDF) from VM103.
2. IRIS -> Cases -> New (critical-vulnerability template fields).
3. Paste raw finding JSON into case description.
4. Tags: source:greenbone, class:B (or A if internet-facing), manual-escalation.

## Acceptance for D5

- [x] Webhook endpoint reachable (Shuffle responds)
- [x] Workflow exists (or documented reuse path)
- [x] IRIS template exists (11 fields)
- [x] Notify-only preserved
- [ ] Greenbone alert config on VM103 (operator action - last hop)
- [ ] End-to-end synthetic payload creates IRIS case (operator test after alert config)

## Notes

- Severity mapping: internet-facing critical -> IRIS severity 4; internal -> 2-3.
- Client notification per critical-vulnerability template criteria.
