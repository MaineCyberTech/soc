# External Client Readiness Review (Phase 7)

Date: 2026-08-12
Decision: **GO (conditional) - first external client pilot approved with documented conditions**

## Evidence reviewed

| Area | Status | Evidence |
|---|---|---|
| Endpoint deployment kit | READY | audit PASS, Linux pilot PASS (6/6), Velociraptor config verified |
| Linux pilot | PASS | docker-host, Active, verify 6/6 |
| macOS pilot | BLOCKED (no device) | installer ready |
| Windows pilot | BLOCKED (no device) | installer + Sysmon config ready |
| Velociraptor | WORKING | 3 clients, safe hunt executed |
| Backup cron | PROVEN | 5 jobs simulated with cron syntax; scheduled runs pending timing |
| Service packages | READY | 5 documents (packages, pricing matrix, deliverables, 30-day, SLA) |
| Scorecards | READY | client-ready + sample external |
| Credential rotation | DEFERRED | framework ready |
| Canary/Canarytoken | PARTIAL | local canary validated; tokens blocked |
| Greenbone | READY | GSA procedure documented; schedule pending operator |

## Client impact of remaining blockers

| Blocker | Client impact | Mitigation |
|---|---|---|
| No Windows/macOS pilot | Cannot offer Windows/Sysmon or macOS monitoring yet | Limit first client to Linux endpoints OR provide devices |
| Greenbone schedule pending | Vulnerability reporting delayed | GSA operator action (1-2h) |
| RAM/swap pressure | Monitoring host stability risk | Add RAM before client #1 |
| Credentials deferred | Operational risk only | internal, not client-visible |
| Canarytokens pending | Deception add-on unavailable | local canary only, or defer add-on |

## Go/No-Go

- **GO (conditional)**: onboard first external client with Linux-only scope,
  provided: (1) operator adds RAM, (2) first client has Linux endpoints,
  (3) scan authorization signed, (4) Greenbone schedule created.
- **NO-GO for**: Windows-only clients, clients requiring Sysmon, until pilot devices exist.

## Files

- ops/reports/external-client-readiness-review-phase7.md (this file)
- client-onboarding/external-client-go-no-go.md
- client-onboarding/first-client-pilot-plan.md
