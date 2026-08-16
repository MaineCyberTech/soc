# Minimum Monitoring Package (First External Client)

## Included (standard)

| Capability | Deliverable |
|---|---|
| Endpoint monitoring | Wazuh agent: FIM, syscollector, logs, auth/brute force detection |
| Network flow analysis | ElastiFlow at client gateway (if MCT-managed network) |
| Vulnerability scanning | Monthly safe-discovery scan (with authorization) |
| Alert monitoring | 24/7 SOC monitoring with defined escalation |
| Monthly scorecard | Client-ready report (coverage, alerts, vulns, posture) |
| Incident response | IRIS case management; manual containment approval |

## Optional (with authorization)

| Capability | Prereq |
|---|---|
| Deception (canary VM + tokens) | canary-authorization signed; placement approved |
| Windows telemetry (Sysmon) | pilot-tested; per-endpoint approval |
| EDR collection (Velociraptor) | client rollout approved |
| Security Onion IDS | dedicated SO deployment (per site) |

## Explicitly NOT included by default

- Automated blocking/quarantine (manual approval only)
- Broad Windows rollout without pilot
- Invasive vulnerability scans without authorization
- Public dashboard exposure

## Client Zero validation

- Package mirrors Client Zero (validated live): 4 agents, flows, canary,
  alerts, scorecards, IRIS cases.
- Gaps closed 2026-08-15: vulnerability scanning schedule created (weekly lab schedule + production schedule in place),
  RAM increase, credential rotation.

## First-30-days expectation

- Onboard agents -> baseline -> first scan -> first scorecard -> tuning
  (see external-client-first-30-days.md).
