# Phase 18 NetFlow ILM/Retention Plan

Date: 2026-08-17

## Status: PLAN (approval-gated apply)

## Current

- Single rollover index: 1.4GB / 4.9M docs (growing ~700k/day).
- No ILM policy.

## Plan

1. ILM policy: hot 3d (rollover 2GB), warm 14d, delete 30d.
2. Storage estimate: ~2-3GB/month (acceptable).
3. Apply via OpenSearch ISM (index state management) - approval-gated.

## No secrets
