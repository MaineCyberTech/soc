# Phase 39 Alias / Source-Map Validation

**Report ID:** phase39-47-alias-source-map
**Phase:** 39
**Title:** Phase 39-47 Source-Map Validation — 25-Row Spot Check, Supersession Chains, Evidence Orphans
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:36:00Z
**Classification:** INTERNAL
**Status:** PASS
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-47-alias-source-map.md`

---

## 1. Random Spot Check (seed 39047, n=25)

Checks per row: source exists · dest exists · sha256(source) == manifest `sha256_source` ·
sha256(dest) == manifest `sha256_source` · mapping rule shape correct (current/ ⇐ finals|R0;
phases/phaseNN/ ⇐ `^phaseNN-`/`^NN-`).

```
SPOT-CHECK TOTAL: 25/25 PASS
```

Sampled rows spanned all major rules: 2× final-phase* (R1→current/), 14× phaseNN-* (R5),
1× docs-governance + 1× docs-audit (R4), 1× backlog (R3), 5× strays incl. shuffle-healthcheck,
full-stack-health, greenbone-schedule-readiness (R6→archive/pre-p13/), 1× generated/phase38-93.
Zero failures of any kind.

## 2. Supersession Chains

- **Finals → current/: 37/37** mapped (`final-phase2…final-phase37` from flat root +
  `final-phase38-operator-report-20260825-2130Z.md` from `ops/reports/current/`). Latest-truth pointer:
  final-phase38; legacy finals remain immutable history per P38 precedence (current/ > ledgers/ > phases/).
- Working-doc chains intact by directory: e.g. phase31v2 series (30 files) co-located under
  `phases/phase31v2/`; phase38 working set (97 files) under `phases/phase38/`.

## 3. Evidence Orphan Scan

Every file under `ops/evidence/**` must be referenced by ≥1 report outside canonical/:

| Evidence file | Referring reports |
|---|---|
| p39-workflow-export/packet-workflow-import.json | 1 |
| p38-workflow-export/eb937a37-….json | 2 |
| p38-workflow-export/e951db98-….json | 3 |
| p38-workflow-export/executions-flow-classb.json | 5 |
| p38-workflow-export/executions-high-severity.json | 6 |
| p37-workflow-export/wazuh-high-severity-to-iris.json | 12 |
| p38-workflow-export/SHA256SUMS.txt | 13 |
| p37-workflow-export/wazuh-flow-classb-to-iris.json | 15 |

**Orphaned evidence: 0.** Canonical pointer for these pins: `canonical/evidence-indexes/evidence-index.md`.

## 4. Git History Preservation

Originals tracked unchanged by APPLY-39-01: the only modified tracked files under `ops/reports/`
are the **7 pre-existing redaction-era edits** recorded at precheck (phase39-43 §3); the apply added
zero modifications to original paths. Byte-proof: 9-source re-hash diff empty (phase39-45 §4);
mtime preservation via `cp -p`. All 1,992 copies are new untracked paths until the phase-close commit.

## 5. Verdict

**PASS** — no failures. Mapping rules deterministic; aliases (byte-duplicate families flagged in
phase38-05) each retain their own row and dest, so no alias row was dropped by migration.
