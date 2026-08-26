# Phase 39 AGENTS Gap Audit — Everything Is the Gap; Consolidation and Duplication Risks

**Report ID:** phase39-57-agents-gap-audit
**Phase:** 39
**Title:** Gap Audit vs Ideal Agent-File Content: Zero Baseline, Required Section Set, Corpus→AGENTS Consolidation Gaps, Ambiguity and Duplicate Risks
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:12:59Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-57-agents-gap-audit.md`

---

## 1. Primary Gap

No AGENTS.md exists (phase39-53) → **every ideal section is a gap.** Required section set
enumerated below; each maps to a planned section in the proposed diff (phase39-61):

| # | Required section | Why an agent needs it | Filled by |
|---|---|---|---|
| G1 | Purpose & Scope | know what this file governs | §Purpose |
| G2 | Repository Map | navigate without re-discovery | §Repo Map |
| G3 | Canonical Truth & Navigation | avoid acting on stale claims | §Truth |
| G4 | Required Gates Before Commit | keep CI green, secrets out | §Gates |
| G5 | Operational Safety Rules | MUST/MUST NOT floors from packs | §Safety |
| G6 | Approval-Gated Operations | know when to stop and ask | §Approval |
| G7 | Known Blockers (pointer-style) | avoid re-triaging known issues | §Blockers |
| G8 | Credential Handling | paths-only secret discipline | §Creds |
| G9 | Report Authoring Conventions | corpus stays consistent | §Reports |
| G10 | Out of Scope (PVE/RAM) | hard boundary from packs | §Scope |
| G11 | Escalation & Owners | routing of decisions | §Owners |

## 2. Corpus→AGENTS Direction Gaps

The corpus holds ~100 phase reports (98 generated in P38 + P39 series to date) with facts
scattered across claim ledgers, verification reports, and per-phase summaries:

- No single file previously told an agent where truth lives → navigation gap (filled by G3).
- Durable vs volatile facts were never formally separated until phase39-56/60.
- Standing safety rules existed only across four pack READMEs, not in-repo → agents working
  purely inside the repo could not see them at all.

## 3. Ambiguity Risks Identified

| Risk | Detail | Mitigation |
|---|---|---|
| Multiple current-state candidates | `phase38-49-generate-current-state.md` vs future phase39 final vs older "status-live" docs | AGENTS.md names ONE canonical pointer pattern: latest final wins; supersession statements govern |
| Status vocabulary drift | free-text statuses crept in historically | point to p38 enum set via report conventions section |
| Root-vs-nested precedence | future nested files may appear | precedence model fixed in phase39-53 §4 |

## 4. Duplicate-Risk Warnings

AGENTS.md must NOT duplicate runbooks or current-state content:

- Do not copy retention/ISM runbooks — point to `ops/scripts/es-snapshot-retention-*` and
  canonical docs.
- Do not restate metrics or blocker details — one pointer line each.
- Do not inline workflow JSONs or endpoint payloads — point to evidence dirs.
- Rule of thumb encoded in-file: *pointers for state; directives only for behavior.*

## Verdict

Gap audit COMPLETE. All gaps addressed by the proposed section set without duplication.
