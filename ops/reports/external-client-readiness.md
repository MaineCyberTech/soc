# External Client Readiness

Date: 2026-08-11
Status: **READY - package complete; infrastructure items pending**

## Deliverables

- client-onboarding/external-client-readiness-checklist.md
- client-onboarding/minimum-monitoring-package.md
- client-onboarding/external-client-vuln-scan-authorization.md
- client-onboarding/external-client-canary-authorization.md
- client-onboarding/external-client-first-30-days.md
- ops/reports/external-client-readiness.md (this file)

## Acceptance

- Client-safe: YES (no secrets, no internal stack details)
- Clear minimum package: YES (standard vs optional vs excluded)
- Maps to current capabilities: YES (mirrors Client Zero)

## Prereq for client #1 (operator items)

1. PVE access (RAM increase + VM provisioning for canary/Windows if offered).
2. Greenbone schedule creation (vuln scanning live).
3. P1 credential rotation.
4. Velociraptor GUI admin password set (hunt launches).

## Timeline

- Client Zero validated -> package frozen -> first external client intake.
