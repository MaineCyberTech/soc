# Phase 39 AGENTS Safety Validation — Rule Coverage, Phrasing, Enforcement, No Conflicts

**Report ID:** phase39-59-agents-safety-validation
**Phase:** 39
**Title:** Each Standing Safety Rule Mapped to MUST/MUST NOT Wording + Enforcement Hook; Verified Non-Conflicting with Repo Code
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:12:59Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-59-agents-safety-validation.md`

---

## 1. Coverage Map (rule → phrasing → enforcement)

| Standing rule (phase39-55) | AGENTS.md phrasing class | Enforcement hook |
|---|---|---|
| S1 no secrets printed/committed | MUST NOT | `p38-report-ci.sh` Gate4 secret patterns + `secret-pattern-scan.sh`; `.gitignore` deny-list; manual review |
| S2 no `docker compose down -v` | MUST NOT (verbatim command ban) | Manual review; absent from all repo scripts (verified below) |
| S3 no unsafe index / forced ISM deletion | MUST NOT | Retention scripts are the only sanctioned path; operator approval for any manual index delete |
| S4 no indiscriminate `/tmp` deletion | MUST NOT | Bounded cleanup cron + `p32-tmp-clean-check.sh` guardrails |
| S5 no production routing without gates+rollback | MUST NOT until gates pass | ROUT-39-01/-02 preconditions; change-register sign-off |
| S6 fail-closed event handling | MUST | Workflow design reviews (P36–P38 arcs) |
| S7 synthetic isolation | MUST NOT affect production counters/cases/billing | Test-group routing proofs; review |
| S8 do not weaken exposure/watermarks | MUST NOT | Firewall/TLS apply records; watermark untouched policy |
| S9 immutable reports never rewritten in place | MUST NOT | Report governance CI + hash catalogs (`catalog-reports.*`) |
| S10 PVE/RAM out of scope | MUST NOT attempt | Hard scope boundary, no tooling exists in-repo |
| S11 no simulated PASS | MUST NOT fabricate evidence | Claim-flag convention (VERIFIED/PARTIAL/UNVERIFIED) + audits |
| S12 redaction-before-commit ordering | MUST order ops this way | phase39-09…11 procedure; report CI green only post-redaction |
| S13 dynamic state = pointer, not embedded values | MUST point to canonical docs | `p39-agents-ci.sh` volatile-metric regex gate (created this arc) |

## 2. Conflict Check Against Repository Code

- **Secret patterns align:** p38-report-ci Gate4 pattern set (`password=`, `token=`,
  `api_key=`, `Bearer <20+>`, literal legacy-password strings) matches the no-secrets rule;
  the new `p39-agents-ci.sh` reuses the same pattern set for AGENTS.md. No script or doc in
  the repo requires embedding secrets, so no conflict is possible by construction.
- **Compose files vs down-v ban:** grep of `compose/*.yml` and `ops/scripts/*.sh` shows no
  `down -v` invocation anywhere; the ban forbids agent behavior only.
- **Report conventions vs metadata rule:** required header list in AGENTS.md mirrors exactly
  the field list checked by p38-report-ci Gate1 — identical, not conflicting.
- **Backup policy vs .gitignore:** backup path lives under gitignored `ops/backups/`; no
  accidental-commit conflict.

## 3. Result

All 13 rules carry unambiguous MUST/MUST NOT phrasing plus at least one enforcement hook;
zero conflicts found with repo code, CI, or runbooks.

## Verdict

Safety validation PASS.
