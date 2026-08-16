# Phase 11 Client Greenbone Scan Plan

Date: 2026-08-16

## Authorization gate (mandatory)

- NO client scan without signed authorization (greenbone-client-scan-authorization.md).
- First scan = Discovery (non-invasive, read-only).
- Deeper configs only after separate written approval.

## Client scan plan (when authorized)

| Step | Action | Tool |
|---|---|---|
| 1 | Client signs authorization (scope, cadence, off-peak) | bundle |
| 2 | Create target group (client IPs/domains) | GMP create_target |
| 3 | Create task (Discovery config, OpenVAS scanner) | GMP create_task |
| 4 | Attach weekly schedule (off-peak, mirror lab pattern) | GMP create_schedule |
| 5 | Attach MCT-Critical-to-Shuffle alert (severity >= 9.0) | GMP modify_task |
| 6 | Manual first run + verify Done | GMP start_task |
| 7 | Export report -> client-safe review | get_reports |
| 8 | Remediation tracking + re-scan | review template |

## Cadence

- External: weekly (off-peak window).
- Internal: monthly (per agreement).
- Re-scan after remediation to verify.

## Report

- reporting/templates/client-vulnerability-review.md (client-safe).
- Critical findings route: Greenbone -> Shuffle -> IRIS (D5).

## No secrets

No secret values printed.
