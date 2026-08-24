# Phase 28 Windows Endpoint Final Certification

Date: 2026-08-24
Status: **PARTIAL** (per-endpoint blockers).

| Agent | Config | Telemetry | Throttle | Buffer | Freshness | Owner | Exceptions | Cert |
|---|---|---|---|---|---|---|---|---|
| 013 | policy BCA0EB (4.91) effective | EID1 62/24h, EID7 39/24h | RETAIN | 0 | interrupted (offline ~17:28Z) | MCT | marker dump + continuity | **PARTIAL** |
| 014 | policy BCA0EB (4.91) effective | EID1 99/24h, EID7 0/24h | RETAIN | 0 | continuous | MCT | marker dump | **PARTIAL** |
| 015 | macOS bounded (P27) | 108 alerts/24h | - | 0 | interrupted (offline ~17:48Z) | MCT | none | **CERTIFIED** |

## Blockers to PASS

1. 013: marker (03) + 24h continuity once online.
2. 014: marker (05).

## No secrets