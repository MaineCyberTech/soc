# Monthly Client Security Scorecard

Prepared for: {{ client_name }}
Reporting period: {{ period }}
Prepared by: MCT Security Operations
Classification: CLIENT CONFIDENTIAL — do not redistribute.

## Executive summary

- Endpoints under management: {{ agents_total }} (active {{ agents_online }})
- Alerts this period: {{ alerts_total }} (Class A {{ alerts_critical }}, Class B {{ alerts_high }})
- Confirmed incidents: 0 ideal target
- Critical/high vulnerabilities open: {{ critical_vulns }}
- Deception hits: {{ canary_hits }}
- MISP IOC matches: {{ misp_matches }}
- Backup/DR health: {{ backup_ok }}
- Overall posture: <Good / Fair / Needs attention> — <1-2 sentence summary>

## Endpoint coverage

| Metric | Value |
|---|---|
| Managed agents | {{ agents_total }} |
| Active (last 24h) | {{ agents_online }} |
| Offline > 7 days | <n> |
| Sysmon enabled (Windows) | <n>/<n> |
| Velociraptor enrolled | <n>/<n> |

## Top alerts

| Rule | Count | Actionable? |
|---|---|---|
| <rule id> <description> | <n> | <yes/no> |

## Incidents / cases

| Date | Type | Summary | Resolution |
|---|---|---|---|
| <n> | <n> | <n> | <n> |

## Vulnerability status

- Critical/high open: {{ critical_vulns }}
- Top CVEs: <list>

## Next period focus

1. <item>
2. <item>
