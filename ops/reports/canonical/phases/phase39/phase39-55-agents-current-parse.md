# Phase 39 AGENTS Current-Parse — No Prior File; De-Facto Instruction Sources Parsed

**Report ID:** phase39-55-agents-current-parse
**Phase:** 39
**Title:** Parse of Existing Agent-Instruction Sources (N/A) Substituted by Parse of De-Facto Sources: Pack README Safety Sections, Report Conventions, Script Conventions
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:12:59Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-55-agents-current-parse.md`

---

## 1. Direct Parse

N/A — no `AGENTS.md` exists anywhere (phase39-53). There are no prior instructions to
preserve verbatim.

## 2. De-Facto Instruction Sources That DID Guide All Work

The estate has been governed by unwritten-but-consistent rules. The new AGENTS.md must
**codify, not invent**. Sources parsed:

### 2.1 Pack README safety sections (`/home/user/mct-p3{6,7,8,9}/README.md`)

Recurring durable rules across all four packs (verbatim intent preserved):

| # | Standing rule | Packs asserting it |
|---|---|---|
| S1 | Never print, copy, commit, or catalog secret values | p36–p39 |
| S2 | No `docker compose down -v` | p36–p39 |
| S3 | No unsafe index deletion; do not force-delete ISM-managed indices because a forecast date passed | p36–p39 |
| S4 | No indiscriminate `/tmp` deletion | p36, p38 |
| S5 | No production routing until native controls and test-group proofs pass | p36–p38 |
| S6 | Malformed / unknown / datastore-failure events fail closed | p36–p37 |
| S7 | Synthetic events must not affect real counters, cases, billing, scorecards | p36–p38 |
| S8 | Do not weaken exposure controls or disk watermarks | p37–p38 |
| S9 | Do not rewrite immutable/signed/client-delivered/evidence artifacts in place | p38–p39 |
| S10 | No PVE or RAM-expansion tasks (out of scope) | p36–p39 |
| S11 | No secrets, no simulated PASS evidence | all |
| S12 | Redaction-before-commit ordering for credential-bearing reports | p39 |
| S13 | AGENTS.md must not duplicate current-state content; dynamic state = pointer to canonical docs | p39 pack preservation rules |

### 2.2 Prior-phase report conventions (phase38 series, 98 generated reports)

- Metadata header block: `Report ID / Phase / Title / Date / Timestamp (Z) /
  Classification: INTERNAL / Status / Source Path`.
- Status enums constrained to the p38 CI set (COMPLETE, PARTIAL, BLOCKED, DEFERRED, …).
- Naming standard `phaseNN-slug.md`; finals carry `Authoritative`/supersession statements.
- Every claim carries flag + evidence reference (VERIFIED / PARTIAL / UNVERIFIED).

### 2.3 Existing script conventions (`ops/scripts/p33–p39`, legacy scripts)

- Secrets sourced from environment or creds files at runtime; never embedded in scripts.
  Reference pattern in-code: `-u "admin:${WAZUH_ADMIN_PASSWORD:-}"` with creds loaded from
  `/opt/wazuh-docker/multi-node/ops/creds.env` (mode 600, outside repo).
- Gates exit 0 = PASS / 1 = FAIL with explicit per-gate PASS/FAIL lines.
- Scripts are executable, bash, self-contained under `ops/scripts/`.

## 3. Codification Decision

All of S1–S13 plus the conventions above are carried into phase39-56 (fact map), the
proposed diff (phase39-61), and therefore the applied file. No rule without a source above
is introduced. Where packs conflict (none found), root file would take the stricter wording.

## Verdict

Parse COMPLETE via substitute sources. The new file codifies standing behavior; zero
invented policy.
