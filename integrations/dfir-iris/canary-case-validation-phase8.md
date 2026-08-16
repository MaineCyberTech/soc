# Canary Case Validation (Phase 8)

## IRIS flow

Wazuh 121012 -> Shuffle (wazuh-high-severity trigger) -> IRIS alert
-> promote to case (opencanary-hit template, Class A)

## Manual fallback

1. Create IRIS case (opencanary-hit template).
2. Paste raw canary payload into description.
3. Tags: source:opencanary, class:A.

## Status

Local canary path validated; mct-canary01 VM pending build.
