# Phase 38 Canonical Structure Design

**Report ID:** phase38-55-canonical-structure-design
**Phase:** 38
**Title:** Phase 38 Canonical Structure Design — Target Directory Tree for the Report Corpus
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:05:00Z
**Classification:** INTERNAL
**Status:** PASS
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-55-canonical-structure-design.md`
**Retention Class:** canonical-current

---

## 1. Purpose

Define the single canonical directory tree for the MCT Security Stack report corpus (~1,908 `.md` files measured 2026-08-25: 1,834 at `ops/reports/` root + 74 in `ops/reports/generated/`). Every existing file maps into exactly one authoritative location in this tree. Migration is NON-DESTRUCTIVE: originals are preserved, copies are made first, and git history remains intact (see phase38-59).

## 2. Design Principles

| # | Principle | Consequence |
|---|---|---|
| P1 | One truth per domain | Exactly one AUTHORITATIVE-CURRENT file per topic lives in `current/`; everything else points at it |
| P2 | History is immutable | Once delivered, a phase final never changes content, only retention status |
| P3 | Evidence is out of band | Raw evidence stays in `ops/evidence/` (hash-pinned); reports only index it |
| P4 | Copy-first migration | No `mv`, ever. `cp -p` preserving mtime, manifest, then verify |
| P5 | Machine-readable everywhere | Each directory supports an index (human) + catalog (JSON/CSV) |
| P6 | Client surface is separate | Anything client-visible lives only in `client-safe/` behind a gate |

## 3. Target Tree

```
ops/reports/
├── INDEX.md                  <- built from phase38-60 on migration apply
├── current/                  <- single source of truth (live state)
├── phases/phaseNN/           <- immutable phase history (13-37 + finals)
├── audits/                   <- recurring audit outputs
├── evidence-indexes/         <- machine indexes OVER ops/evidence (not the evidence itself)
├── ledgers/                  <- claim/action/verification ledgers (.md/.json/.csv triads)
├── client-safe/              <- redacted, gated client deliverables
├── releases/                 <- versioned release records v1.0-v1.3+
├── runbooks/                 <- operational procedures and checklists
├── schemas/                  <- report/claim/action schemas + templates
├── archive/pre-p38/          <- full frozen mirror of pre-Phase-38 layout
└── generated/                <- Phase 38 working reports, catalogs, templates (this file)
```

Raw evidence remains at `ops/evidence/` (currently `p37-workflow-export/wazuh-flow-classb-to-iris.json`, `wazuh-high-severity-to-iris.json`) and is NEVER copied into the tree; `evidence-indexes/` holds pointers and SHA-256 pins only.

## 4. Directory Specifications

### 4.1 `reports/current/` — single source of truth

| Attribute | Value |
|---|---|
| Purpose | Live answer set: what is true right now |
| Contents mapped | `49-current-state` (slot reserved, to be authored from phase38-13-current-state-claims + final-phase37), `47-openwork` (reserved, seeded from phase38-35-incomplete-work-scan), `90-backlog`, `91-billing`, `92-scorecard`, `93-monthly`, `94-deployability`, `95-release-assurance`, `96-repo` (all present in generated/) |
| Authority level | AUTHORITATIVE-CURRENT (one per domain, see phase38-57 §2.1) |
| Write rules | Whole-file replacement only via reviewed edit; previous version moves to SUPERSEDED with pointer, never silently overwritten |
| Who may edit | Operator role with change-register entry (phase38-02 gates); automation may propose PRs but not commit |

### 4.2 `reports/phases/phaseNN/`

| Attribute | Value |
|---|---|
| Purpose | Immutable history of what was done and claimed per phase |
| Contents mapped | Flat `NN-*` files (e.g., `15-shuffle-iris-wiring.md` → `phases/phase15/`), finals `final-phaseNN-operator-report-*.md` → `phases/phaseNN/final-…`, `31v2` gets its own `phases/phase31v2/` |
| Authority level | PHASE-FINAL once the phase closes; intermediate files DRAFT→PHASE-FINAL at close |
| Write rules | Append-only. No edits after delivery. Corrections arrive as superseding docs, originals stay |
| Who may edit | Nobody (locked post-delivery); git history is the audit trail |

### 4.3 `reports/audits/`

| Attribute | Value |
|---|---|
| Purpose | Recurring audit outputs (DR/backup, code, security claim audits) |
| Contents mapped | `backup-dr-audit-*.md` (20 files), `audit-healthcheck-masked-issues.md`, `check-unpinned-docker-images-*.md`, phase38-82-code-audit; reserved slots 83–89 |
| Authority level | GENERATED-AUDIT; newest per family becomes de-facto CURRENT until folded into `current/` |
| Write rules | Automation appends timestamped instances; humans never edit emitted instances |
| Who may edit | Audit jobs (cron/CI) only |

### 4.4 `reports/evidence-indexes/`

| Attribute | Value |
|---|---|
| Purpose | Machine + human indexes over `ops/evidence/` with SHA-256 pins |
| Contents mapped | Indexes of the 2 workflow-export JSONs and future evidence drops |
| Authority level | IMMUTABLE-EVIDENCE pointers; index files GENERATED-AUDIT |
| Write rules | Regenerated wholesale by tooling; manual edits forbidden |
| Who may edit | Index builder job |

### 4.5 `reports/ledgers/`

| Attribute | Value |
|---|---|
| Purpose | Append-only registers: claims, actions, verifications, metrics |
| Contents mapped | Reserved slots 50–53; existing seeds `action-item-verification-*.md`, `alert-volume-*` metric series |
| Authority level | AUTHORITATIVE-CURRENT per ledger domain (the ledger row IS the truth) |
| Write rules | Append-only rows; corrections are new rows with `supersedes:` field, never edits |
| Who may edit | Any agent, via ledger-append tooling only |

### 4.6 `reports/client-safe/`

| Attribute | Value |
|---|---|
| Purpose | Redacted deliverables safe for client consumption |
| Contents mapped | `client-*` prefixed derivatives (e.g., `client-38-scorecard.md` from phase38-92 internal scorecard) |
| Authority level | CLIENT-SAFE (separately gated; see phase38-57 §2.8) |
| Write rules | Created only by redaction pass from an AUTHORITATIVE source; must pass leak-check before landing |
| Who may edit | Operator role; two-person review required |

### 4.7 `reports/releases/`

| Attribute | Value |
|---|---|
| Purpose | Versioned release records |
| Contents mapped | `releases-v1.md`-style records derived from phase38-95-release-assurance.md + phase38-21-release-claim-verification; slots v1.0–v1.3 |
| Authority level | RELEASE-RECORD / PHASE-FINAL equivalent — immutable once published |
| Write rules | One file per version, created at cut, never modified |
| Who may edit | Release manager role |

### 4.8 `reports/runbooks/`

| Attribute | Value |
|---|---|
| Purpose | Operational procedures, checks, acceptance tests |
| Contents mapped | `acceptance-test-template.md`, `alert-volume-baseline.md`, operational check docs currently scattered at root |
| Authority level | AUTHORITATIVE-CURRENT per procedure |
| Write rules | Reviewed edits; version-stamp in frontmatter on each change |
| Who may edit | Operator role |

### 4.9 `reports/schemas/`

| Attribute | Value |
|---|---|
| Purpose | Normative schemas + templates for all reporting |
| Contents mapped | phase38-07-report-schema, 08-status-taxonomy, 09-claim-schema, 10-action-schema, `templates/` from phase38-65 |
| Authority level | AUTHORITATIVE-CURRENT for format questions; TEMPLATE artifacts |
| Write rules | Schema changes require change-register entry + corpus impact note |
| Who may edit | Architect role |

### 4.10 `reports/archive/pre-p38/`

| Attribute | Value |
|---|---|
| Purpose | Frozen byte-exact mirror of the entire pre-Phase-38 layout |
| Contents mapped | Copy of all 1,834 root `.md` files + logs as they existed at migration start |
| Authority level | ARCHIVE / SUPERSEDED — historical reference only |
| Write rules | Read-only after creation; chmod a-w enforced |
| Who may edit | Nobody |

### 4.11 `reports/generated/`

| Attribute | Value |
|---|---|
| Purpose | Phase 38 working reports, machine catalogs, templates under construction |
| Contents mapped | All `phase38-*.md` (80 after this batch), `catalog-reports.{json,csv}`, `templates/` |
| Authority level | GENERATED-AUDIT; individual files promote per phase38-57 §4 |
| Write rules | Agents append new sequence numbers; existing files are stable |
| Who may edit | Reporting agents during an open phase; frozen at phase close |

## 5. Precedence

When directories disagree, precedence is: `current/` > `ledgers/` > `releases/` > `audits/` > `phases/` > `archive/` > `generated/` (working scratch). Full conflict-resolution algorithm: phase38-57 §5.

## 6. Migration Note

This tree is created by **copy**, never move. Original filenames persist forever in `metadata.source_path` and `migration-map.csv` (phase38-56 §7, phase38-62). Until Phase E verification passes, `generated/` remains the only actively-written directory.
