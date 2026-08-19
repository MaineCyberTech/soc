# Phase 19 NetFlow Alerting Readiness

Date: 2026-08-18
Status: **NOT READY - BLOCKED on operator subnet confirmation.**

## Gating checklist

| Requirement | State |
|---|---|
| Subnet classification complete | PARTIAL - 13 subnets (~417K flows/24h) pending operator confirm |
| Exporter list fixed | YES (2 exporters identified) |
| Alert queries defined | YES (4 queries, plan prepared) |
| Noise dry-run on 7d history | NOT RUN (blocked: baseline allowlist incomplete) |
| Rules + routing deployed | NO (gated) |

## Summary

- Alerting plan exists (`integrations/elastiflow/phase19-new-subnet-alerting-plan.md`).
- Cannot arm until the operator confirms the unknown subnet set. Otherwise "new subnet"
  alerts would fire constantly for the 417K flows/24h of unclassified traffic.
- Recommended next action: operator answers the 3 scope questions in
  `ops/reports/phase19-netflow-scope-decision.md`; then dry-run + enable Class A.

## No secrets