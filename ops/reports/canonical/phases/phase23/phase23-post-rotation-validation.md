# Phase 23 Post-Rotation Stack Validation

Date: 2026-08-22
Status: **BASELINE CAPTURED - ROTATIONS PENDING** (indexer rotation approval-gated; VT key blocked).

## Baseline (pre-rotation, all healthy)

| Check | Baseline |
|---|---|
| Healthcheck | 0 FAIL (20260822-045817) |
| Indexer auth + cluster | green (admin basic auth OK) |
| ElastiFlow/flow-relay output | fresh (8.32M flow docs) |
| Dashboard/API | OK (WUI auth working) |
| CI | PASS |

## Post-rotation validation procedure (when rotations execute)

1. Full healthcheck -> 0 FAIL.
2. Indexer auth (admin) + cluster green.
3. Dashboard login + API token (WUI).
4. Index write/search probe (wazuh-alerts-*/_search).
5. ElastiFlow + flow-relay output freshness.
6. VT integration probe (on demand hash) - no value output.
7. Backup freshness; CI; secret scan.

## Verdict

- Baseline captured; no regressions to date. Re-run this checklist after any rotation.

## No secrets