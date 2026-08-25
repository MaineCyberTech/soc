# Phase 32 Shuffle Malformed Event Handling

Date: 2026-08-24
Status: **SPEC READY - UI IMPLEMENTATION PENDING** (C6).

## Design

- Schema validation branch on the incoming webhook payload:
  - Required: rule.id, agent.id, timestamp, event data fields.
  - Malformed/incomplete -> reject branch (no IRIS), increment `malformed_count` metric,
    log sample id; never route to IRIS.
- Well-formed -> dedup/counter -> IRIS path (16/17).

## Why UI

- Condition/validation nodes require the editor.

## Validation (after UI)

- Post deliberately malformed payload -> assert 0 IRIS cases + malformed metric increment.

## No secrets