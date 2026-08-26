# Phase 38 Release Assurance — v1.3.0

**Report ID:** phase38-95-release-assurance
**Phase:** 38
**Title:** Phase 38 Release Assurance — v1.3.0
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T21:17:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-95-release-assurance.md`

**Authoritative:** true
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase38-95-release-assurance.md`
**Retention Class:** LONG

| Field | Value |
|-------|-------|
| **Report ID** | phase38-95 |
| **Generated** | 2026-08-25 21:30 UTC |
| **Classification** | Internal / Release |
| **Owner** | MCT SOC — release engineering |
| **Status** | Integrity VERIFIED · Sensitive-file gates FAIL (redaction required before any external sharing) |
| **Supersedes** | Draft written 2026-08-25T20:12Z |

---

## 1. Scope

Assurance review of release **v1.3.0** covering: tag/asset/hash chain, image pins, configuration drift, ruleset currency, workflow artifact exports, report/catalog presence, alert-flow liveness, dashboard gap, and sensitive-file gates.

## 2. Tag / Asset / SHA256 Chain — VERIFIED byte-exact

| Element | Value | Verification |
|---------|-------|--------------|
| Tag | `v1.3.0` @ commit `c726182` | tag→commit resolution confirmed |
| Asset | `mct-security-stack-release-20260824-203124.tar.gz` — 9.9M, 2,040 files | manifest-declared |
| Bundle sha256 | `da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c` | manifest↔recorded hash match, byte-exact |
| Sensitive-file count in bundle | declared 0 | **contradicted at corpus level** — see §8 gate; the BUNDLE scan was clean, the leak class is in generated reports authored after bundling |
| RELEASE-NOTES | v1.2.0 published; v1.3.0 notes present in tree | consistent |

Chain verdict: **integrity holds end-to-end.** Caveat carried from §8: integrity ≠ shareability while credential locations exist downstream of the bundle.

## 3. Image Pins — VERIFIED (P36)

Container image digests verified pinned across services during Phase 36 and re-affirmed by config drift check this phase (§4): no floating tags in compose definitions. Pin state is a PASS input for deployability evidence (phase38-94 §4).

## 4. Configuration Drift — CHECKED; one POST-release addition

Drift sweep result: running configs match release declarations with ONE deliberate exception:

> **Index template `wazuh-archives-fieldlimit`** (patterns `wazuh-archives-4.x-*`, priority 320, `total_fields.limit: 2000` + carried ISM policy setting) was applied TODAY, after v1.3.0 was cut, to correct the archives field-budget defect (~147–150 indexer rejections/min). PUT acknowledged:true; GET verified; affects new daily indices only; empirical probe protocol executed on scratch index then deleted (phase38-78 §3).

Disposition options, decision due Phase 39 planning:

- **Option A (preferred):** fold into **v1.3.1 candidate** — template definition added to version-controlled config plane + release notes entry ("archives field-budget correction").
- **Option B:** document as **runtime delta of record** in current-state doc if no point release is cut.

Either path is compliant; silence is not. Until dispositioned, this template is a tracked post-release delta, not drift-by-neglect.

## 5. Ruleset — CURATED

Detection content: **544 ET (Emerging Threats) rules curated** and active through the manager pipeline. No unpinned or ad-hoc rule sources detected in the audit pass. Canary rule (sid 2027967) remains the proven reference detection.

## 6. Workflow Artifacts — EXPORTED + HASHED

`ops/evidence/p38-workflow-export/` refreshed this phase:

- Workflow definitions: `e951db98-….json`, `eb937a37-….json`
- Execution exports: `executions-high-severity.json` (68 executions: 65 FINISHED / 3 ABORTED — real OpenCanary payloads), `executions-flow-classb.json` (draft workflow)
- Integrity: `SHA256SUMS.txt` current over all four files

Exports are now the authoritative routing-evidence source; they supersede all aggregate execution-count claims from prior narratives.

## 7. Reports, Catalogs, Alert Flow

| Check | State |
|-------|-------|
| Report corpus present | ~1,900 md files; 98 phase38 reports (00–97) in generated/ |
| Catalogs | `catalog-reports.json/.csv` — 87 records, sha256 per file |
| Templates | 9 `.md.tmpl` under generated/templates/ |
| CI gate | `ops/scripts/p38-report-ci.sh` operational (honest-FAIL mode active — see §8) |
| Alerts flowing | YES — alert tier ~44k docs/day sustained; today 47,834 docs/54.2 MB by 21:00Z; cluster GREEN (274 shards); Suricata corpus at 433 cumulative; real honeypot events transiting automation today |

## 8. Dashboards — DECLARED GAP

W1/W2 operational dashboards remain unbuilt (usability audit 87; backlog BCK-38-014). This is the sole known feature gap against v1.3.0 scope statements. Recorded as v1.3.x roadmap item, not an integrity failure.

## 9. Sensitive-File Gates — **FAIL until redaction completes**

Three credential locations exist in the generated corpus (values NOT reproduced here; referenced by location only):

1. `ops/reports/generated/phase38-00-master.md` line 63
2. `ops/reports/generated/phase38-01-preflight.md` line 131
3. `ops/reports/generated/phase38-73-shuffle-hardening.md` §Step 1

Gate logic:

- `p38-report-ci.sh` secret-pattern gate currently returns **FAIL-honest** — this is the designed behavior; the FAIL is correct and must not be waived or suppressed.
- External sharing of ANY generated-corpus content is blocked until: (a) bearer token rotated (backlog BCK-38-001), (b) three locations redacted to location-only references (BCK-38-002), (c) gate rerun GREEN, (d) affected files re-hashed and catalog refreshed.
- The CLIENT-SAFE scorecard section (phase38-92 §5) is the sanctioned external surface in the interim; it was written clean.

## 10. Assurance Verdict Table

| Domain | Verdict |
|--------|---------|
| Tag/asset/hash chain | **VERIFIED** byte-exact |
| Image pins | **VERIFIED** |
| Config drift | **CHECKED** — one documented post-release delta pending v1.3.1 disposition |
| Ruleset | **CURATED** (544 ET) |
| Workflow artifacts | **EXPORTED+HASHED** |
| Reports/catalogs | **PRESENT** (87 catalog records) |
| Alert flow | **LIVE** |
| Dashboards | **GAP** (declared, owned) |
| Sensitive-file gates | **FAIL — redaction prerequisite** |

Overall release assurance: **integrity PASS, shareability BLOCKED**, one runtime delta awaiting formal disposition.
