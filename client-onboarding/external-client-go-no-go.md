# External Client Go/No-Go

Date: 2026-08-12
Decision: **GO (conditional) - Linux-only first client**

## Conditions (all required)

- [ ] VM101 RAM increased (16+ GiB) - monitoring host stability
- [ ] First client scope = Linux endpoints only (no Windows/macOS until pilots pass)
- [ ] Vulnerability scan authorization signed
- [x] Greenbone schedule created (MCT-lab-weekly-sun-0600, 2026-08-15)
- [ ] Escalation contacts verified (P3 test passes)

## If any condition unmet

- NO-GO for that client; escalate to operator for unblock.

## If conditions met

- Follow first-client-pilot-plan.md -> 30-day runbook -> first scorecard.
