# Sysmon Pilot Final Results

Date: 2026-08-11
Status: **NOT DEPLOYED - precise blocker: no Windows endpoint; PVE API 401**

## Deliverables (Phase 5)

- ops/runbooks/windows-sysmon-velociraptor-pilot.md - full pilot checklist + rollback
- integrations/sysmon/windows-sysmon-agent-group.xml - agent group config
- integrations/sysmon/sysmon-validation-results.md - validation plan (not run)
- integrations/velociraptor/windows-client-enrollment.md - enrollment steps (blocked)
- reporting/templates/windows-endpoint-telemetry-summary.md - reporting template

## Blocker

- PVE API credentials rejected (401) - cannot provision Windows 11 VM.
- Velociraptor frontend port conflict (Portainer owns 8000) - separate server-side fix.

## Acceptance

- One endpoint only: CONFIRMED
- No broad deployment: CONFIRMED
- Validation results documented if run: N/A (not run)
- Rollback documented: YES
