# Phase 53: AGENTS Rewrite Plan

**Prompt:** 033-agents-rewrite-plan
**Generated (UTC):** 2026-08-27T20:08Z
**Operator (EDT):** 2026-08-27T16:08-0400
**Verdict:** DONE

## Summary
Plan the minimal approved changes to AGENTS.md and the rollback, without applying them.

## Evidence
- E1: Current AGENTS.md sha256 383a3e67…, 187 lines, CI PASS (baseline from 024).
- E2: Phase 53 overlay durable rule — keep rules/pointers only.
- E3: Audit findings this batch — volatile Known Blockers narrative (026/032); everything else durable and clean (027-031).

## Proposed minimal changes (plan only, NOT applied)
1. In Known Blockers (lines 84-123): convert time-bound open-status bullets into canonical pointers (e.g. "Owner session: see open-work.md OW-…"; "Restore rehearsal: NO-GO per open-work.md"; "Dashboard v2: PENDING per open-work.md") — removing inline dated state.
2. No change to MUST/MUST NOT, secret policy, or transport rules (verified intact in 027/028).
3. No new nested AGENTS file (precedence preserved, 025).

## Rollback
Before any apply: `cp AGENTS.md ops/backups/agents/AGENTS.md.<UTC>.bak` and record sha256; revert with that copy. Git history also available.

## Backup / Rollback
Plan only; no mutation. Backup target = `ops/backups/agents/`.

## Stop conditions (BLOCKED only)
Plan is complete; execution is gated on owner approval (handled by 034).

## Limitations
Plan is conservative and preserves all safety rules; it does not weaken any MUST/MUST NOT (to be diff-checked in 035).

## Verdict rationale
Planning is read-only and fully supported by evidence; verdict DONE (PLAN-ONLY). Apply remains BLOCKED in 034.
