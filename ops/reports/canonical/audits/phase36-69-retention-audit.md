# Phase 36: Retention Audit

Date: 2026-08-25

## ISM policies
| Policy | Age | Status |
|---|---|---|
| wazuh-archives-14d | 14d | ATTACHED (all archive indices) |
| wazuh-retention | 30d | ATTACHED (all alert indices) |
| elastiflow | 14d | ATTACHED (elastiflow index) |
| wazuh-states-retention | - | ATTACHED (state indices) |

## Policy attachment
- Archives: ALL 11 indices have wazuh-archives-14d
- Alerts: ALL indices have wazuh-retention
- ElastiFlow: rollover failed (naming issue)

## First deletion expected
- Archives: 2026-08-29 (08-15 reaches 14d)
- Alerts: 2026-09-07 (08-07 reaches 30d)

## Assessment: POLICIES ATTACHED, WAVE PENDING
## No secrets
