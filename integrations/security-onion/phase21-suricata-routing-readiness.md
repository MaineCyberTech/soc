# Phase 21 Suricata Routing Readiness

Date: 2026-08-19
Status: **NOT READY - GATED** (no sustained Suricata events; severity 1-2 rules staged).

## Requirements to route Suricata

1. Sustained eve.json ingest (currently 1 event - quiet).
2. 7-day volume + severity distribution measured.
3. Severity map rules (122010-122012) deployed + logtest validated.
4. Operator approval.

## Proposed (staged)

- sev 1 -> level 10 (122012) -> IRIS Critical
- sev 2 -> level 8 (122011) -> IRIS High
- sev 3-4 -> monitor/archive only

## Current

- None of the above met; no IRIS routing. Revisit when events flow.

## No secrets