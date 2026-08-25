# Phase 34 Canary Deduplication and Counter Proof

Date: 2026-08-25

## Design
- Dedup key: SHA256(sid+src+dst+ts) - identical alerts within TTL suppressed
- TTL: 1 hour (duplicate within window = 1 route)
- Daily counter: max 5 canary executions, isolated from production
- Test isolation: canary counter separate from operator alerts

## Evidence (design)
- replay identical marked alerts -> 1 route, N-1 suppressions
- No real-counter contamination (canary counter separate)
- Guardrail provides external fail-safe (5/24h)

## Implementation status
- Dedup: guardrail operational (external); native dedup UI-gated
- Counter: canary daily limit designed; implementation deferred (Shuffle UI)

## No secrets
