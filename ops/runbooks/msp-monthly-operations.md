# MSP Monthly Operations Runbook

Date: 2026-08-15

## Purpose

Standard monthly operating cycle for the MSP security service (all clients).

## Monthly workflow (1st week of month)

| Step | Task | Tool/Script | Output |
|---|---|---|---|
| 1 | Full-stack health check | full-stack-healthcheck.sh | health report |
| 2 | Capacity check | capacity-threshold-check.sh | threshold report |
| 3 | Backup verification | backup-freshness-check.sh | freshness report |
| 4 | Endpoint counts | endpoint-count-report.sh | counts report |
| 5 | Alert quality review | generate-alert-quality-report.py | alert quality |
| 6 | Vulnerability review | Greenbone report export | vuln review |
| 7 | Client scorecard | generate-monthly-scorecard.py + templates | client scorecard |
| 8 | Billing review | monthly-billing-review-template.md | billing summary |
| 9 | Client communication | templates (P10.14) | kickoff/summary/scorecard emails |
| 10 | Internal retrospective | notes (this runbook) | action items |

## Details

### 1. Health check
- Run full-stack-healthcheck.sh. 0 FAIL expected.
- Investigate any FAIL/WARN; log in change control.

### 2. Capacity
- Disk < 80% OK; swap < 70% OK; thin pool < 85% OK.
- Action if exceeded: storage-expansion-vm101.md / ram-risk-acceptance.

### 3. Backups
- Freshness PASS required (snapshots local+S3, DR bundle, config, IRIS, MISP).
- Verify dr-s3 403 status (P10.02 accepted local-only - monitor for fix).

### 4. Endpoint counts
- endpoint-count-report.sh -> billing categories (per client).
- Verify vs level.io device groups.

### 5. Alert quality
- Review alert volume by level/rule; identify noise + tuning candidates.
- Promote tuned detections from pilot to client groups.

### 6. Vulnerability
- Export latest Greenbone report per client (authorized).
- Track critical/high remediation.

### 7. Scorecard
- Populate phase10-first-client-scorecard-start.md template per client.
- Client-safe QA (phase9-client-reporting-qa.md).

### 8. Billing
- monthly-billing-review-template.md: endpoint counts x rates.

### 9. Communication
- Send client updates per templates (P10.14).

### 10. Retrospective
- What worked / broke; update runbooks + change control.

## Cadence summary

- Weekly: healthcheck, capacity, backup freshness (scripts exist).
- Monthly: full cycle above.
- Quarterly: SLA review (quarterly-security-review.md).

## No secrets

No secret values printed.
