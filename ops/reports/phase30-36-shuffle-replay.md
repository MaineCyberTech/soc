# Phase 30 Shuffle Replay Proof

Date: 2026-08-24
Status: **METHOD READY - UI IMPLEMENTATION REQUIRED FIRST** (dedup/counter in 16/17).

## Goal

- Prove single routing + duplicate suppression: same marked synthetic event twice -> 1 IRIS
  case, 1 dedup metric.

## Why not run now

- Dedup/counter nodes do not exist yet (16/17 pending UI approval). Without them, replay
  creates duplicate routes (the very issue being fixed).
- Synthetic webhook posts were also shown unreliable at creating executions (P27 periodic
  loop artifact) - must use the UI debug/execution path once nodes exist.

## Procedure (post-UI)

1. Generate synthetic Class A payload with unique marker.
2. Post twice via webhook.
3. Assert: 1 IRIS case; dedup_count=1; no duplicate.
4. Record evidence.

## No secrets