# Phase 39 Release Assurance — v1.3.0

**Report ID:** phase39-102-release-assurance
**Phase:** 39
**Title:** REL-39-03 — v1.3.0 Assurance: Tag Chain Verified, Pins Spot-Checked, POST-Tag Runtime Deltas Documented (v1.3.1 Candidates), Sensitive-File Gates NOW PASS Triple-GREEN; Overall ASSURED-WITH-LABELED-DELTAS
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:58:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-102-release-assurance.md`

---

## 1. Identity chain — verified

Per locate record (phase39-68), re-affirmed this cycle:

```
v1.3.0 (annotated tag object 790968b88f7065ec1e72028b43e3e0da58443150)
  → commit c7261823919536463b707ca1906a30db53e82475
    → tree    33d8443c8f52d0c9ff553082f475026012f70b23
```

On-box archive: `ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz`
sha256 `65f794a7bc1552b5a69d4797d875c98aeecdd7e1831340f35fde66141d4dc775`,
extract test PASS, MANIFEST.md carries the DIFFERENCE-FROM-PUBLISHED warning against
published `da72bde4…` (retrieval blocked: gh/network — owner item BCK-39-008).

## 2. Pins — spot-checked PASS

Compose image references sampled across service files:

| Service | Pin type | Value class |
|---|---|---|
| Shuffle backend / frontend / orborus | **digest-pinned** (`@sha256:…`) | immutable |
| DFIR-IRIS app | **digest-pinned** (`@sha256:d7d230…`) | immutable |
| OpenSearch | version-pinned `3.2.0` | mutable-tag (accepted) |
| PostgreSQL / Redis / Alpine | `postgres:16-alpine`, `redis:7-alpine`, `alpine:3.20` | version-pinned |

No `latest` tags observed in the sampled set.

## 3. Config delta since tag — documented (v1.3.1 candidates)

Two runtime deltas exist between tree `33d8443…` and tonight's running state:

| # | Delta | Origin | Disposition |
|---|---|---|---|
| D-1 | Index template `wazuh-archives-fieldlimit` (total_fields.limit 2000 + ISM carried, priority 320) exists in cluster state but not in the tagged tree | Applied P38→P39 field-fix arc | **POST-tag runtime delta → v1.3.1 candidate**: fold template definition into repo config |
| D-2 | Shuffle publish binding changed 0.0.0.0→192.168.222.149 in `compose/docker-compose.shuffle.yml` (working tree) | P39 hardening arc | **Same-tree delta already staged for commit → also flag as v1.3.1 candidate content** so a future tag includes hardened binding |

Neither delta invalidates v1.3.0 assurance; both are labeled, not silent.

## 4. Contents presence check

| Content family | Present | Evidence |
|---|---|---|
| Detection rules | YES | curated ET-Open ruleset active; alerts flowing |
| Workflow exports | YES | `ops/evidence/p38-workflow-export/` (+SHA256SUMS) and `ops/evidence/p39-workflow-export/` |
| Reports corpus | YES | canonical tree 1,992 files hash-verified N=1992 M=0 (phase39-48); catalogs present |
| Catalogs | YES | `catalog-reports.csv/.json`; release-manifest.json at root; CI Gate5 unique IDs |
| AGENTS.md links resolve | YES | p39-agents-ci Gates 6–7: every referenced ops/scripts path and every referenced generated report exists on disk |

Runtime liveness: alerts flowing (53,347 docs today); **dashboards remain the known pending item**
(artifact written+validated; runtime import open — BCK-39-010).

## 5. Sensitive-file gates — NOW PASS (redaction complete)

The P38-era FAIL condition (plaintext credentials in corpus) is retired: old bearer invalidated
server-side (401 post-restart), leak family redacted including evidence exports, new key stored
mode-600 gitignored. Verified by rerunning all three gates immediately before this report:

### 6. Triple-CI output (verbatim, run 2026-08-25T23:55Z)

```
=== Phase 38 Report CI ===
Scope: /opt/mct-security-stack/ops/reports/generated
Run at: 2026-08-25T23:55:38Z

Files in scope: 97

PASS: Gate1 metadata: all 97 files carry required fields
PASS: Gate2 report_ids: unique across corpus
PASS: Gate3 status enum: all values valid
SUMMARY Gate4 secrets: files_with_hits=0 total_matching_lines=0
PASS: Gate5 links: no broken relative .md links among generated files
PASS: Gate6 stale refs: every referenced phase38 report exists on disk

=== CI SUMMARY ===
files=97 errors=0 warnings=0 (secret_lines=0 in 0 files)
RESULT: PASS (0 warnings)
```

```
=== Phase 39 Canonical CI ===
Run at: 2026-08-25T23:55:46Z

PASS: Gate1 index: canonical/INDEX.md present
PASS: Gate2 manifest hash: 890b3536f19a85aeaf5c078e6e5136493d93ca96df163e02a5385a9ad6dece85 matches MIGRATION-MANIFEST.sha256
      manifest rows=1992 files-on-disk-in-canonical=1996
PASS: Gate3 headers: modern-sampled OK=4 bad=0; legacy-era sampled (headers not required)=26 of 30 sampled from 1981 md files
PASS: Gate4 secrets high-confidence: 0 hits tree-wide
SUMMARY Gate4 low-confidence assignment-pattern lines: files_with_hits=7 total_lines=29 (informational: historical docs)
PASS: Gate5 report_ids in phases/: unique

=== CANONICAL CI SUMMARY ===
errors=0 warnings=0
RESULT: PASS (0 warnings)
```

```
=== Phase 39 AGENTS.md Governance CI ===
Target: /opt/mct-security-stack/AGENTS.md
Run at: 2026-08-25T23:55:58Z

PASS: Gate1 existence: root AGENTS.md present
PASS: Gate2 hierarchy: single root file, no nested AGENTS.md
PASS: Gate3 sections: all 11 required headers present
PASS: Gate4 secrets: zero secret-pattern lines
PASS: Gate5 volatile: no metrics/bearer/non-loopback IPs embedded
PASS: Gate6 scripts: every referenced ops/scripts path exists
PASS: Gate7 docs: every referenced generated report exists
PASS: Gate8 length: 134 lines (<=200)
PASS: Gate9 precedence: statement present

=== CI SUMMARY ===
errors=0 warnings=0
RESULT: PASS (0 warnings)
```

Note: tracked-set manual grep for credential patterns returns only the CI script's own regex
definition (`ops/scripts/p38-report-ci.sh`) — a pattern literal, not a value.

## 7. Overall Verdict

**ASSURED-WITH-LABELED-DELTAS.**

- Identity chain intact and verified end-to-end.
- Archive integrity proven; provenance honestly labeled rebuilt-from-tag.
- Two runtime deltas since tag are documented and routed to v1.3.1 candidacy.
- Sensitive-file posture moved from FAIL to triple-GREEN within the phase.
- Residuals carried openly: published-asset retrieval (BCK-39-008), dashboards runtime import
  (BCK-39-010).
