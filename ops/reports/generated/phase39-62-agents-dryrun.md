# Phase 39 AGENTS Dry Run — Lint, Secret Scan, Volatile Scan, Hierarchy, Verdict

**Report ID:** phase39-62-agents-dryrun
**Phase:** 39
**Title:** Dry Run of Proposed AGENTS.md Against All Gates Before Apply — Verdict READY
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:19:22Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-62-agents-dryrun.md`

---

## 1. Method

The proposed text (phase39-61) was staged at `/tmp/opencode/agents-proposed.md` and checked
with the same gates later encoded in `ops/scripts/p39-agents-ci.sh`, plus manual checks.

## 2. Dry-Run Results

| Check | Tool / command | Result |
|---|---|---|
| Length sanity ≤200 lines | `wc -l` → **134** | ✅ |
| Line endings LF only | `grep -c $'\r'` → **0** | ✅ |
| Secret patterns (p38 Gate4 set: password=/token=/api_key=/Bearer 20+/legacy literals) | per-pattern grep → all **0** | ✅ |
| Volatile metrics (`(disk\|mem\|memory\|swap\|tmp)[^0-9]*[0-9]+ ?%`) | grep → none | ✅ |
| Bearer-like strings ≥16 chars after "Bearer" | grep → none | ✅ |
| IPv4 literals other than loopback `127.0.0.1` | grep → only loopback (intentional: matches existing script convention; loopback is not drift-prone) | ✅ w/ note |
| Markdown link targets | file uses inline-code paths, zero `]()` links → nothing breakable | ✅ |
| Referenced repo paths exist | 14/14 resolvable; `compose/.env` is a gitignore-pattern reference (file need not exist); `ops/scripts/p39-agents-ci.sh` created within this arc BEFORE apply so the reference resolves at commit time | ✅ |
| Hierarchy | single root file; no nested AGENTS.md exists | ✅ |
| Duplicate-directive scan | sorted bullet directives → no duplicates | ✅ |
| Command revalidation sample | `p38-report-ci.sh` executable; `docker ps -f name=shuffle-backend` returns `shuffle-backend`; indexer health green via creds-env pattern | ✅ |
| Full governance CI rehearsal | `ops/scripts/p39-agents-ci.sh` run against staged copy → **PASS, errors=0 warnings=0** (9 gates) | ✅ |

## 3. Findings and Resolutions

1. `compose/.env` MISS — accepted: text documents the ignore rule, not a required file.
2. `p39-agents-ci.sh` forward reference — resolved by creating + chmod +x the script inside
   this arc prior to apply/commit.
3. Loopback IP — deliberately allowed; documented here as the whitelist rationale.

## 4. Verdict

**READY.** No BLOCK conditions outstanding. Proceed to apply (phase39-63).
