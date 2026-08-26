# Phase 39 Secret Recursion Scan

**Report ID:** phase39-10-secret-recursion-scan  
**Phase:** 39  
**Title:** Recursive Secret Scan — Patterns, Scope, Counts-Only Findings, and Residual Risk Register  
**Date:** 2026-08-25  
**Timestamp:** 2026-08-25T22:33:00Z  
**Classification:** INTERNAL  
**Status:** COMPLETE  
**Authoritative:** true  
**Author:** opencode/ox-alpha  
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-10-secret-recursion-scan.md`  

---

## 1. Purpose

Close INC-39-01 with a recursive sweep proving no live secret VALUES remain in the
tracked set, and honestly enumerate what remains elsewhere (untracked-local material,
git history) with risk dispositions. Counts only; no values.

## 2. Patterns Scanned

| Pattern class | Regex/literal | Rationale |
|---|---|---|
| IRIS bearer family | `stCG-[A-Za-z0-9]{8,}` | observed live prefix family |
| Old Shuffle bearer | `0c953f60` prefix + full-length `[A-Za-z0-9._-]+` match (37-byte form) | disclosed admin token |
| Static passwords | `P@ssw0rd`, `MyS3cr37` | legacy defaults used by stack docs/scripts |
| Generic bearer strings | `Bearer [A-Za-z0-9-]{20,}` | CI Gate4 parity |
| Assignment forms | `password=`, `token=`, `api_key=` / `apikey=` | env/param leakage shapes |
| Old-token references | bare `old-shuffle-token` mention scan | documentation drift |

## 3. Scope

1. Repo TRACKED files (`git ls-files` universe) — the compliance surface.
2. Generated report corpus (`ops/reports/generated/*.md`) — CI-gated subset.
3. Workflow exports and evidence trees (`ops/evidence/**`).
4. Catalogs/manifests (`catalog-reports.json/csv`, release manifests).
5. Client-safe outputs (`reporting/`, client-onboarding templates).
6. Untracked local zones inventoried but NOT part of the pass/fail surface:
   `ops/backups/**`, `.env`, `config/shuffle-api-key` (sanctioned stores).

## 4. Findings Summary (COUNTS ONLY)

### 4.1 Tracked set (compliance surface) — final state

| Pattern | Files with hits | Notes |
|---|---|---|
| IRIS bearer value (`stCG-…`) | **0** | was 13 pre-redaction |
| Old Shuffle bearer full value (`0c953f60…` 37-byte) | **0** | was 3 tracked files (phase36-10/11/12), redacted this cycle |
| CI-script self-matches of pattern literals | 1 file (`ops/scripts/p38-report-ci.sh:65`) | scanner's own regex definitions — false positive BY DESIGN, not a secret |
| `MyS3cr37[REDACTED]` fallback default in scripts | 2 script files + 2 historical report quotes of them | PRE-EXISTING from early phases; documented in P14/P21/P22 cleanup lineage; disposition below |
| `P@ssw0rd@` historical password mentions | 2 historical report lines (phase36-11:21, phase37-01:99) | value ROTATED in P37 → inert history text; queued for placeholder conversion in P40 doc pass |

### 4.2 Untracked-local exceptions (listed by path, NO values)

| Path zone | Files matching secret patterns | Disposition |
|---|---|---|
| `ops/backups/**` | 6 files matching `stCG-`; plus long-standing credential txt backups (`iris-admin-pw.txt`, `iris-api-key.txt`) | git-untracked VERIFIED (0 tracked files under ops/backups); protected-evidence policy: stay local, never commit; candidate for encrypted-at-rest follow-up |
| `.env` | contains `SHUFFLE_API_KEY=` (current valid token) | sanctioned store #2, gitignored |
| `config/shuffle-api-key` | current valid token | sanctioned store #1, mode 600, gitignored |

### 4.3 Git history

Commits ≤ `04e689d` contain pre-redaction values for both tokens (introduced across
the P36–P38 reporting era). Count: present in multiple blobs across those commits
(exact blob census out of scope). See §6 disposition.

## 5. Reproduction Commands

```
git grep -nE "stCG-[A-Za-z0-9]{8}" -- .            # expect: no results
git grep -l "0c953f60" -- .                         # expect: no results
git grep -niE "P@ssw0rd|MyS3cr37" -- .              # expect: known historical set only
grep -rl "stCG-" ops/backups/ | wc -l               # expect: 6 (untracked exceptions)
bash ops/scripts/p38-report-ci.sh                   # Gate4: files_with_hits=0 (phase39 globs caveat)
```

## 6. Residual Risks and Dispositions

| Risk | Status | Disposition |
|---|---|---|
| Git HISTORY retains old token values | MITIGATED-INERT | both credentials rotated/invalidated server-side; historical values grant nothing. History rewrite (filter-repo/BFG) evaluated: out-of-scope this arc — it invalidates all clones, rewrites every descendant hash including the evidence chain hashed throughout P34–P39, for zero security gain post-rotation. Recommendation: formal acceptance record in Phase 40; revisit ONLY if an insider-with-history exfiltration scenario enters the threat model |
| Legacy default passwords still present as script FALLBACK defaults | ACCEPTED-WITH-TRACKING | overrides via env are the operational path; tracked since P21/P22 hardening reports; carry as P40 backlog item to strip fallbacks entirely |
| Historical `P@ssw0rd@` text lines in two phase36/37 reports | QUEUED | rotated value → inert; convert to `[REDACTED-PW]` in the next doc-hygiene pass so scanners stop self-matching |
| Untracked backups on disk hold original values | ACCEPTED-LOCAL | protected-evidence policy; add encryption-at-rest to backlog |
| CI secret gate scope excludes non-phase38 globs | GOVERNANCE GAP | see phase39-12 §4; widen glob in P40 |

## 8. False-Positive Analysis

Two scanner-self-match classes were examined and dispositioned:

1. **Pattern-definition self-matches** (`p38-report-ci.sh` SECRET_PATTERNS array):
   lines contain regex text like `stCG-[A-Za-z0-9]{20,}` — matched by naive prefix
   greps. Not secrets. Remedy if noise grows: exclude `ops/scripts/*report-ci*` from
   pattern sweeps or require the 37-byte length validation.
2. **Historical rotated-value mentions** (two `P@ssw0rd@` doc lines): real strings,
   but the credential was rotated in P37 → inert text. Queued for placeholder
   conversion rather than emergency handling.

Length-validation (full-token match) remains the primary true-positive discriminator;
it produced zero tracked hits post-redaction.

## 9. Scope Boundary Statement

This scan covers THIS repository's working tree and its git-tracked universe plus the
enumerated untracked zones on this host. Out of scope (recorded honestly): operator
laptops, chat/ticket systems where reports may have been pasted, external clones of
the repo (each clone carries history until re-cloned post-cleanup decision), and
container images built before this date. The rotation-first strategy makes all of
these non-urgent because leaked material no longer validates anywhere.

## 10. Methodology Reproducibility

All counts derive from one-shot commands embedded in §5; no manual tallying. Any
operator can reproduce the table by running the five commands and comparing to §4.
Divergence between reproduced counts and §4 = new leak event or new redaction → treat
as trigger for an INC review.

## 11. Verdict

## Appendix A — Per-Scope Result Matrix

| Scope zone | Patterns applied | Value hits | Non-value matches | Action |
|---|---|---|---|---|
| generated/*.md (CI surface) | all six classes | 0 | 0 | CI PASS ×2 |
| tracked reports (non-generated) | all six | 0 | 2 inert historical + quotes | P40 doc pass |
| tracked scripts | assignment/bearer/prefix | 0 values | fallback defaults ×2 scripts | P40 backlog |
| tracked evidence exports | prefix families | 0 | placeholders only | consistent |
| catalogs/manifests | digest+id fields only | n/a | n/a | refreshed phase39-11 |
| untracked backups | prefix families | present by design | — | accepted-local |
| git history ≤04e689d | prefix families | present, inert | — | acceptance record P40 |

## Appendix B — Count Reconciliation Arc-Wide

| Metric | Start of arc | End of arc |
|---|---|---|
| Tracked files w/ IRIS bearer value | 13 | **0** |
| Tracked files w/ old Shuffle bearer full value | 3 (+3 already-placeholder refs) | **0** |
| Sanctioned stores holding CURRENT token | 0 (didn't exist) | exactly 3 (key file, .env, datastore) |
| CI Gate4 secret lines in scanned corpus | 0 | 0 |

## Appendix C — Scanner Evolution Notes

Findings that should extend the standing pattern list for future sweeps:
`stCG-` prefix family (added), 37-byte token length signature (added as validator),
`SHUFFLE_API_KEY`/`apikey` field names (already covered by assignment class).
Pattern additions must trigger immediate repo recursion per this arc's process fix —
documented in AGENTS.md input (G8).

## 7. Verdict

**COMPLETE.** Tracked-set end state is grep-zero for live secret values; all residual
material is either inert-by-rotation, sanctioned-and-ignored, or explicitly registered
as accepted/tracked risk with a Phase 40 path.
