# Phase 41 Release Assurance — v1.3.0

**Report ID:** phase41-98-release-assurance
**Phase:** 41
**Title:** REL-41-06 — v1.3.0 Assurance: Custody CLOSED Byte-Exact This Cycle (Published-Original On-Box, Upgraded From Labeled-Rebuilt-Only), Tag Chain Intact, Deltas Register GROWN To D-1…D-12 With v1.3.1 Manifest FINALIZED For Phase-42-Open Cut, Triple-CI Gates PASS Re-Run Embedded; Verdict ASSURED-CUSTODY-CLOSED
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T07:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-98-release-assurance.md`

---

## 1. Identity chain — verified; custody UPGRADED this cycle

```
v1.3.0 (annotated tag object 790968b88f7065ec1e72028b43e3e0da58443150)
  → commit c7261823919536463b707ca1906a30db53e82475
    → tree    33d8443c8f52d0c9ff553082f475026012f70b23
```

**Custody chain-of-record as of today (CLOSED):**

| Artifact | sha256 | Role |
|---|---|---|
| `ops/releases/v1.3.0/v1.3.0-published-original.tar.gz` | `da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c` | **PRIMARY custody artifact** — retrieved 2026-08-26T04:39:08Z via unauthenticated GitHub REST API (no gh needed), byte-exact vs published identity; size corroborated at 10,348,557 bytes vs API-reported |
| `ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz` | `65f794a7bc1552b5a69d4797d875c98aeecdd7e1831340f35fde66141d4dc775` | retained provenance-comparison artifact (honestly labeled) |

MANIFEST.md updated in place with the primary row + retrieval method/timestamp; both tarballs are
gitignored BY DESIGN (`*.tar.gz`) — hashes travel in git, bytes stay on-box; backup-policy
inclusion of `ops/releases/**` remains a flagged owner gap (phase41-76 §4). The P40-era
"labeled-rebuilt-only" custody caveat is hereby RETIRED.

## 2. Pins — carried forward intact (re-affirmed)

| Service | Pin type | Value class |
|---|---|---|
| Shuffle backend / frontend / orborus | **digest-pinned** (`@sha256:…`) | immutable |
| DFIR-IRIS app | **digest-pinned** (`@sha256:d7d230…`) | immutable |
| OpenSearch | version-pinned `3.2.0` | mutable-tag (accepted) |
| PostgreSQL / Redis / Alpine | `postgres:16-alpine`, `redis:7-alpine`, `alpine:3.20` | version-pinned |
| nginx TLS proxy | version-pinned `nginx:1.27-alpine` | mutable-tag (accepted; digest-pin recommended as v1.3.1 polish) |

No `latest` tags observed in the sampled set (aux re-check landed this phase:
`check-unpinned-docker-images-20260826-062918.md`).

## 3. POST-tag runtime deltas — register now D-1…D-12; v1.3.1 manifest FINALIZED

Since tree `33d8443…` was tagged, the running stack accumulated deltas. P40 tabled D-1…D-8;
phase 41 grows the register to **twelve** (five P41 additions, with the .bak sweep extending the
ownership row). Every item is labeled, none silent. **The v1.3.1 manifest is hereby FINALIZED**
for the Phase-42-open cut per DECISION-V131-41-01; execution follows RELPLAN-41-01 (no tag is cut
by agents):

| # | Delta | Origin | v1.3.1 rationale |
|---|---|---|---|
| D-1 | Index template `wazuh-archives-fieldlimit` (total_fields.limit 2000 + ISM carried, priority 320) | P38→P39 field-fix arc | Rebuild reproduces the rejection-flatline posture |
| D-2 | Shuffle publish binding hardening in compose | P39 exposure arc | Hardened binding survives into future tags |
| D-3 | TLS reverse-proxy service + nginx conf (:3443, TLSv1.2/1.3, headers) with cert fingerprint pin | P40 TLS arc | Security posture of record; renewal references repo conf |
| D-4 | Webhook integrator blocks in manager ossec.conf (config-of-record both nodes) | P40 webhook arc | Automated routing certification depends on them |
| D-5 | Shared-config ownership fix procedure — **EXTENDED P41**: windows/mac `.bak` ownership sweep verified clean (zero root-owned; remoted noise gone ~3h50m silent) | P40 arc + phase41-67/-68 | Encodes the PERM class fix incl. its sibling-class sweep |
| D-6 | ISM policy-correction procedure (archives-14d remove→add; ISM-40-01 record) | P40 retention arc | Drift correction becomes repeatable runbook content |
| D-7 | Delivery-monitor cron entry + flock-hardened script (*/15) | P40 monitor arc | SLA-visible monitoring part of service definition |
| D-8 | Dashboard NDJSON saved objects (8 objects, global tenant receipts) | P40 visibility arc | Tags ship dashboards artifact + re-import step |
| D-9 | **NEW P41 — compact-stats containment chain**: sensor eve types change + exact-args invocation record + `/usr/local/bin/suricata-compact-stats.py` + systemd timer/service (60s) + agent localfile; dual-process mask/unmask procedure | phase41-15 register G41-01…12 | Source-side containment must reproduce on rebuild; sensor configs documented for manifest inclusion |
| D-10 | **NEW P41 — XFO dedup** in nginx proxy conf (single header; HSTS/nosniff retained; nosniff residue tracked OW-41-01) | phase41-66 | Header hygiene of record |
| D-11 | **NEW P41 — watchdog**: `ops/scripts/p41-monitor-watchdog.sh` + offset cron 3,18,33,48 + dedicated alert log | phase41-39/-43 | Monitor maturity is part of the shipped posture |
| D-12 | **NEW P41 — custody artifacts**: MANIFEST primary row (published-original hash/URL/timestamp/method) + retrieval-pattern record reusable verbatim for v1.3.1 stage 6 | phase41-75/-76 | Day-one closed custody becomes the release standard |

