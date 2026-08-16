# Monthly MSP Ops Checklist

Month: [MM YYYY] | Date: [date]

## Health
- [ ] full-stack-healthcheck.sh = 0 FAIL
- [ ] capacity-threshold-check.sh = no CRIT
- [ ] Any FAIL/WARN investigated + logged

## Backups
- [ ] backup-freshness-check.sh = PASS (all streams)
- [ ] dr-s3 bundle status noted (403 accepted/local-only unless fixed)
- [ ] Snapshot restore spot-check (metadata read)

## Endpoints
- [ ] endpoint-count-report.sh run
- [ ] Counts match level.io device groups
- [ ] All client agents Active

## Alerts
- [ ] Alert quality report generated
- [ ] Top noise rules identified
- [ ] Tuning candidates promoted (pilot -> client)

## Vulnerabilities
- [ ] Greenbone reports exported (authorized clients)
- [ ] Critical/high tracked with owners
- [ ] Remediation verification scheduled

## Client deliverables
- [ ] Scorecard populated (client-safe)
- [ ] Vulnerability section included
- [ ] Billing review complete
- [ ] Client communications sent (templates)

## Internal
- [ ] Retrospective notes + action items
- [ ] Runbooks updated
- [ ] Change control updated

## Sign-off
- Prepared: ______________  Approved: ______________

## No secrets

No secret values printed.
