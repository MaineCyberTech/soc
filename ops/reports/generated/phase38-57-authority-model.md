# Phase 38 Authority Model

**Report ID:** phase38-57-authority-model
**Phase:** 38
**Title:** Phase 38 Authority Model — Document Classes, Precedence, and Promotion Rules
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:07:00Z
**Classification:** INTERNAL
**Status:** PASS
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-57-authority-model.md`
**Retention Class:** canonical-current

---

## 1. Purpose

Classify every document in the corpus into exactly one authority class, define precedence when documents disagree, and codify promotion/demotion so "what is true" is mechanically answerable.

## 2. Authority Classes

### 2.1 AUTHORITATIVE-CURRENT

- **Definition:** The single live source of truth for one domain.
- **Cardinality:** exactly ONE per domain (e.g., one current-state, one backlog).
- **Location:** `reports/current/`, `reports/ledgers/` (per-ledger), `reports/schemas/`.
- **Examples:** `49-current-state` (reserved slot), `90-backlog`, `92-scorecard`, `claims-ledger.*`.
- **Rule:** a new file may not claim this class while the incumbent lives; it must first demote the incumbent to SUPERSEDED.

### 2.2 PHASE-FINAL

- **Definition:** Immutable operator report delivered at phase close.
- **Examples:** all 36 `final-phase*-operator-report-*.md`.
- **Rule:** content frozen at delivery timestamp embedded in filename. Corrections happen only via superseding docs.

### 2.3 IMMUTABLE-EVIDENCE

- **Definition:** Raw artifacts whose bytes must never change; identity = SHA-256.
- **Location:** `ops/evidence/` (never inside reports tree).
- **Examples:** `p37-workflow-export/wazuh-flow-classb-to-iris.json`, `wazuh-high-severity-to-iris.json`.
- **Rule:** any byte change creates a NEW evidence object with a new hash; old hash stays valid as history. Reports reference evidence by `path + sha256`.

### 2.4 SUPERSEDED

- **Definition:** Historical only; retained but never cited as current truth.
- **Examples:** prior versions of `current/*` after replacement; `final-phase36*` for current-truth purposes once `49-current-state` lands (supersession chain in phase38-62 §4).
- **Rule:** must carry an explicit `superseded_by:` pointer; dangling supersession pointers are CI failures.

### 2.5 DRAFT

- **Definition:** In-progress work not yet reviewable as fact.
- **Rule:** DRAFT files cannot be cited by AUTHORITATIVE-CURRENT docs; CI flags citations of DRAFTs from non-DRAFT docs.

### 2.6 GENERATED-AUDIT

- **Definition:** Machine-emitted audit/report instances.
- **Examples:** `backup-dr-audit-*` (20), `alert-volume-by-rule-*` (7), all `phase38-*.md` working reports.
- **Rule:** never hand-edited; newest instance per family is de-facto current until folded into `current/`.

### 2.7 CLIENT-SAFE

- **Definition:** Redacted derivative certified safe for client exposure.
- **Location:** `reports/client-safe/` only. Gate: filename MUST start `client-`; landing requires leak-check (no credentials, internal hosts, tokens, failure detail beyond agreed level) plus two-person review. Non-conforming files in the directory are auto-quarantined by CI.

### 2.8 TEMPLATE

- **Definition:** Skeleton with placeholders (`{{field}}`), no factual claims.
- **Examples:** `schemas/templates/*.md.tmpl` (phase38-65), `acceptance-test-template.md`.
- **Rule:** exempt from schema fact-validation; changes follow schemas-dir write rules.

### 2.9 ARCHIVE

- **Definition:** Frozen historical mirror.
- **Location:** `archive/pre-p38/`. Read-only (chmod a-w). No citation authority whatsoever.

## 3. Class Assignment Algorithm

```
class(file):
  if path starts with ops/evidence/            -> IMMUTABLE-EVIDENCE
  elif filename starts with "client-"          -> CLIENT-SAFE
  elif path under archive/                     -> ARCHIVE
  elif extension == .tmpl or name has {{ }}    -> TEMPLATE
  elif matches final-phase pattern             -> PHASE-FINAL
  elif frontmatter authoritative=true and in current/|ledgers/|schemas/ -> AUTHORITATIVE-CURRENT
  elif emitted-by-machine job                  -> GENERATED-AUDIT
  elif status == DRAFT                         -> DRAFT
  else                                         -> resolve via migration-map alias/supersede chain
```

## 4. Promotion / Demotion Procedures

| Transition | Trigger | Procedure |
|---|---|---|
| DRAFT → AUTHORITATIVE-CURRENT | Review pass + verification ledger row | Add `authoritative: true`, move to `current/`, log change-register entry, append VERIFIES edge in backlink map |
| GENERATED-AUDIT → PHASE-FINAL | Phase close | Rename to final pattern with delivery timestamp, lock |
| AUTHORITATIVE-CURRENT → SUPERSEDED | New incumbent promoted | Old file gains `superseded_by: <new-id>`, moves out of `current/` to phases/archive, INDEX regenerated |
| PHASE-FINAL → SUPERSEDED | Domain-level truth supersedes it (e.g., finals → `49-current-state`) | Content untouched; add class note + pointer; stays in `phases/` |
| Any → ARCHIVE | Retention sweep | Copy already exists; set read-only; record in retention register |

Demotions are recorded in `actions-ledger.csv` with actor, reason, and target hash.

## 5. Precedence Rules for Conflicting Statements

When two documents assert contradictory facts:

1. **Class order:** AUTHORITATIVE-CURRENT > PHASE-FINAL > GENERATED-AUDIT > DRAFT > ARCHIVE. IMMUTABLE-EVIDENCE outranks everything on questions of raw artifact content; CLIENT-SAFE ranks BELOW its internal source (it is a projection).
2. **Recency within class:** later date wins only if same class AND same domain AND newer carries verification row; otherwise conflict → contradiction scan (phase38-31) entry, resolution required within one review cycle.
3. **Ledgers win over prose:** a ledger row beats narrative text of equal class (machine-checkable > human-readable).
4. **Evidence wins over everything:** if SHA-256-pinned evidence contradicts ANY report claim, the claim is UNVERIFIED/CONTRADICTED until re-derived.
5. **Conflict resolution lands in `current/`:** every resolved conflict MUST produce (a) an updated AUTHORITATIVE-CURRENT doc, (b) a contradiction-resolution row in the verification ledger, (c) SUPERSEDED marking on the loser. Unresolved conflicts keep both files but neither may be cited as current.

## 6. Interaction with Retention

Authority class constrains retention class mapping (phase38-58): e.g., IMMUTABLE-EVIDENCE → permanent-evidence; PHASE-FINAL → phase-history/permanent; GENERATED-AUDIT working files → generated-cache or review-required.

## 7. Enforcement

`71-report-ci` validates: one AUTHORITATIVE-CURRENT per domain, no dangling `superseded_by`, CLIENT-SAFE gate, DRAFT-citation rule. Violations block the report-drift check (72).
