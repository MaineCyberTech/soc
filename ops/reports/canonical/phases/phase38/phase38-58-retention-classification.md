# Phase 38 Retention Classification

**Report ID:** phase38-58-retention-classification
**Phase:** 38
**Title:** Phase 38 Retention Classification — Corpus-Wide Classes and DO-NOT-DELETE Policy
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:08:00Z
**Classification:** INTERNAL
**Status:** PASS
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-58-retention-classification.md`
**Retention Class:** canonical-current

---

## 1. Purpose

Assign exactly one retention class to every corpus file, map real corpus patterns onto those classes with measured counts, and state the deletion policy: **the default action on every file in this corpus is KEEP.**

## 2. Retention Classes

| Class | Meaning | Deletion |
|---|---|---|
| `canonical-current` | Live source-of-truth docs | Never deleted; replaced versions become SUPERSEDED |
| `permanent-evidence` | Hash-pinned raw artifacts + their indexes | NEVER deleted, no exceptions |
| `phase-history` | Per-phase working docs + finals | Never deleted |
| `release-record` | Published release records | Never deleted |
| `client-delivered` | Client-safe deliverables actually handed over | Never deleted (contract/audit value) |
| `generated-cache` | Regenerable machine outputs | Deletable ONLY after regeneration reproduces identical bytes |
| `duplicate-alias` | Byte-duplicate paths kept as aliases | Never deleted pre-P39; post-verification deletable ONLY with alias row retained in migration-map.csv |
| `review-required` | Unvalidated or anomalous files (stubs, stragglers) | Never deleted automatically; human review gates any disposition |

## 3. Corpus Pattern Mapping (measured 2026-08-25)

| Pattern (glob) | Count | Retention class | Destination |
|---|---|---|---|
| `final-phase*-operator-report-*.md` | 36 | phase-history (+permanent flag at delivery) | `phases/phaseNN/` |
| `[0-9][0-9]-*.md` flat working files (e.g., `15-*`) | ~1,780 incl. below families | phase-history | `phases/phaseNN/` |
| `backup-dr-audit-*.md` / `*-audit*` | 20+ | generated-cache → promote newest per family to review→canonical | `audits/` |
| `alert-volume-by-rule-*.md` | 7 | generated-cache (metric snapshots); series itself feeds ledgers | `ledgers/` seeds |
| `[0-9]*-prefixed legacy (01-,14-) ` | 11 | phase-history (naming=legacy) | `phases/phaseNN/` |
| `phaseNN-*` (13–37 era incl. phase33 stubs) | bulk | phase-history | `phases/phaseNN/` |
| `phase33-61..68-.md` (8 empty stubs) | 8 | review-required | quarantine list, NOT auto-deleted (overrides earlier P0 DELETE suggestion in phase38-00; policy change logged here) |
| `phase38-*.md` working reports | 80 | generated-cache while phase open → phase-history at close | `generated/` then `phases/phase38/` |
| `catalog-*.{json,csv}` | 2 | generated-cache (regenerable, hash-recorded) | `generated/` |
| `templates/*.md.tmpl` | 9 | TEMPLATE artifacts → permanent while normative | `schemas/templates/` |
| `ops/evidence/**` | 2 JSON workflows | permanent-evidence | stay put; indexed only |
| finals referenced as current truth (final-phase36*, final-phase37*) | 2+ | phase-history + SUPERSEDED-for-truth pointer to `49-current-state` | `phases/` |
| future `client-*.md` deliverables | 0 today | client-delivered once issued | `client-safe/` |
| `migration-map.csv`, `INDEX.md` | 2 | canonical-current infrastructure | root of tree |

Counts reconcile against inventory: 1,834 root `.md` + 74 generated `.md` = 1,908 measured before this batch; +12 authored now = 1,920 total corpus `.md` (see phase38-61 catalog).

## 4. DO-NOT-DELETE Policy

1. No file under `ops/reports/` or `ops/evidence/` may be deleted by automated tooling. Ever.
2. The ONLY sanctioned removal flow: human review → `actions-ledger.csv` row with approver, reason, sha256 → executed manually → tombstone row remains in `migration-map.csv`.
3. `generated-cache` files may be regenerated in place; if regeneration output differs from the recorded hash, the difference is investigated BEFORE overwrite, never silently accepted.
4. Empty stubs (`phase33-61-.md` … `phase33-68-.md`) remain on disk flagged review-required. They are candidates for manual disposition only after P39 review confirms no lost intent.
5. Git history is part of the retention guarantee: even a mistake-recovery path exists via git, provided single-commit migration discipline (phase38-59 §7) holds.
6. `rm -rf` scope during rollback is restricted to copy destinations created by Phases A–D and enumerated in the manifest; anything outside that enumeration aborts the rollback script.

## 5. Review Cadence

| Class | Cadence | Reviewer |
|---|---|---|
| review-required | Monthly (first ops review of month) | Operator |
| generated-cache (audits) | Quarterly: verify newest-per-family promoted or explicitly stale-flagged | Operator |
| canonical-current | Continuous via drift CI (phase38-72) + monthly human pass | Operator + Architect |
| duplicate-alias | Once post-Phase-E verification, then closed | Operator |
| permanent-evidence / phase-history / release-record / client-delivered | Annual spot-audit of hashes only | Architect |

Next scheduled reviews: monthly stub review 2026-09-01; quarterly audit-family review 2026-11-01.
