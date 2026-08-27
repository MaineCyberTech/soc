# Phase 56: AGENTS Pointer

**Prompt:** 075-classa-agents
**Generated (UTC):** 2026-08-28T00:35:00Z
**Operator (EDT):** 2026-08-27 20:35:00 -0400
**Verdict:** ACCEPT

## Summary
Prompt: durable pointer only. AGENTS.md already carries durable, non-weakening pointers for the Class-A / Wazuh→IRIS situation and the no-GET-webhook rule. No edit to AGENTS.md is required or performed (overlay forbids weakening root AGENTS.md).

## Evidence
- EV-13 / AGENTS.md (VERIFIED): root AGENTS.md documents the service-scoped `iris-shuffle-env` secret, the ROUTED resolution, and the Wazuh→Shuffle wiring (webhook_eb937a37) plus the stopped-test-webhook note.
- EV-11 (VERIFIED): repo scripts comply with no-GET-webhook (POST only). [grep]
- Overlay (VERIFIED): AGENTS-PHASE56-OVERLAY.md cannot weaken root AGENTS.md — only refines.

## Backup / Rollback
Read-only. No mutation to AGENTS.md. Per AGENTS.md, any future edit requires a timestamped backup + sha256 into ops/backups/agents/ BEFORE editing (not needed here).

## Stop conditions
Editing AGENTS.md is a governed action (p39-agents-ci.sh must pass) — not required for this pointer prompt.

## Limitations
Pointer is documentation-only; the underlying Class-A defect (062/063/064) remains open.

## Verdict rationale
Durable pointer already present and non-weakening; no action needed. ACCEPT.
