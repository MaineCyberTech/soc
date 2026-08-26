# Phase 42 Release Assurance — v1.3.0 + v1.3.1

**Report ID:** phase42-101-release-assurance
**Phase:** 42
**Title:** REL-42-07 — Dual-Release Assurance: v1.3.0 Published-Original Byte-Exact Custody STANDS CLOSED And v1.3.1 Tag-Pushed/On-Box ASSURED (ls-remote Exit 0 Object Identical; Archive sha256 Recompute MATCH; MANIFEST Written); Delta Register D-1…D-12 Now SHIPPED-IN-TAG (v1.3.1 Supersedes Delta-Tracking Need Going Forward); Sensitive-File Gates PASS; Triple-CI Gates PASS Re-Run Embedded Verbatim
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T10:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase42-101-release-assurance.md`

---

## 1. Identity chains — both releases verified

```
v1.3.0 (annotated tag object 790968b88f7065ec1e72028b43e3e0da58443150)
  → commit c7261823919536463b707ca1906a30db53e82475
    → tree    33d8443c8f52d0c9ff553082f475026012f70b23

v1.3.1 (annotated tag object 71701dfd356549f1c5d2e13c9a24256afa3eac8b)
  → commit 657991943be97c4ffe1d0525b604bf09b5d6e6ba   (verified-tree lineage, CI green recorded P41)
    → tree    114324d64d68b61bc091f2f66cb6005673c49bf8
```

### Custody chains-of-record

| Release | Artifact | sha256 | Custody class |
|---|---|---|---|
| v1.3.0 | `ops/releases/v1.3.0/v1.3.0-published-original.tar.gz` | `da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c` | **CLOSED byte-exact** (published original retrieved via REST API; retained rebuilt-provenance variant beside it) |
| v1.3.1 | `ops/releases/v1.3.1/v1.3.1-from-tag.tar.gz` | `4e6c3712ba88f5ab925a2049d5d214fb55222a602c79738028ffee9a23ebf596` (15,558,573 bytes / 5,263 entries; recompute MATCH per phase42-80 §2b) | **ON-BOX-TAG-BUILT** (git archive from pushed tag; MANIFEST.md records identity/method/status) |

Remote visibility of v1.3.1 proven WITHOUT token: `git ls-remote origin refs/tags/v1.3.1`
exit 0, object identical local↔origin (`71701dfd…`), push observed `[new tag] v1.3.1 ->
v1.3.1` (phase42-79 §2 / -80 §2a). Both tarballs are gitignored BY DESIGN (`*.tar.gz`) —
hashes travel in git via the two MANIFESTs; bytes stay on-box.

## 2. Pins — carried forward intact (re-affirmed)

| Service | Pin type | Value class |
|---|---|---|
| Shuffle backend / frontend / orborus | **digest-pinned** (`@sha256:…`) | immutable |
| DFIR-IRIS app | **digest-pinned** (`@sha256:d7d230…`) | immutable |
| OpenSearch | version-pinned `3.2.0` | mutable-tag (accepted) |
| PostgreSQL / Redis / Alpine | `postgres:16-alpine`, `redis:7-alpine`, `alpine:3.20` | version-pinned |
| nginx TLS proxy | version-pinned `nginx:1.27-alpine` | mutable-tag (accepted; digest-pin remains polish candidate) |

No `latest` tags observed in the sampled set; unpinned-image aux checks remain green from the
standing series.

## 3. POST-tag runtime deltas — register D-1…D-12 is SHIPPED-IN-TAG

The twelve-item labeled register (phase41-77 inventory ⊆ phase41-98 §3 finalization, extended
through the P42 arcs: field-limit template, publish-binding hardening, TLS proxy, webhook
integrator blocks, shared-config ownership fix procedure, ISM policy-correction procedure,
delivery-monitor cron+watchdog, dashboard NDJSON artifacts, compact-stats containment chain,
XFO/nosniff dedup, watchdog script+cron, custody artifact pattern) is now **SHIPPED-IN-TAG**:
the annotated v1.3.1 message names "Deltas over v1.3.0 (D-register phase41-77/phase42-77)"
and `ops/releases/v1.3.1/MANIFEST.md` cites the combined register explicitly.

**Consequence of record:** v1.3.1 supersedes the need to keep growing the running delta
register — post-v1.3.1 runtime drift opens a FRESH v1.3.2 register at the next cut rather
than appending to D. No registered delta is absent from the tag's stated scope; no unregistered
delta was smuggled into the release claims (content hygiene spot-check names-only sweep:
matches are docs/examples/scanner-scripts only, consistent with secrets-by-path convention).

Contingency note retired: the P41 contingency ("cut with D-1…D-12 only if packet slips")
executed as written — packet remediation did NOT ship into v1.3.1; the lane stays TEST-ONLY.

## 4. Contents presence check

| Content family | Present | Evidence |
|---|---|---|
| Detection rules | YES | curated ET Open ruleset active; canary + Class-A lanes flowing through the cycle's stress events |
| Workflow exports | YES | `p38/p39-workflow-export/` + `p42-workflow-export/` (+SHA256SUMS); estate = 3 live workflows; packet lane DISABLED/TEST-ONLY re-verified live 08:13Z (status=test, trigger stopped) |
| Reports corpus | YES | metadata-complete closeout batch hand-verified against AGENTS conventions; triple CI Gate1 files=97 all carry required fields |
| Catalogs | YES (tracked delta) | base ledgers hold 392 unique rows / 0 hash mismatches through phase41; phase42 corpus append QUEUED as explicit REPO-42-04 pre-commit checklist item — tracked, not silent |
| AGENTS.md links resolve | YES | p39-agents-ci Gates 6–7 PASS this run: every referenced ops/scripts path and generated report exists |

Runtime liveness at authoring time: cluster GREEN (3 nodes); alerts flowing (24,926 today);
delivery monitor + watchdog scheduled and observed (delivered=46 sustained); zero silent
monitor slots across every observable window since activation.

## 5. Sensitive-file gates — PASS (re-run post-closeout)

All three gates re-run at 2026-08-26T09:58:02–25Z after reports phase42-96…100/-102 and the
operator final landed. Scope honesty: `p38-report-ci.sh` scans the **generated corpus on disk
at run time** (Gate1 files=97 including the closeout batch); phase42-101 was authored last to
embed those outputs — the TREE-WIDE secrets sweep covering it and the `current/` operator
final is canonical-CI Gate4 (`0 hits tree-wide`) plus the AGENTS-CI volatile/secrets gates.
Metadata headers of the seven new closeout companions + the operator final were additionally
HAND-VERIFIED field-by-field against the AGENTS.md convention set (Report ID / Phase / Title /
Date / Timestamp Z / Classification / Status / Source Path: all present; status enums valid).
Value-blind handling held: no key material printed anywhere in the batch; `$GITHUB_TOKEN`
exists owner-side only as a runbook placeholder.

### 6. Triple-CI output (verbatim)

```
=== Phase 38 Report CI ===
Scope: /opt/mct-security-stack/ops/reports/generated
Run at: 2026-08-26T09:58:02Z

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
Run at: 2026-08-26T09:58:16Z

