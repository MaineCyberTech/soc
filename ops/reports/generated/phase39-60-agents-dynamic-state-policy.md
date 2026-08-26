# Phase 39 AGENTS Dynamic-State Policy — Forbidden Volatile Items and Pointer Discipline

**Report ID:** phase39-60-agents-dynamic-state-policy
**Phase:** 39
**Title:** Dynamic-State Policy: Enumerated Forbidden Volatile Classes, Replacement Pointer Lines, Refresh Cadence Ownership
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:12:59Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-60-agents-dynamic-state-policy.md`

---

## 1. Candidate Volatile Items Considered

| Class | Examples seen in corpus | Rationale for exclusion |
|---|---|---|
| Disk / memory / swap % | "disk ~84%", "mem 75%" | ages within hours; phase38-49 already flags point-in-time |
| Agent fleet states | "013 offline, 015 flapping" | changes without repo commits |
| Error rates | "~150/min field errors" | continuous quantity |
| Execution / index counts | "796 executions", "274 shards", "22 alert indices" | grow continuously |
| Token/key values | any bearer, API key, password | secret class (banned independently) |
| IP addresses / ports bound | frontend bind address | reconfigurable; exposure docs own them |
| `/tmp` usage, snapshot sizes, dates-of-next-event | "21%", "~7.5GB", "deletion ~08-29" | operational churn |

## 2. Rule

**FORBIDDEN in AGENTS.md:** any of the classes above. Enforced mechanically by
`ops/scripts/p39-agents-ci.sh` volatile-metric regexes (percentages near resource words,
raw bearer-like strings) — created this arc (phase39-66).

**REQUIRED instead:** pointer lines of the form:

> Current operational truth: see the latest authoritative current-state final under
> `ops/reports/generated/` (currently `phase38-49-generate-current-state.md`; superseded
> by any newer `phaseNN-*-current-state`/final per its supersession statement).

Known blockers likewise appear as pointers to their owning reports, never as live values.

## 3. Refresh Cadence Responsibility

- Each phase's **final report** becomes the pointed-to canonical doc.
- The next AGENTS.md edit (or the next phase's reconciliation step) updates ONLY the pointer
  target if superseded — never re-bakes values into the file.
- Owner: MCT SOC (automation: opencode/ox-alpha executes the check each phase).

## Verdict

Dynamic-state policy defined: forbidden classes enumerated, pointer replacement pattern fixed,
cadence ownership assigned. Ready to encode in proposed diff + CI gate.