Contingency unchanged: if packet-lane remediation slips at P42 open, cut v1.3.1 with D-1…D-12 only
(phase41-79 §5).

## 4. Contents presence check

| Content family | Present | Evidence |
|---|---|---|
| Detection rules | YES | curated ET Open ruleset active (529 rules loaded); canary SIDs flowing across three eras [phase41-89] |
| Workflow exports | YES | `ops/evidence/p38-workflow-export/` + `p39-workflow-export/` (+SHA256SUMS) current for the two production-record workflows; estate = **3 live workflows** (e133a645 suricata-packet-routing test-only/disabled 13 actions; eb937a37 high-sev→IRIS; e951db98 flow-classb draft), packet artifact sha-pinned per phase41-52; export refresh row included in v1.3.1 docs sweep |
| Reports corpus | YES | metadata-complete closeout batch hand-verified against AGENTS conventions (see §5 scope note); catalogs reconciled |
| Catalogs | YES | ledgers csv/json hold **392 unique rows, 0 hash mismatches across all 93 phase41 entries** (+91 lagging rows then self-rows appended this cycle) |
| AGENTS.md links resolve | YES | p39-agents-ci Gates 6–7 PASS this run: every referenced ops/scripts path and generated report exists |

Runtime liveness: alerts flowing (10,655 during postcheck window); compact health lane fresh
(129 stats_compact docs by 06:24Z, live growth observed); delivery monitor + watchdog scheduled
and observed; zero ingest rejections trailing 24h.

## 5. Sensitive-file gates — PASS (re-run post-closeout)

All three gates re-run at 2026-08-26T07:21:31–32Z, after reports phase41-93…97/-99 and the
operator final landed. Scope honesty: `p38-report-ci.sh` scans the **phase38 report series by
design** (Gate1 files=97); the TREE-WIDE secrets sweep covering every new file is canonical-CI
Gate4 (`0 hits tree-wide`) plus the AGENTS-CI volatile/secrets gates. Metadata headers of all
seven new closeout reports + the operator final were additionally HAND-VERIFIED field-by-field
against the AGENTS.md convention set (Report ID / Phase / Title / Date / Timestamp Z /
Classification / Status / Source Path: all present; status enums valid; a targeted value-form
secret grep over the new batch returned zero hits).

### 6. Triple-CI output (verbatim)

```
=== Phase 38 Report CI ===
Scope: /opt/mct-security-stack/ops/reports/generated
Run at: 2026-08-26T07:21:31Z

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
Run at: 2026-08-26T07:21:32Z

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
Run at: 2026-08-26T07:21:32Z

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

## 7. Overall Verdict

**ASSURED-CUSTODY-CLOSED.**

- Identity chain intact and verified end-to-end; custody chain CLOSED with the byte-exact
  published original on-box — the release record no longer rides a rebuilt-only caveat.
- Runtime delta register GREW from eight to twelve labeled items; the v1.3.1 manifest is
  FINALIZED for Phase-42-open cut (execution plan staged, rollback table ready, contingency set).
  Growth reflects real security and automation improvements, not drift, because every delta is
  labeled.
- Workflow estate clean: three workflows, packet lane test-only/disabled, artifacts pinned,
  exports hashed; zero production contamination from the proof arc.
- Catalogs at full parity (392 rows, zero hash mismatches); triple CI GREEN same-run.
- Residuals carried openly: v1.3.1 cut execution itself (owner-gated tag); dashboard visual login;
  XCTO residue (P4); tarball backup-policy gap flagged for owner review.

*No secret values appear in this report; credentials are referenced exclusively by storage location.*
