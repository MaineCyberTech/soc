# Phase 22 Suricata Routing Readiness

Date: 2026-08-22
Status: **NOT READY - GATED** (quiet network; no severity 1-2 events to validate).

## Gating requirements (unchanged)

1. Sustained eve.json ingest (currently 1 event).
2. 7-day volume + severity distribution measured.
3. Severity map rules (122010-122012) deployed + logtest validated.
4. Operator approval.

## Staged plan

- sev 1 -> level 10 (122012) -> IRIS Critical
- sev 2 -> level 8 (122011) -> IRIS High
- sev 3-4 -> monitor/archive

## Current

- No events to map; no routing; no invasive traffic generated. Revisit when events flow.

## No secrets