# Phase 31 Health Severity Model

Date: 2026-08-24
Status: **STANDARDIZED** (enforced by p31-health-state-audit.py).

## States

| State | Meaning | Example |
|---|---|---|
| HEALTHY | all expectations met | wazuh cluster, backups |
| DEGRADED | partial/declining, operator watch | endpoints, capacity |
| BLOCKED | gated on external input | packet SPAN, fresh target, credentials |
| RETIRED | intentionally discontinued | Security Onion / agent 008 |
| MAINTENANCE | planned work | (none active) |
| FAILED | broken | (none current) |
| UNKNOWN | unclassified | n/a |

## Rules

- Every component carries state + owner + next_action (audit validates).
- RETIRED is never a false PASS and never alerts.
- BLOCKED shows required input + owner (43).

## No secrets