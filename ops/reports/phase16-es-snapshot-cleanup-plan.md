# Phase 16 ES Snapshot Cleanup Plan

Date: 2026-08-16

## Status: PLAN READY - approval-gated (no deletion yet)

## Preconditions (verified)

- S3 DR posture HEALTHY: 37 snapshots, all SUCCESS, newest s3-snap-20260816-0547.
- Local repo: 43 snapshots / 13G.

## Policy

- Target local retention: **keep 14** (per es-snapshot-retention-policy.md).
- Delete candidates: 29 oldest local snapshots (08-09 06:18 -> 08-14 00:17).
- Keep: snap-20260814-0330 through snap-20260816-0517 (14 newest).

## Estimated reclaim

- ~29 snapshots / ~8-9G (based on 13G total).

## Deletion candidates

- ops/reports/phase16-es-snapshot-dry-run-delete-list.md (full list).

## Approval gate

- Deletion ONLY with marker: operator-approved-es-snapshot-cleanup=true
  OR documented approval in ops/reports/phase16-es-snapshot-cleanup-approval.md.
- Always: re-verify S3 health immediately before deletion.

## No secrets

No secret values printed.
