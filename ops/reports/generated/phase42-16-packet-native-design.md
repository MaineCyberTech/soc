# Phase 42 Packet Native Design — Attempts Catalog & Architecture Options

**Report ID:** phase42-16-packet-native-design
**Phase:** 42
**Title:** NATDES-42-01 — COMPLETE: Three API-Side Design Attempts Cataloged (Linear-Chain Topology Fix / Old-vs-New Ref Syntax / Full-Metadata Clone) With Honest Outcomes; Final Architecture Options A/B/C Stated With Tradeoffs; Ranking B > A > C
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T08:15:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (design record; implementation BLOCKED — see phase42-18)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-16-packet-native-design.md`

---

## 1. Design attempts catalog

### D1 — Linear-chain topology fix [VERIFIED outcome]

API-created parallel fan-out branches (trigger → children) were silently
SKIPPED at runtime with "not under startnode(1)". Fix found and applied:
children execute only under a **linear chain of explicit branch objects**, the
workflow `start` field must point at the first ACTION, and `hook.start` points
at the TRIGGER. Verified live this session on e133a645: `start` =
0b969499… → action `parse-eve-json`; trigger `suricata-eve-in`
(736b7410…) carries `isStartNode=true`. Outcome: **definition/topology class
of failures SOLVED** — topology was never the gating blocker.

### D2 — Old-vs-new reference syntax test [VERIFIED outcome]

New `$param` form vs legacy `${body:*}` form exercised against Tools nodes and
the HTTP app. Legacy syntax resolves in HTTP only (T5 control positive,
Class-A HTTP 200 twice); Tools consumes neither form — both arrive literal or
ignored (T2/T4). Outcome: **syntax is not the variable; the executor is.**
No string-formulation can make a non-consuming function consume.

### D3 — Full-metadata clone test [VERIFIED outcome]

Complete parameter objects — including `action_field`, `value_replace`, and
`schema` subfields — cloned from a WORKING Class-A HTTP action into
Tools `repeat_back_to_me`. Result: input still ignored entirely; node echoes
the function name (T4, exec 21efb5c0). Outcome: kills the "API-created nodes
lack UI-only metadata" hypothesis **for this function**; directly lowers
confidence in remediation path A below.

## 2. Final architecture options

| Option | Act | Tradeoffs |
|---|---|---|
| **A — Owner UI-session rebuild test** | Owner rebuilds gate chain in UI; UI-generated nodes may carry metadata the API path cannot replicate | No platform change; cheap to try; LOW confidence after T4's full-metadata failure — but not zero, because T4 proves one function, not every UI-authored binding |
| **B — Shuffle platform upgrade restoring Tools interpolation** | Upgrade backend/app framework so Tools consumes references | Fixes root cause for all lanes at once; requires upgrade-window approval + full regression re-run of this proof arc (P41/P42 evidence becomes historical) |
| **C — External orchestrator pattern** | Wazuh-side filtering before forwarding: pre-filter integration rule_ids/groups so allowlist/dedup happen before Shuffle sees traffic | Sidesteps Shuffle gates entirely; allowlist achievable manager-side today; dedup requires a custom manager-side integration script (state); moves enforcement out of SOAR into pipeline config |

## 3. Ranking rationale (decision finalized in phase42-32)

B > A > C. B is the only option that restores the designed architecture as
built; A is a bounded experiment that either unblocks natively or produces
definitive evidence for B; C changes the trust boundary and re-implements
SOAR semantics in the pipeline — treated as last resort, viable for
allowlist immediately if owner accepts the pattern.
