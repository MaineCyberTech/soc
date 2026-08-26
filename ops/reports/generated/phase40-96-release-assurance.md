# Phase 40 Release Assurance — v1.3.0

**Report ID:** phase40-96-release-assurance
**Phase:** 40
**Title:** REL-40-05 — v1.3.0 Assurance: Tag Chain Verified, Pins Spot-Checked, POST-Tag Deltas Register GROWN (v1.3.1 Candidate Manifest TABLED), Triple-CI Gates PASS Re-Run; Overall ASSURED-WITH-TABLED-DELTAS
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T03:00:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase40-96-release-assurance.md`

---

## 1. Identity chain — verified (carried forward, re-affirmed)

```
v1.3.0 (annotated tag object 790968b88f7065ec1e72028b43e3e0da58443150)
  → commit c7261823919536463b707ca1906a30db53e82475
    → tree    33d8443c8f52d0c9ff553082f475026012f70b23
```

On-box archive unchanged from locate record:
`ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz`, sha256
`65f794a7bc1552b5a69d4797d875c98aeecdd7e1831340f35fde66141d4dc775`, extract test PASS,
MANIFEST.md carries DIFFERENCE-FROM-PUBLISHED against published `da72bde4…`
(retrieval still blocked on gh/network — BCK-40-007).

## 2. Pins — spot-checked PASS (sample extended for new service)

| Service | Pin type | Value class |
|---|---|---|
| Shuffle backend / frontend / orborus | **digest-pinned** (`@sha256:…`) | immutable |
| DFIR-IRIS app | **digest-pinned** (`@sha256:d7d230…`) | immutable |
| OpenSearch | version-pinned `3.2.0` | mutable-tag (accepted) |
| PostgreSQL / Redis / Alpine | `postgres:16-alpine`, `redis:7-alpine`, `alpine:3.20` | version-pinned |
| **NEW — nginx TLS proxy** | version-pinned `nginx:1.27-alpine` | mutable-tag (accepted this cycle; digest-pin recommended as v1.3.1 polish) |

No `latest` tags observed in the sampled set.

## 3. POST-tag runtime deltas — register GROWN; v1.3.1 candidate manifest TABLED

Since tree `33d8443…` was tagged, the running stack accumulated deltas. P39 documented two;
phase-40 work grew the register. Every item below is labeled, none silent. **The v1.3.1 candidate
manifest is hereby TABLED** (not yet tagged — cut decision is an owner item):

| # | Delta | Origin | v1.3.1 rationale |
|---|---|---|---|
| D-1 | Index template `wazuh-archives-fieldlimit` (total_fields.limit 2000 + ISM carried, priority 320) | P38→P39 field-fix arc; VERIFIED this phase | Fold template definition into repo config so a rebuild reproduces the rejection-flatline posture |
| D-2 | Shuffle publish binding hardening in `compose/docker-compose.shuffle.yml` (working tree) | P39 exposure arc | Hardened binding must survive into future tags |
| D-3 | **TLS reverse-proxy service**: compose service + `config/shuffle-tls/nginx-shuffle-proxy.conf` (:3443, TLSv1.2/1.3, HSTS/XFO/nosniff); cert fingerprint pinned | P40 TLS arc (phase40-27/-32) | Security posture of record; renewal procedure references repo conf |
| D-4 | **Webhook integrator blocks** in manager ossec.conf, config-of-record BOTH nodes | P40 webhook arc (phase40-35/-40) | Automated routing certification depends on these blocks; runtime-side today |
| D-5 | **Shared-config ownership fix procedure** (merged.mg/agent.conf chown wazuh:wazuh) | P40 endpoint arc (phase40-19/-24) | Encodes the PERM-40-01 class fix so fresh deploys never reproduce 83k-error defect |
| D-6 | **ISM policy correction** (archives-14d remove→add procedure; ISM-40-01 record) | P40 retention arc (phase40-56/-60) | Retention drift correction becomes repeatable runbook content |
| D-7 | **Delivery-monitor cron entry + hardened script** (`p39-iris-delivery-check.sh` flock hardening; */15 crontab line) | P40 monitor arc (phase40-66/-67) | SLA-visible monitoring is now part of the service definition |
| D-8 | **Dashboard NDJSON saved objects** (8 objects, global tenant import receipts) | P40 visibility arc (phase40-62) | Future tags should ship the dashboards artifact and re-import step |

Manifest disposition: items D-1…D-8 are ordered candidates for a single v1.3.1 tag once the
working-tree commit lands (see phase40-97). Cut decision gated on owner approval; no tag is cut
by agents.

## 4. Contents presence check

| Content family | Present | Evidence |
|---|---|---|
| Detection rules | YES | curated ET-Open ruleset active; alerts flowing (6,836 docs today by 03:00Z) |
| Workflow exports | YES | `ops/evidence/p38-workflow-export/` (+SHA256SUMS), `ops/evidence/p39-workflow-export/`; artifacts current vs live workflows (2 of record) |
| Reports corpus | YES | generated corpus metadata-complete (CI Gate1 all-files PASS); catalogs refreshed |
| Catalogs | YES | `catalog-reports.csv/.json` both locations; release-manifest.json at root |
| AGENTS.md links resolve | YES | p39-agents-ci Gates 6–7 PASS this run: every referenced ops/scripts path and generated report exists on disk |

Runtime liveness: alerts flowing, zero ingest rejections post-field-fix; delivery monitor
scheduled and observed; dashboards imported (visual login pending).

## 5. Sensitive-file gates — PASS

All three gates re-run at 2026-08-26T03:13–03:14Z, after the full closeout corpus landed.
Scope honesty: `p38-report-ci.sh` scans the phase38 report series by design (Gate1 metadata);
the TREE-WIDE secrets sweep that covers every new phase40 closeout file is canonical-CI Gate4
(`0 hits tree-wide`) plus the AGENTS-CI volatile/secrets gates. Metadata headers of all seven new
phase40-91…97 reports were additionally hand-verified against the AGENTS.md convention set
(Report ID / Phase / Title / Date / Timestamp Z / Classification / Status / Source Path).

### 6. Triple-CI output (verbatim)

```
=== Phase 38 Report CI ===
Scope: /opt/mct-security-stack/ops/reports/generated
Run at: 2026-08-26T03:13:50Z

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
Run at: 2026-08-26T03:13:54Z

