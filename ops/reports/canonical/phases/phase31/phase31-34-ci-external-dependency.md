# Phase 31 CI External Dependency Semantics

Date: 2026-08-24
Status: **APPLIED**.

- External systems now carry distinct states in CI/health: RETIRED (Security Onion/agent
  008), BLOCKED (packet-visibility SPAN, fresh-target, credentials), DEGRADED (endpoints,
  capacity). CI no longer conflates external outage with code failure (health/CI green;
  agent 008 = RETIRED notice).
- Enforced by p31-health-state-audit.py against config/health-state-components.json.

## No secrets
