# Monthly Service Review Flow

Date: 2026-08-15

## Flow

```
Month start
   |
   v
[1] Healthcheck + capacity   (scripts)
   |
   v
[2] Backup freshness         (script)
   |
   v
[3] Endpoint counts          (script)
   |
   v
[4] Alert quality review     (report)
   |
   v
[5] Vulnerability review     (Greenbone export, authorized only)
   |
   v
[6] Client scorecard         (template + QA)
   |
   v
[7] Billing review           (template)
   |
   v
[8] Client communication     (templates)
   |
   v
[9] Retrospective -> runbook updates
```

## Gates

- Scorecard release gate: QA checklist PASS (no secrets/internal details).
- Vulnerability gate: signed authorization required before scan.
- Billing gate: endpoint counts verified.

## Artifacts stored

- ops/reports/full-stack-health-latest.md
- ops/reports/phase10-* (this phase)
- reporting/output/client/phase10-first-client-scorecard-start.md
- service-packaging/monthly-billing-review-template.md

## No secrets

No secret values printed.
