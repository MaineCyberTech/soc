# Phase 38 Operator README & Navigation

**Report ID:** phase38-64-readme-navigation
**Phase:** 38
**Title:** Phase 38 Operator README — Where Is the Truth and How to Navigate the Corpus
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:14:00Z
**Classification:** INTERNAL
**Status:** PASS
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-64-readme-navigation.md`
**Retention Class:** canonical-current

---

## 1. Purpose

The operator-facing entry point. On migration apply this becomes the basis of `reports/README.md`. Answer the five questions operators actually ask, then give the quick-reference table.

## 2. WHERE IS THE TRUTH?

`reports/current/` — specifically **`current/49-current-state.md`** once authored. Until then the interim truth source is `final-phase37-operator-report-20260825-1943Z.md` plus `generated/phase38-13-current-state-claims.md`.

Rule: if any other document disagrees with `current/`, `current/` wins (precedence: phase38-57 §5).

## 3. WHERE IS HISTORY?

`reports/phases/phaseNN/` — one directory per phase including its `final-phase*-operator-report-*` file. Nothing in `phases/` ever changes after delivery. For anything older than the restructure, also check `archive/pre-p38/` (read-only mirror; zero citation authority).

## 4. HOW DO I VERIFY A CLAIM?

1. Look up the claim ID in **`ledgers/50-claims-ledger.md`** (interim: claim registry in `generated/phase38-09-claim-schema.md`).
2. Follow its `evidence_refs` — each points into `ops/evidence/` with a SHA-256 pin.
3. Recompute the hash; if it matches and the verification-ledger row (52) says VERIFIED, the claim holds.
4. If there is NO ledger row → treat as UNVERIFIED regardless of how confident the prose sounds.

## 5. WHAT'S BROKEN RIGHT NOW?

Two places, in order:

1. **`current/90-backlog.md`** — prioritized open items (P0 first).
2. **`current/47-openwork.md`** (seeded from `generated/phase38-35-incomplete-work-scan.md`) — unfinished work inventory.

Known-live P0s as of 2026-08-25: Shuffle frontend exposed on 0.0.0.0:3001, plaintext bearer token, 0 real alert routings (see `generated/phase38-00-master.md` §2).

## 6. CLIENT-FACING

Everything client-visible lives in `reports/client-safe/` and MUST start with the `client-` prefix. Gate rules:

- Created only by redaction pass from an internal AUTHORITATIVE source.
- Leak-check required: no credentials, internal hostnames/IPs beyond allowlist, tokens, or unagreed failure detail.
- Two-person review recorded in actions ledger before delivery.
- Anything under `client-safe/` without the prefix gets auto-quarantined by CI.
- Never hand a client anything from `current/`, `audits/`, or `generated/` directly.

## 7. ARCHIVE RULES

`archive/pre-p38/` is a frozen byte-exact mirror of the old layout: read-only (chmod a-w), never cited as truth, never edited, exists so "how it used to look" questions have a permanent answer.

## 8. Quick Reference — Top 10 Destinations

| # | I need… | Go to |
|---|---|---|
| 1 | Current system truth | `current/49-current-state.md` (interim: final-phase37 report) |
| 2 | Open work / broken things | `current/90-backlog.md` + `current/47-openwork.md` |
| 3 | What a phase did | `phases/phaseNN/final-phaseNN-operator-report-*.md` |
| 4 | Verify a claim | `ledgers/50-claims-ledger.md` → `ops/evidence/**` hash check |
| 5 | Record an action/correction | `ledgers/51-actions-ledger.csv` (append-only) |
| 6 | Client deliverable | `client-safe/client-*.md` (gated) |
| 7 | Latest audit result | `audits/{family}-audit-<newest>.md` |
| 8 | Release record | `releases/vX.Y.md` |
| 9 | Report format / templates | `schemas/` + `schemas/templates/*.md.tmpl` |
| 10 | Machine-readable everything | `generated/catalog-reports.json` + `INDEX.md` |

## 9. Escalation

If truth sources conflict and precedence (phase38-57 §5) doesn't resolve it: file a contradiction row in the verification ledger and ping the operator role — do NOT edit either document mid-conflict.
