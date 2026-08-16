# First Client Pilot Plan

## Scope

- 1 client site, Linux endpoints only (Windows/macOS pending pilot devices).
- Package: Managed Security Monitoring - Standard (flows + vuln scan add-on).

## Steps

1. Intake (client-intake-form.md) + escalation matrix.
2. Agent group `client-<name>` created in Wazuh.
3. Deploy agents via level.io (linux-clients group vars).
4. Baseline alert volume + first scan (authorized).
5. First scorecard at day 30 (phase7 client-ready template).
6. 30-day review per client-first-30-days-runbook.md.

## Acceptance

- Agents 100% active 7+ days.
- First scan report delivered; criticals have remediation plan.
- Scorecard acknowledged.
- Offboarding path documented.

## Rollback

- Uninstall agents (uninstall scripts), remove group, archive data per retention.
