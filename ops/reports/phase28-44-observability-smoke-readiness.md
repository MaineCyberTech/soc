# Phase 28 Observability Smoke Readiness

Date: 2026-08-24

## Install-time health checks (for a new deployment)

| Stage | Check | Signal |
|---|---|---|
| indexer | cluster health green | `_cluster/health` |
| manager | wazuh-analysisd -t rc=0 | syntax clean |
| dashboard | https 9443 200 | login page |
| iris | app + db healthy | healthcheck |
| shuffle | backend/frontend up | api reachable |
| integration | custom-json-output enabled + guardrail OK | guardrail check |
| endpoints | 3/3 active + telemetry flowing | wazuh API |
| backup | bundle produced + mirrored | 04:00 cron + s3 |
| smoke event | synthetic Class A -> guardrail count increments | end-to-end route |

## Smoke test design

- Emit one synthetic marked event; assert: Wazuh alert -> guardrail counter increments
  (proves intake + cron), workflow path (UI-dependent).
- Log dashboards/panels: existing W1/W2 (gated), health check dashboard.

## Acceptance signals (per component)

- Healthcheck 0 FAIL; CI PASS; secret PASS; cluster green; disk < 85%.

## Verdict

- Smoke readiness defined; synthetic smoke event executable now (guardrail path), full
  IRIS path pending Shuffle UI (19).

## No secrets