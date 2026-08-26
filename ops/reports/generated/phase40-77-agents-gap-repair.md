# Phase 40 AGENTS.md Gap Repair

**Report ID:** phase40-77-agents-gap-repair
**Phase:** 40
**Title:** CHG-40-AGENTS-01 — Minimal Three-Hunk AGENTS.md Refresh: Backup → Dry-Run Diff → Apply → Post-Validate; Before/After Hashes; Register Entry G40-13
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T02:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE (APPLIED)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-77-agents-gap-repair.md`

---

## 1. Process Compliance Sequence (executed in this order)

| Step | Action | Result |
|---|---|---|
| 1 | Backup FIRST per MUST rule: `ops/backups/agents/AGENTS.md.bak-20260826-024615` + sidecar `AGENTS.md.sha256-20260826-024615` | DONE — backup hash equals live hash |
| 2 | Dry-run diff built from staged copy (`/tmp/opencode/AGENTS.new.md`), reviewed before apply | DONE — 69-line unified diff, exactly 3 hunks |
| 3 | Apply staged copy over `AGENTS.md` | DONE |
| 4 | Post-validate greps + full CI rerun | DONE — stale strings 0, CI PASS |
| 5 | Change-ledger entry appended: **G40-13 / CHG-40-AGENTS-01** in `phase40-02-change-register.md` with sources + hashes | DONE |

## 2. Hashes

```
before sha256: ea1e306f8e972f26cee705fc14ade1f06c00d7c4afbeb27bdf1d1f8c7adcfe4f
after  sha256: b91b5e2f8cbeb75061794681b25077d4478d4465d1765330438d6dbf55491a00
backup file:   ops/backups/agents/AGENTS.md.bak-20260826-024615
               sha256 ea1e306f… (= before-hash, byte-identical original retained)
```

## 3. The Diff (dry-run shown pre-apply; applied verbatim)

Three hunks; everything else byte-stable:

**Hunk 1 — Canonical Truth & Navigation (F-40-04):**
```diff
-- Current operational truth: the latest authoritative current-state final under
-  `ops/reports/generated/` — currently `phase38-49-generate-current-state.md`; superseded
-  only by a newer final per its own supersession statement.
-- Open work ledger: `ops/reports/generated/phase38-47-generate-openwork.md` and
-  `ops/reports/generated/phase38-90-backlog.md`; current change register:
-  `ops/reports/generated/phase39-02-change-register.md`.
+- Current operational truth: `ops/reports/canonical/current/current-state-20260826.md`
+  (Phase-40 refresh; supersedes `phase38-49-generate-current-state.md` pointer-wise;
+  superseded only by a newer current-state doc per its own supersession statement).
+- Open work ledger: `ops/reports/canonical/current/open-work.md`; current change register:
+  `ops/reports/generated/phase40-02-change-register.md` (G40 series).
```

**Hunk 2 — Known Blockers rewrite (F-40-01/02/03/07):** resolved items folded into one
"Resolved-in-P40" line (field-fix VERIFIED phase40-13; trigger WIRED+PROVEN phase40-37/-40;
TLS implemented :3443 + plaintext LAN closed phase40-32; agent-015 merged.mg FIXED
phase40-24; dashboards 8/8 phase40-62). Open list now: 013 owner-side; 015 flap owner-side;
ISM wave Aug-29; packet import deferred-by-choice (pointers to phase40-41 +
ROUT-PKT-40-01); RTO/RPO awaiting owner (pointer to phase40-72); rehearsal NO-GO pending
approved external target.

**Hunk 3 — Credential Handling scripting note (F-40-05):**
```diff
+- Scripting note: reading key files with `$(cat file)` embeds a trailing newline in the
+  value (and therefore in the `Authorization: Bearer …` header), which reproduces
+  intermittent 401s; strip whitespace (`tr -d '[:space:]'` or equivalent) whenever
+  scripting tokens read from files. Lesson from phase40-41 (probes C1 vs E1).
```

## 4. Post-Validation

```
$ grep -c "current-state-20260826" AGENTS.md → 1        (new pointer present)
$ grep -c "trailing newline"       AGENTS.md → 1        (scripting note present)
$ grep -c "Resolved-in-P40"        AGENTS.md → 1        (resolved block present)
$ grep -cE "not wired|without TLS|38-94-deployability" AGENTS.md → 0   (stale strings gone)
$ p39-agents-ci.sh → PASS errors=0 warnings=0 (143 lines ≤ 200 cap; sections intact)
```

## 5. Sources Feeding the Edit

phase40-13/-24/-32/-37/-38/-40/-41/-53/-56/-62 evidence chain + live verifications listed
in phase40-75 §5. Approval basis: pack instruction (Phase-40 tasking prompts 76–77);
MUST-rule backup honored; rollback = restore backup byte-identical.
