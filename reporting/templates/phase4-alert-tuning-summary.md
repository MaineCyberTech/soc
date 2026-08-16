# Phase 4 Alert Tuning Summary

Period: {{ period }}
Baseline before: {{ before_total }} alerts/24h
Baseline after: {{ after_total }} alerts/24h (expected after steady state)

## Changes

| rule | change | before/24h | after/24h | status |
|---|---|---|---|---|
| 24010 osquery inventory | level 0 archive-only | {{ before_24010 }} | {{ after_24010 }} | {{ status_24010 }} |
| {{ rule }} | {{ change }} | {{ before }} | {{ after }} | {{ status }} |

## Class A integrity

- OpenCanary 1210xx: {{ class_a_opencanary }}
- MISP IOC 1211xx: {{ class_a_misp }}
- Unknown exporter / lateral movement: {{ class_a_flow }}

## Notes

- {{ notes }}
