# Phase 32 Shuffle Dedup Implementation

Date: 2026-08-24
Status: **SPEC READY - UI IMPLEMENTATION PENDING** (C6; API cannot add datastore/condition nodes).

## Design

- Deterministic dedup key: `rule.id|agent.id|data.dst|data.src|hour` (1h TTL).
- Datastore (Shuffle cache): GET key -> exists -> DROP (no IRIS); else SET with TTL 1h.
- Duplicate branch: increment metric (dedup_count), terminate.
- Metrics: per-workflow dedup counter logged to a datastore key or workflow log.

## Why UI

- Shuffle API PUT strips branch conditions and cannot create datastore nodes (verified P27).
- Implementation = Shuffle workflow editor (add datastore + branch + TTL), then export.

## Replay/validation (after UI)

- Post identical marked synthetic event twice -> expect 1 IRIS case + 1 dedup metric.

## Guardrail

- Cron limit/kill switch remains the independent fail-safe regardless of UI state.

## No secrets