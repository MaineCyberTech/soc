# Phase 39 Release Asset Verify — Provenance Chain, Catalog Entry, Read Test, Backup Gap

**Report ID:** phase39-70-release-asset-verify
**Phase:** 39
**Title:** VER-39-01 — Tag→Commit→Tree Chain Documented; Catalog Row Appended; Single-File Extract Read Test PASS; Git-Tracking Gap for *.tar.gz Confirmed; Status PARTIAL (rebuilt-labeled ≠ published-original)
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** PARTIAL
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-70-release-asset-verify.md`

---

## 1. Provenance chain VER-39-01

| Link | Value | Verified |
|---|---|---|
| Tag object | `790968b88f7065ec1e72028b43e3e0da58443150` | ✅ `git rev-parse v1.3.0` |
| → Commit | `c7261823919536463b707ca1906a30db53e82475` | ✅ `git cat-file -p v1.3.0` (`object c726182…`) |
| → Tree | `33d8443c8f52d0c9ff553082f475026012f70b23` | ✅ `git rev-parse v1.3.0^{tree}` |
| → Archive sha256 | `65f794a7bc1552b5a69d4797d875c98aeecdd7e1831340f35fde66141d4dc775` | ✅ `sha256sum` (phase39-69) |

Chain closes at the tree; the archive is a deterministic *content* derivative of
the tree, with gzip-level byte nondeterminism disclosed in MANIFEST.md.

## 2. Catalog entry

Appended row to canonical ledger `ops/reports/generated/catalog-reports.csv`
(format: `report_id,path,title,phase,date,class,status,sha256`):

```
phase39-69-release-asset-archive,generated/phase39-69-release-asset-archive.md,
Release Asset Archive ARCH-39-01 — v1.3.0 rebuilt-from-tag + manifest,39,2026-08-25,
GENERATED-AUDIT,PASS,<sha256-of-report>
```

Catalog format accepted the append (CSV schema unchanged; CI Gate re-ran clean — see §5).

## 3. Read-access test (single-file extract to tmp)

```
$ mkdir -p /tmp/opencode/p39-extract
$ tar -xzf ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz \
    -C /tmp/opencode/p39-extract v1.3.0/.env.example
$ head -3 /tmp/opencode/p39-extract/v1.3.0/.env.example
# Environment Variables (MCT Security Stack)

Copy to .env and populate with real values. NEVER commit .env.
EXTRACT-OK
$ rm -rf /tmp/opencode/p39-extract
```

READ TEST **PASS**.

## 4. Backup-inclusion gap — CONFIRMED

```
$ git check-ignore -v ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz
.gitignore:15:*.tar.gz	ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz
(exit 0 → ignored)
```

- The archive is **NOT under git tracking** (`.gitignore:15` excludes `*.tar.gz`).
- Snapshot repos cover indexer indices only; no repo covers large binaries.
- **Documented backup coverage gap:** release binaries and other large tars have
  no automated off-box replication. Owner decision needed (git-lfs, artifact
  store, or manual copy into do-spaces bucket).

## 5. Restore-use documentation (NO deploy executed)

Intended rehearsal use (Stage1 of PLAN-DR-39-01): copy
`v1.3.0-rebuilt-from-tag.tar.gz` to isolated target, extract with prefix intact,
populate `.env`/creds per Stage2, then `docker compose -f compose/*.yml up -d`.
No deployment was executed in this phase.

## 6. Status rationale — PARTIAL

- ✅ Rebuilt-labeled archive exists, hashed, manifested, read-tested.
- ❌ Not the published original (`da72bde4…`); retrieval blocked by gh/network gate.
- Owner action item: retrieve original asset or formally accept rebuilt-labeled provenance.
