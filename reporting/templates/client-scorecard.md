# Client Security Scorecard

Prepared for: <client name>
Reporting period: <YYYY-MM-DD> to <YYYY-MM-DD>
Prepared by: MCT Security Operations
Classification: CLIENT CONFIDENTIAL — do not redistribute.

## Executive summary

- Endpoints under management: <n> (active <n>)
- Alerts this period: <n> (Class A <n>, Class B <n>)
- Confirmed incidents: <n> (0 ideal)
- Critical/high vulnerabilities open: <n> (internet-facing <n>)
- SCA compliance: <p>% of passed checks
- Overall posture: <Good / Fair / Needs attention> — <1-2 sentence summary>

## Endpoint coverage

| Metric | Value |
|---|---|
| Managed agents | <n> |
| Active (last 24h) | <n> |
| Offline > 7 days | <n> |
| Sysmon enabled (Windows) | <n>/<n> |
| Velociraptor enrolled | <n>/<n> |

## Agent health

- <n> agents healthy, <n> offline, <n> out of date (list worst offenders)

## Top alerts

| Rule | Count | Actionable? |
|---|---|---|
| <rule id> <description> | <n> | <yes/no> |

## Confirmed incidents

| Date | Type | Summary | Resolution |
|---|---|---|---|
| <date> | <type> | <summary> | <resolution> |

## Network anomalies

- Unusual ports: <n> (top: <port> x<n>)
- Unknown flow exporters: <n>
- High outbound transfer hosts: <list>

## Flow summary

- Total flows (30d): <n> (~<n>/day)
- Top destinations: <list>
- Top services: <list>

## Vulnerability summary

- Critical: <n> (internet-facing <n>)
- High: <n>
- Top CVEs: <list with affected assets>
- Patched this period: <n>

## Critical/high vulnerabilities

| Asset | CVSS | CVE | Exposure | Plan |
|---|---|---|---|---|
| <REDACTED_HOST> | 9.8 | CVE-2026-0000 | Internet-facing | Patch <date> |

## SCA/compliance status

- Passed checks: <p>% (<n>/<n>)
- Key failing controls: <list>

## Open/closed action items

| # | Action item | Owner | Status |
|---|---|---|---|
| 1 | <item> | <name> | Open/Closed |

## Recommendations

1. <recommendation>
2. <recommendation>

## Work completed

- <work item>

## Next priorities

1. <priority>
2. <priority>

## Report meta

- Query sources: `reporting/queries/*.json`; generation script `ops/scripts/generate-scorecard.example.py`
- Generated: <timestamp>
