# Phase 53: AGENTS Certificate

**Prompt:** 040-agents-cert
**Generated (UTC):** 2026-08-27T20:07:40Z
**Operator (EDT):** 2026-08-27T16:07:40-0400
**Verdict:** DONE

## Summary
Verify the root AGENTS.md is a durable governing file (rules and pointers only, no volatile
state/metrics) per the Phase 53 overlay. The file was read in full (187 lines). It contains
only directives, repository map, gates, safety rules, approval-gated operations, known blockers
(pointers only), credential-handling notes, and report authoring conventions. No operational
metrics, counters, timestamps-of-state, or runtime values are embedded. This satisfies the
overlay requirement that AGENTS stay durable.

## Evidence
- E1: read /opt/mct-security-stack/AGENTS.md — 187 lines; content is directives/pointers only, no volatile state/metrics.
- E2: sha256(AGENTS.md) = 383a3e67ad2150868f42d72cf954d9b141b3d2c51a0444fc71a472ccc75aca2c.
- E3: backups present in ops/backups/agents/ (e.g. AGENTS-20260827-193045Z.md + .sha256) confirming the edit-before-change durability control is honored.

## Backup / Rollback
N/A (read-only verification). Durability control (timestamped sha256 backup before edit) already in place per AGENTS.md line 69.

## Stop conditions (BLOCKED only)
None.

## Limitations
Did not re-run p39-agents-ci.sh (CI gate belongs to edit workflow, not this read-only cert).

## Verdict rationale
AGENTS.md is confirmed durable: rules/pointers only, no embedded volatile state; backing
snapshots exist. Verdict DONE.
