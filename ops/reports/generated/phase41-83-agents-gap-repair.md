# Phase 41 AGENTS Gap Repair

**Report ID:** phase41-83-agents-gap-repair
**Phase:** 41
**Title:** REPAIR-CHG-41-AGENTS-01 — Minimal Diff APPLIED to Root AGENTS.md With Full Compliance Chain (Backup+SHA Before → Python Assert-Guarded Apply → Post-Validate Greps → p39-agents-ci.sh PASS 0 Warnings → Ledger Entry With Before/After SHA256s)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T06:42:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-83-agents-gap-repair.md`

---

## 1. Compliance chain (executed in order)

| Step | Action | Result |
|---|---|---|
| 1 | Backup BEFORE edit: `cp AGENTS.md ops/backups/agents/AGENTS.md.bak-20260826-063721` + sha256 banked alongside | sha256 `b91b5e2f8cbeb75061794681b25077d4478d4465d1765330438d6dbf55491a00` |
| 2 | Dry-run diff plan published in phase41-82 §3–§4 (findings A1–A6, three justified scripting-note bullets) | Scoped: 5 pointer/content edits + 3 bullets |
| 3 | Applied via python with per-edit `assert` guards — any no-op replacement would have aborted the run; volatile metrics kept OUT by construction | "applied; new length lines: 164"; exit clean |
| 4 | Post-validate greps | see §2 |
| 5 | `p39-agents-ci.sh` re-run | **RESULT: PASS (0 warnings)** — gates 1–9 incl. secrets zero, volatile zero, length 163 ≤ 200 |
| 6 | Ledger entry `CHG-41-AGENTS-01` appended to `generated/phase41-02-change-register.md` with before/after sha256s | Entry present; Status APPLIED |

## 2. Post-validate greps (live output)

```
$ grep -c 'postp41' AGENTS.md                    → 1   (canon pointer updated once)
$ grep -c 'ROUT-PKT-41\|R-PKT-PLATFORM' AGENTS.md → 3  (blocker refresh + note)
$ grep -ciE 'CONTAINED AT SOURCE' AGENTS.md      → 1   (resolved list refreshed)
$ grep -c 'bash -s <' AGENTS.md                  → 1   (heredoc-hazard rule present)
$ wc -l < AGENTS.md                              → 163 (≤200 cap)
$ bash ops/scripts/p39-agents-ci.sh              → errors=0 warnings=0
                                                   RESULT: PASS (0 warnings)
```

## 3. Diff summary (what changed, nothing else)

1. Canonical Truth bullet now points at `current-state-20260826-postp41.md`
   (post-P41 refresh supersedes the Phase-40 snapshot pointer-wise).
2. Change-register bullet now names `phase41-02-change-register.md` (G41 series),
   G40 register retained sticky for history.
3. Resolved-in-blockers paragraph refreshed: field-growth CONTAINED AT SOURCE
   (certification flip armed on the 08.27 guardrail), overnight soak PASS incl. the
   real fail-closed ERROR catch, watchdog live, XFO dedup DONE, dual-suricata-process
   defect FIXED via mask + exact-args invocation, v1.3.0 custody CLOSED byte-exact.
4. Packet-lane open blocker rewritten: TEST-ONLY ROUT-PKT-41 + execute_python
   platform defect (R-PKT-PLATFORM) with pointer to phase41-52.
5. Credential Handling gained exactly three Scripting Notes bullets (max 4 allowed):
   heredoc-via-ssh stdin collision; systemd-unit-vs-production-invocation divergence;
   execute_python param-injection limitation with native-node alternatives.

## 4. Hash custody

```
BEFORE b91b5e2f8cbeb75061794681b25077d4478d4465d1765330438d6dbf55491a00
AFTER  7401ac9b836d91373fd44ba9439f4994615baa4d86908226561c6470fbc123ab
```

Rollback: restore bak-20260826-063721 (single-file git-native revert also valid;
file is tracked and uncommitted changes are part of the staged P41 corpus).

## 5. Verdict

**REPAIR-CHG-41-AGENTS-01: COMPLETE.** Gap closed with the full compliance chain
intact; governance CI green; no secrets, no volatile values, no approval-class
posture change introduced.
