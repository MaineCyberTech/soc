# Phase 41 Published Asset Retrieval — CUSTODY-41-01

**Report ID:** phase41-75-published-asset-retrieval
**Phase:** 41
**Title:** RETRIEVAL-CUSTODY-41-01 — v1.3.0 Published Asset Retrieved WITHOUT gh Via Unauthenticated GitHub REST API: Discovery URL, Asset Size 10,348,557 Bytes, sha256 BYTE-EXACT Match To P36-Published Identity (Evidence Block Embedded), Stored Alongside Rebuilt Variant, Gitignore Note Recorded
**Date:** 2026-08-26
**Timestamp:** 2026-08-26T05:50:00Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase41-75-published-asset-retrieval.md`

---

## 1. Method discovery

`gh` CLI is absent on this box; earlier retrieval attempts (BCK-40-007) were
blocked on that assumption. This cycle established that the repo's release is
public and the **GitHub REST API works unauthenticated**: a plain `curl` to
the releases-by-tag endpoint returns full release metadata including asset
names, sizes, and `browser_download_url`s. No token, no tooling dependency.

## 2. Retrieval record

| Field | Value |
|---|---|
| Discovery URL | `https://api.github.com/repos/MaineCyberTech/soc/releases/tags/v1.3.0` |
| Release tag | `v1.3.0` |
| Asset filename | `mct-security-stack-release-20260824-203124.tar.gz` |
| Asset size | **10,348,557 bytes** |
| Download source | asset `browser_download_url` from the same API response (direct download) |
| On-box path | `ops/releases/v1.3.0/v1.3.0-published-original.tar.gz` |
| On-box mtime | 2026-08-26T04:39:08Z (retrieval timestamp) |

## 3. Identity verification evidence block — VERIFIED

```
$ sha256sum ops/releases/v1.3.0/v1.3.0-published-original.tar.gz
da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c  ops/releases/v1.3.0/v1.3.0-published-original.tar.gz

Published identity of record (since P36):
canonical/phases/phase30/phase30-20-v130-asset-hash.md
canonical/current/final-phase30-operator-report-20260824-220404.md
→ da72bde4...

RESULT: BYTE-EXACT MATCH — downloaded bytes are the published asset,
not a reconstruction.
```

Size corroboration: on-box byte count equals the API-reported asset size
exactly (10,348,557).

## 4. Storage posture

The published original now sits **alongside** the rebuilt variant:

| File | sha256 | Role |
|---|---|---|
| `v1.3.0-published-original.tar.gz` | `da72bde4…` | PRIMARY custody artifact |
| `v1.3.0-rebuilt-from-tag.tar.gz` | `65f794a7…` | provenance-comparison artifact (retained) |

## 5. Gitignore note

`*.tar.gz` is gitignored by repo hygiene policy: the archive itself has **on-box
custody only** and will never enter git. What enters git is identity metadata:
hashes, size, URL, timestamps, and retrieval method — recorded via the
MANIFEST.md update executed this phase
(`ops/releases/v1.3.0/MANIFEST.md`, section 1).

## 6. Consequence

Custody gap **BCK-40-007 formally CLOSED**; decision record:
phase41-76-asset-custody-decision.md.
