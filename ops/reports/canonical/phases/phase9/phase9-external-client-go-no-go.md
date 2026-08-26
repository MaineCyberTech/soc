# Phase 9 External Client Go/No-Go

Date: 2026-08-15

## Review dimensions (Phase 9 evidence)

| Dimension | Status | Evidence |
|---|---|---|
| Capacity | **CONDITIONAL** | disk 63% OK; swap 5.9G/8G (RAM expansion recommended); thin pool 88% (lab) |
| Backup weekly proof | PASS | daily jobs PASS; weekly cron verified; config backup FIXED; dr-s3 bundle 403 (open) |
| Greenbone schedule/report | PASS | recurring schedule created + validated; report pipeline works |
| Endpoint readiness | PASS | Linux pilots validated; Windows pilot (012) Active + Sysmon + Velociraptor |
| Canarytoken status | PENDING | hosted account required (not a launch blocker for Linux-only) |
| Credential rotation | PARTIAL | no new values; DO keys stale for CLI (snapshots still S3-backed via keystore) |
| Alert path | PASS | canary -> rule -> Shuffle -> IRIS re-validated (lvl 12) |

## Recommendation: **CONDITIONAL GO (Linux-only pilot)**

Conditions mapped to client impact:

| # | Condition | Client impact | Owner |
|---|---|---|---|
| 1 | Signed authorization bundle (scans + monitoring) | Required before any scan/agent | Client + MCT |
| 2 | RAM expansion to 16G on MCT host | Avoids degraded monitoring during onboarding | Operator |
| 3 | DR S3 bundle keys fixed OR accepted local-only | Config DR stays local-only for pilot term | Operator |
| 4 | Linux endpoints only (no Windows) | Windows pilots remain internal until tuning done | MCT |
| 5 | Canary/deception deferred until T1 validated | No deception add-on at launch | MCT |

## Explicit non-go items

- NO Windows endpoint monitoring for clients yet.
- NO automated blocking/quarantine.
- NO invasive scans without separate written approval.
- NO broad agent deployment beyond approved scope.

## Next steps

1. Operator: RAM expansion + DO Spaces key fix (or accept conditions).
2. Sign authorization bundle with first client.
3. Execute fulfillment runbook (P9.11).

## No secrets

No secret values printed.
