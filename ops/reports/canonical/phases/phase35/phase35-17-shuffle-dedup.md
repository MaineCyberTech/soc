# Phase 35: Shuffle Native Dedup

Date: 2026-08-25

## Status: BLOCKED — requires Shuffle workflow creation via UI

## Design (for Phase 36 execution)
- **Key**: rule.id + source.agent.id + dest + truncated-hour (SHA256)
- **Lookup**: Shuffle datastore GET by dedup key
- **Write**: Shuffle datastore SET with 24h TTL
- **Duplicate branch**: If key exists → increment dup counter, do NOT route
- **Metrics**: total_routes, total_duplicates, dup_rate
- **Test isolation**: All canary keys prefixed `MCT_P35_`
- **Fail-safe**: If datastore unreachable → suppress routing, notify operator

## Current state
- No dedup workflow exists
- No datastore entries for MCT_DEDUP
- Datastore CRUD confirmed healthy via health check

## Recommendation
Implement in Phase 36 after Shuffle workflow creation. Design above is ready for execution.

## No secrets
