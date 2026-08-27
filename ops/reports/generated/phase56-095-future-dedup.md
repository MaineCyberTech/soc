# Phase 56: Synthetic Dedup Namespace

**Prompt:** 095-future-dedup
**Report ID:** phase56-095
**Phase:** 56
**Generated (UTC):** 2026-08-28T00:30:00Z
**Operator (EDT):** 2026-08-27T20:30:00-0400
**Classification:** INTERNAL
**Verdict:** PARTIAL
**Source Path:** /home/user/mct-p56/prompts/095-future-dedup.md

## Summary
Assessed the synthetic dedup namespace. The production dedup key omits `proto` and `agent`, causing
distinct-protocol/agent events to be falsely collapsed (Phase 55 defect). No separate synthetic dedup
namespace exists.

## Evidence
- **EV-WF-DEDUP-001** (VERIFIED): `dedup_key = "p53_dedup_%s_%s_%s_%s" % (sid, src, dst, port)` —
  omits `proto` and `agent`; category `p53_dedup`. Confirmed defect.
- **EV-WF-SYNTH-001** (VERIFIED): synthetic returns before dedup; but a forced synthetic fault-replay
  would still use the defective key. Synthetic namespace absent.

## Dedup contract (definition only)
- Key MUST include protocol + governed observer/agent identity: `p53_dedup:<sid>:<src>:<dst>:<port>:
  <proto>:<agent>` (production) and `p53_dedup:mct_synthetic:<...>` for synthetic replays, with an
  explicit observer-identity policy documented.
- Fix mapped to workflow edit 122 (dedup-fix) — owner-gated.

## Backup / Rollback
Read-only. Dedup fix is a Shuffle workflow code edit (run-context §4: workflow code edits STOP).

## Stop conditions
Implementing proto+agent key + synthetic namespace is a workflow code edit (122) → BLOCKED/DEFERRED.

## Limitations
Fix not applied (gate). Dedup cache not independently enumerated (OpenSearch unreachable, EV-OS-001).

## Verdict rationale
Defect VERIFIED (proto/agent omitted); namespace contract defined; remediation gated → PARTIAL.
