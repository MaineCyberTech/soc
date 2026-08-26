# Phase 42 AGENTS.md Gap Repair — REPAIR-CHG-42-AGENTS-01

**Report ID:** phase42-86-agents-gap-repair
**Phase:** 42
**Title:** Minimal Diff APPLIED to Root AGENTS.md With Full Compliance Chain (Backup+SHA BEFORE → Dry-Run Hunks → Assert-Guarded Apply ×5 → Post-Validate Greps → p39-agents-ci.sh PASS 0 Warnings → Ledger CHG-42-AGENTS-01 With Before/After SHA256s)
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:12:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-86-agents-gap-repair.md`

---

## 1. Compliance chain (executed in order)

| Step | Action | Result |
|---|---|---|
| 1 | Backup BEFORE edit: `cp AGENTS.md ops/backups/agents/AGENTS.md.bak-20260826-100238` + sha256 banked alongside (`.sha256-20260826-100238`) | sha256 `7401ac9b836d91373fd44ba9439f4994615baa4d86908226561c6470fbc123ab` |
| 2 | Dry-run: applier run with DRY=1 producing unified diff of all hunks BEFORE any write (63 diff lines, 19 added) — published as §3 below; first dry-run attempt aborted on edit-2 anchor mismatch (newline wrap), anchor corrected, re-dry-run clean | exit clean on corrected anchors |
| 3 | Applied via python with per-edit `assert` guards — any no-op replacement would abort; volatile metrics kept out by construction | "applied 5 edits; new length lines: 172"; exit clean |
| 4 | Post-validate greps (§4) | all targets hit exactly once |
| 5 | `p39-agents-ci.sh` re-run | **RESULT: PASS (0 warnings)** — gates 1–9 incl. secrets zero, length 172 ≤ 200 |
| 6 | Ledger entry `CHG-42-AGENTS-01` appended to `generated/phase42-02-change-register.md` with before/after sha256s | Entry present; Status APPLIED |

## 2. What changed (nothing else)

1. Canon pointer → `current-state-20260826-p42.md` (A1).
2. Field-containment clause now names the staged adjudicator script + window (A4).
3. P42 closures appended to resolved list: churn / nosniff / VT-container /
   v1.3.1 custody / EID root-cause+v2 (A3).
4. Packet blocker refreshed to DEFINITIVE-negative T1–T5 + remediation B>A>C (A2).
5. Two notes added inside existing Credential/scripting-notes block:
   HTTP-app-is-only-interpolator extension of the execute_python bullet;
   disk-threshold-disabled config-truth pointer (R-DISKBYPASS / OW-42-01).
   Sensor-mask reminder STANDS unchanged (phase42-85 §3c).

## 3. Dry-run hunks (verbatim, pre-apply)

```
@@ -28,8 +28,8 @@  Canonical Truth pointer swap (postp41 → p42)
@@ -84,14 +84,15 @@ field clause + resolved-list P42 closures
@@ -99,10 +100,11 @@ packet blocker → DEFINITIVE-negative, B>A>C
@@ -131,7 +133,14 @@ execute_python bullet extension + NEW config-truth note
(5 hunks total; full unified diff retained in session transcript and
/tmp/opencode/chg42-dry.diff during execution)
```

## 4. Post-validate greps (live output)

```
$ grep -c 'current-state-20260826-p42' AGENTS.md   → 1   (canon pointer updated once)
$ grep -cE 'phase42-48|phase42-50|phase42-53|phase42-79|phase42-69' AGENTS.md
                                                   → 1   (closure refs line present)
$ grep -c 'DEFINITIVE-negative' AGENTS.md          → 1   (packet blocker refreshed)
$ grep -c 'R-DISKBYPASS' AGENTS.md                 → 1   (config-truth note present)
$ grep -c 'HTTP app node' AGENTS.md                → 1   (interpolator note present)
$ wc -l < AGENTS.md                                → 172 (≤200 cap)
$ bash ops/scripts/p39-agents-ci.sh                → errors=0 warnings=0
                                                    RESULT: PASS (0 warnings)
```

(The credential-rule lines matching the generic secret-word pattern are the
Credential Handling RULES themselves — path/variable references only, zero values.)

## 5. Hashes

| State | sha256 |
|---|---|
| BEFORE | `7401ac9b836d91373fd44ba9439f4994615baa4d86908226561c6470fbc123ab` |
| AFTER | `d95d66de530893d9e8c587eddb55c04400ba987b909830c3de0d124f79051242` |
