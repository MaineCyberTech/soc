# Phase 38 Report Corpus Audit

**Report ID:** phase38-43-generate-corpus-audit
**Phase:** 38
**Title:** Complete Corpus Audit — Scope, Inventory, Methodology, Findings, Limitations, Evidence Map
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T20:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Authoritative:** true
**Author:** opencode/ox-alpha
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-43-generate-corpus-audit.md`
**Retention Class:** LONG
**Supersedes:** prior draft of this report ID (reissued against corrected 2026-08-25 live state)
**Evidence Roots:** ["/opt/mct-security-stack/ops/reports/generated/", "/opt/mct-security-stack/ops/evidence/p37-workflow-export/"]
**Owners:** ["opencode/ox-alpha", "ops-reports-owner"]

---

## 1. Purpose and Scope

This is the canonical corpus audit for the MCT Security Stack report corpus as of **2026-08-25T20:50Z**. It consolidates the inventory, integrity, parse, link, and live-state cross-check results produced by the Phase 38 scan suite (reports 31–42) into one authoritative summary. It supersedes the earlier draft of this report ID, which was written before the field-error mechanism correction and the Shuffle real-execution discovery were confirmed.

Scope:

| Element | Value |
|---|---|
| Primary root | `/opt/mct-security-stack/ops/reports/` (root + `generated/`) |
| Secondary roots | `/opt/wazuh-docker/multi-node/ops/`, `/opt/mct-security-stack/ops/{evidence,backups,scripts,cron,runbooks,checklists,config}` |
| Artifact classes | `.md` reports, `.log` operational logs, `.txt` evidence captures, `.json` manifests/exports |
| Census cutoff | 2026-08-25T20:50Z (pre-write census; this batch adds 12 files) |

---

## 2. Inventory Totals

### 2.1 Headline counts

| Metric | Value | Note |
|---|---|---|
| Total `.md` files | **1,888** | 1,833 original corpus + 55 phase38-generated as of census cutoff |
| Post-batch projected total | 1,900 | +12 from this report set (43–54) |
| Empty stubs | 8 | `phase33-61-.md` … `phase33-68-.md` (0 bytes) |
| Byte-identical duplicate groups (sha256) | **26 groups** | See §4.1 |
| Near-duplicate rate | ~4% | 13 groups / ~73 files measured in scan; stable across recount |
| Final operator reports | present for phases 2–35, 37 | Naming standard `final-phaseNN-operator-report-*` or `<phase>-NN-final.md` |
| Missing finals | **Phase 1, Phase 36** | No canonical final operator report exists for either |
| Git HEAD | 7bd3b82 ("Phase 37: 82 reports …"), tag v1.3.0 (790968b8) | Clean tree at audit time |

### 2.2 Count reconciliation (unreconciled figures carried by earlier summaries)

Three conflicting corpus totals circulated during Phase 38: **1,831**, **1,833**, and **1,877**.

| Figure | Source | What it actually counted |
|---|---|---|
| 1,831 | phase38-04-report-inventory (early census) | `.md` files only, primary root, first pass |
| 1,833 | phase38-31-contradiction-scan | `.md` files only, primary root, recount after 2 late writes |
| 1,877 | phase38-03-report-root-discovery | All files across 3 roots (`.md` + `.log` + `.txt` + `.json`) |
| 1,888 | This audit | `.md` total including 55 phase38-generated |

The variance is a scope-definition artifact (`.md`-only vs all-files; late writes), not data loss. Canonical going forward: **state the class and root with every count.**

---

## 3. Methodology

The audit applied five checks over the full corpus. Each check was executed by the corresponding scan report; this section records the method so results are reproducible.

### 3.1 Hash check (byte identity)

- Full `sha256` pass over every `.md` file in scope.
- Files grouped by identical digest → **26 unique duplicate groups**.
- Classification per group: original vs alias; aliases marked superseded-by-pointer, never deleted (G1 gate: no moves/copies without record).

### 3.2 Near-duplicate check (~4%)

- Structural similarity: normalized heading sequence + first-N-lines fingerprint + size ratio.
- 13 near-duplicate groups (~73 files, ~4.0%) identified, dominated by repeated per-phase templates (endpoint marker/cert pairs, shuffle-* series, tmp-* series).
- Disposition: consolidate candidates registered in the migration plan (phase38-59); no in-place rewrites performed.

### 3.3 Parse/schema check

- Frontmatter/header field presence validated against the 15-required-field schema (phase38-07).
- Legacy phases (pre-31) largely lack structured frontmatter; Phase 32+ generation is consistent.
- 8 zero-byte stubs fail trivially; they are excluded from schema statistics and queued for deletion (BCK-38-107).

### 3.4 Link/reference validation

- Relative links and `file:` path references extracted and probed against the filesystem.
- Broken-reference classes found: export-hash references to absent sidecar files (see phase38-46 MIS-38-06), and stale cross-references into renamed evidence paths.
- No mutation of referenced immutable evidence was detected (G4 gate PASS).

### 3.5 Live-state cross-verification

- Every consequential claim about release, health, OpenSearch, Shuffle, packet pipeline, field errors, retention, endpoints, `/tmp`, and deployability was checked against the live system on 2026-08-25 (reports 21–30).
- Material corrections that propagate through this audit:
  - Field-error signature is **"Limit of total fields [1000]"** (indexer-side mapping limit on `wazuh-archives-*` ingested by Filebeat), 8,746 lifetime, ~150/min current. The historical "Too many fields" string matches 0 container-log lines; `decoder_order_size=512` is **irrelevant** to this error.
  - Shuffle workflow `wazuh-high-severity-to-iris` has **68 FINISHED executions carrying real payloads** (OpenCanary L12 hits, most recent today) — prior "all healthchecks / zero real routing" phrasing is wrong on activity, though production routing remains formally deferred.
  - Agent fleet: **8 ACTIVE** (000, 006, 007, 011, 012, 014, 015, 016 — 015 Julians-Air reconnected today), 013 SAMSUNG disconnected, 008 retired.

---

## 4. Findings Summary

### 4.1 Duplication

| Finding | Count | Severity | Disposition |
|---|---|---|---|
| Byte-identical sha256 groups | 26 | LOW | Alias-marking under migration plan; no deletion |
| Near-duplicate groups | 13 (~73 files, ~4%) | LOW | Consolidation candidates listed in phase38-59 |
| Empty stubs claiming to be reports | 8 | MEDIUM | Delete after migration apply (BCK-38-107) |

### 4.2 Missing finals

| Gap | Impact | Detail |
|---|---|---|
| Phase 1 final operator report | Certification gap | No closure artifact; phase 1 content only inferable from phase 2+ back-references |
| Phase 36 final operator report | Certification gap | `phase36-75-final-report.md` exists but is summary-style and contains two claims later contradicted (relief forecast; field-fix efficacy); canonical final absent |

### 4.3 Contradictions (9 confirmed)

Full register in phase38-44. Headlines: field-error misattribution (decoder knob vs indexer mapping limit); ELIMINATED-vs-live-errors (false-negative verification via wrong grep string); loopback-vs-0.0.0.0 exposure; workflow-count phrasing; relief forecast ~7.9GB vs computable ~3.76GB; report-count variance; agent-fleet drift; execution-activity characterization; retention "deletes observed" (old policy generation) vs zero deletions under current ISM policies.

### 4.4 Stale claims (10 mappings)

Full register in phase38-45. Chains include decoder default→512→irrelevant; loopback→exposed; fleet-list evolution; aging disk/memory snapshots; error-rate 100/min→150/min; corpus-count evolution.

### 4.5 Plaintext credentials inside generated reports (3 locations)

| Location | Content leaked | Action |
|---|---|---|
| `generated/phase38-00-master.md:63` | OpenSearch/Shuffle admin password in plaintext table row | Redact (REM-38-02) |
| `generated/phase38-01-preflight.md:131` | Shuffle bearer token `[REDACTED-TOKEN]` in plaintext | Redact (REM-38-02) |
| `generated/phase38-73-shuffle-hardening.md` §Step 1 code block | Credential argument embedded in a `docker exec` example | Redact (REM-38-02) |

All three are Phase 38's own generated output — the corpus audit therefore flags its own generation pipeline, not just legacy content. Treat the bearer token as a **disclosed credential requiring rotation** (ACT-38-003), independent of redaction.

### 4.6 Unverified items carried forward

- RTO/RPO targets: absent from phase37-78 deployability certification → UNVERIFIED.
- Release object availability: asset hash `da72bde4…` verified byte-exact in-session, but artifact not persisted on-box → PARTIAL.
- ISM execution mechanics: `_plugins/_ism/explain` returned empty during verification; policies attached, ZERO deletions to date, first expiry ≈ 2026-08-29.
- Exec-mode audit: timed out (see §5).

---

## 5. Limitations

| Limitation | Effect | Mitigation |
|---|---|---|
| `gh` CLI absent on-box | Release object (id 375979989) could not be re-fetched/re-verified via API; verification relied on git tags + recorded release metadata + in-session asset hash match | Install gh + token in restricted scope, or verify from a management host |
| Exec-mode audit timed out | CI exec-bit/exec-mode posture partially unverified this cycle | Re-run with narrowed scope; see REM-38-09 |
| Transient OpenSearch auth failure | One `Unauthorized` response mid-session despite unchanged credentials (risk R-18); retry succeeded | Monitor; investigate proxy/session layer if recurrence |
| Snapshot repository unregistered | Restore-path claims cannot be exercised end-to-end (`repository_missing_exception`) | Register repo before next DR drill |
| Live-state is point-in-time | All VERIFIED flags are anchored to 2026-08-25T~20:00–20:50Z; disk/memory/error-rate values age immediately | Re-verify cadence defined in phase38-71 CI design |

---

## 6. Evidence Paths (scan reports backing this audit)

| Report | Covers |
|---|---|
| `phase38-31-contradiction-scan.md` | Contradiction candidate set, live-truth adjudication |
| `phase38-32-stale-claim-scan.md` | Superseded statement chains |
| `phase38-33-unverified-claim-scan.md` | Unverifiable/unverified claim classes |
| `phase38-34-missing-artifact-scan.md` | Missing/broken artifacts |
| `phase38-35-incomplete-work-scan.md` | Half-applied work streams |
| `phase38-36-duplicate-action-scan.md` | Duplicated open actions across phases |
| `phase38-37-status-consistency.md` | Status taxonomy violations |
| `phase38-38-date-id-consistency.md` | Date/ID coherence checks |
| `phase38-39-metric-consistency.md` | Metric conflicts across reports |
| `phase38-40-security-claim-audit.md` | Credential/exposure claim audit (incl. plaintext leaks) |
| `phase38-41-coverage-matrix.md` | Claim ↔ evidence coverage |
| `phase38-42-gap-priority.md` | Prioritized gap merge |

Verification anchors: `phase38-21` (release), `-22` (health/CI), `-23` (Shuffle), `-24` (packet), `-25` (field), `-26` (retention), `-27` (endpoints), `-28` (/tmp), `-29` (deployability), `-30` (credential ownership).

---

## 7. Verdict

| Dimension | Verdict |
|---|---|
| Inventory completeness | **PASS** (1888 .md enumerated; post-batch 1900) |
| Integrity (no evidence mutation) | **PASS** |
| Hygiene (dupes/stubs/finals) | **PARTIAL** (8 stubs, 26 dup groups, 2 missing finals) |
| Accuracy (contradictions/stale) | **FAIL until corrected** (9 contradictions, 10 stale mappings; corrective registers issued) |
| Self-hygiene (creds in own reports) | **FAIL** (3 leaks in generated/) |

Overall: **PARTIAL**. The corpus is complete and intact, but accuracy remediation (redaction, contradiction resolution, stale-marker application) must land before any certification narrative relies on it.

---

## 8. Cross-references

- Contradiction register: `phase38-44-generate-contradictions.md`
- Stale registry: `phase38-45-generate-stale.md`
- Missing artifacts: `phase38-46-generate-missing.md`
- Open work: `phase38-47-generate-openwork.md`
- Canonical current state: `phase38-49-generate-current-state.md`
