# Phase 24 Health Script Exit-Code Hardening

Date: 2026-08-22
Status: **COMPLETE + TESTED**

## Changes

1. `ops/scripts/full-stack-healthcheck.sh`: counts `**FAIL**` rows; **exits 1** when any
   component FAILs (was exit 0 always). Healthy run exits 0 (verified live: 0 FAIL -> 0).
2. `ops/scripts/alert-volume-by-rule.sh`: sets QUERY_FAILED when the indexer query returns
   nothing; **exits 1** with a clear message (was exit 0 with a silent error row). Healthy
   run exits 0 (verified live).

## Tests

- Syntax (bash -n): PASS both.
- Live healthy path: healthcheck exit 0 (0 FAIL), alert-volume exit 0.
- Failure paths: logic-reviewed (FAIL count > 0 -> 1; empty response -> 1).

## Automation impact

- Cron/CI can now detect degraded health/query state via exit code (closes the P22 LOW
  "silent-success" backlog item).

## No secrets