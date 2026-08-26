# Phase 39 AGENTS Drift Check — Point-in-Time Reconciliation of Every Factual Assertion

**Report ID:** phase39-67-agents-drift
**Phase:** 39
**Title:** AGENTS.md Claims vs Runtime: Each Assertion Tagged VERIFIED-TODAY (with Evidence Command) or POINTER-STYLE (Drift-Immune); Residuals for Phase 40
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:21:36Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-67-agents-drift.md`

---

## 1. Method

One-week-later simulation is impossible at write time, so a point-in-time reconciliation was
performed: every factual assertion in the applied file was re-tested today or classified as
pointer-style (drift-immune by design).

## 2. Assertion Reconciliation

| Assertion in AGENTS.md | Class | Evidence command / basis | Result |
|---|---|---|---|
| Repo root is git repo `github.com:MaineCyberTech/soc` | VERIFIED-TODAY | `git remote -v`; `git rev-parse --show-toplevel` → `/opt/mct-security-stack` | ✅ |
| All 7 compose files listed exist | VERIFIED-TODAY | `ls compose/*.yml` sweep (7/7) | ✅ |
| `ops/scripts/p38-report-ci.sh`, `secret-pattern-scan.sh`, `p39-agents-ci.sh` exist/executable | VERIFIED-TODAY | `test -x …` each | ✅ |
| Canonical docs (38-49/47/90, 39-02, 39-28, 39-37, 39-14, 38-94) exist | VERIFIED-TODAY | existence sweep 8/8 | ✅ |
| Catalog files `catalog-reports.csv/.json` exist | VERIFIED-TODAY | `ls ops/reports/generated/catalog-reports.*` | ✅ |
| `config/shuffle-api-key` mode 600 + gitignored | VERIFIED-TODAY | `stat -c %a` = 600; `git check-ignore` hit | ✅ |
| `*.env` gitignored, examples allowlisted | VERIFIED-TODAY | `.gitignore` rules; `git check-ignore compose/.env` | ✅ |
| creds.env outside repo, mode 600, exports `WAZUH_ADMIN_PASSWORD` | VERIFIED-TODAY | `stat` = 600; sourced var authenticates indexer (`_cluster/health` green) | ✅ |
| Indexer reachable at loopback :9200 with that pattern | VERIFIED-TODAY | live curl → cluster green, 3 nodes | ✅ |
| Loopback IP stability assumption | POINTER-STYLE-ADJACENT | loopback is interface-defined, not config drift | ✅ |
| "Current operational truth" pointer target exists and is authoritative | POINTER-STYLE | supersession statement governs; target existence verified above | ✅ |
| Blocker lines (field proof, trigger wiring, TLS, ISM wave, agents, restore NO-GO) | POINTER-STYLE | point to owning reports; no values embedded — immune by design | ✅ |
| MUST/MUST NOT safety rules | POLICY | not runtime facts; cannot drift (enforced by CI gates + review) | n/a |
| Owners list | POINTER-STYLE | role labels, not individuals; phase40 review cadence owns updates | ✅ |
| Precedence model | POLICY | self-defining statement | n/a |

## 3. Drift-Prone Residuals → Phase 40 Review Cadence

1. Pointer target will change when the phase39 final supersedes `phase38-49…` — update the
   single pointer line only (phase39-60 cadence rule).
2. Compose file inventory may grow/shrink — Repository Map line refresh.
3. Script inventory line (`p33-`–`p39-`) — extend if a p40 series appears.
4. Blocker set shrinks/grows — blocker bullets are add/remove only, never value edits.
5. Re-run `p39-agents-ci.sh` gates 6/7 after any file move/rename anywhere under
   `ops/scripts/` or `ops/reports/generated/`.

## Verdict

Drift check PASS: zero assertions contradicted runtime; every non-pointer claim carries
same-day evidence. File is structurally drift-resistant going forward.
