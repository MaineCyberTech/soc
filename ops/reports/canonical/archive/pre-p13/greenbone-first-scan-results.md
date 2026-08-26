# Greenbone First Scan Results

Date: 2026-08-11
Status: **PENDING - schedule creation requires operator (GMP CLI not on VM103)**

## Plan (finalized)

- Group: core-infrastructure (192.168.222.149, .116, .187)
- Profile: safe discovery (non-invasive)
- Schedule: MCT-core-infra-monthly, 1st week, 02:00-04:00 UTC
- Critical alert: severity >= 9.0 -> Shuffle webhook (D5)

## Prereq

- GSA UI or gvm-cli on VM103 (admin credential present in .env).
- See greenbone-vm103-admin-validation.md for exact steps.

## After first scan

1. Export report (first-scan-export.md) -> reporting/output/greenbone-first-scan-<date>.
2. Fill phase5-vulnerability-review.md with findings.
3. Confirm OpenCanary ports marked FP (canary, not real).
4. Route critical findings per D5.

## No scans launched this phase

- Read-only validation only (no authorization for invasive scans).