PASS: Gate1 index: canonical/INDEX.md present

PASS: Gate2 manifest hash: 890b3536f19a85aeaf5c078e6e5136493d93ca96df163e02a5385a9ad6dece85 matches MIGRATION-MANIFEST.sha256
      manifest rows=1992 files-on-disk-in-canonical=1999

PASS: Gate3 headers: modern-sampled OK=3 bad=0; legacy-era sampled (headers not required)=27 of 30 sampled from 1983 md files

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
Run at: 2026-08-26T03:14:04Z

PASS: Gate1 existence: root AGENTS.md present
PASS: Gate2 hierarchy: single root file, no nested AGENTS.md
PASS: Gate3 sections: all 11 required headers present
PASS: Gate4 secrets: zero secret-pattern lines

PASS: Gate5 volatile: no metrics/bearer/non-loopback IPs embedded

PASS: Gate6 scripts: every referenced ops/scripts path exists
PASS: Gate7 docs: every referenced generated report exists
PASS: Gate8 length: 143 lines (<=200)
PASS: Gate9 precedence: statement present

=== CI SUMMARY ===
errors=0 warnings=0
RESULT: PASS (0 warnings)
```

## 7. Overall Verdict

**ASSURED-WITH-TABLED-DELTAS.**

- Identity chain intact and verified end-to-end.
- Archive integrity proven; provenance honestly labeled rebuilt-from-tag.
- Runtime delta register GREW from two to eight items this cycle — each documented, each routed
  into the tabled v1.3.1 candidate manifest with rationale; growth reflects real security and
  automation improvements, not drift, because every delta is labeled.
- Sensitive-file posture triple-GREEN at closeout.
- Residuals carried openly: published-asset retrieval (BCK-40-007); dashboard visual login
  (BCK-40-010); v1.3.1 cut decision itself.