PASS: Gate1 index: canonical/INDEX.md present

PASS: Gate2 manifest hash: 890b3536f19a85aeaf5c078e6e5136493d93ca96df163e02a5385a9ad6dece85 matches MIGRATION-MANIFEST.sha256
      manifest rows=1992 files-on-disk-in-canonical=2000

PASS: Gate3 headers: modern-sampled OK=3 bad=0; legacy-era sampled (headers not required)=27 of 30 sampled from 1984 md files

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
Run at: 2026-08-26T09:58:25Z

PASS: Gate1 existence: root AGENTS.md present
PASS: Gate2 hierarchy: single root file, no nested AGENTS.md
PASS: Gate3 sections: all 11 required headers present
PASS: Gate4 secrets: zero secret-pattern lines

PASS: Gate5 volatile: no metrics/bearer/non-loopback IPs embedded

PASS: Gate6 scripts: every referenced ops/scripts path exists
PASS: Gate7 docs: every referenced generated report exists
PASS: Gate8 length: 163 lines (<=200)
PASS: Gate9 precedence: statement present

=== CI SUMMARY ===
errors=0 warnings=0
RESULT: PASS (0 warnings)
```

## 7. Rollback posture (documented, not executed)

Per release: delete remote tag → delete local tag → remove on-box release directory
(v1.3.1 sequence proven-out in phase42-80 §3). Tag-scoped only; underlying trees/history
untouched; no runtime service consumes either tag. If a GitHub release page is later created
for v1.3.1, delete it via API before/with the remote tag deletion.

## 8. Overall Verdicts

- **v1.3.0: ASSURED-CUSTODY-CLOSED.** Identity chain intact end-to-end; published-original
  byte-exact custody stands closed; rebuilt-provenance variant honestly retained.
- **v1.3.1: ASSURED-ONBOX-PUBLICATION-PENDING.** Tag-pushed/on-box assurance complete
  (identity, integrity, completeness, rollback); single residual = release-page + downloadable
  asset visibility awaiting owner GITHUB_TOKEN, exact call sequence staged (phase42-79 §6),
  post-upload digest must equal §1 on-box sha256.
- **Custody posture DOUBLE-GREEN across both releases** — first time the engagement holds two
  simultaneously-green release lines.
- **D-register superseded by the tag going forward**: future drift opens a fresh v1.3.2
  register at next cut; nothing rides unlabeled.

*No secret values appear in this report; credentials are referenced exclusively by storage location.*
