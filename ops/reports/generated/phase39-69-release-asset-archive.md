# Phase 39 Release Asset Archive — v1.3.0 Rebuilt From Tag, Hashed, Manifested

**Report ID:** phase39-69-release-asset-archive
**Phase:** 39
**Title:** ARCH-39-01 — Canonical Protected Path ops/releases/v1.3.0/ Created; Archive Generated From Git Tag v1.3.0; sha256 65f794a7… (REBUILT-LABEL); MANIFEST.md With DIFFERENCE-FROM-PUBLISHED Warning
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-69-release-asset-archive.md`

---

## 1. Archive record ARCH-39-01

Canonical protected path created:

```
$ mkdir -p ops/releases/v1.3.0/
$ git archive --format=tar.gz --prefix=v1.3.0/ \
    -o ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz v1.3.0
```

## 2. Hash and file facts (real output)

```
$ sha256sum ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz
65f794a7bc1552b5a69d4797d875c98aeecdd7e1831340f35fde66141d4dc775  ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz

$ ls -la ops/releases/v1.3.0/
-rw-r----- 1 user user 3915200 Aug 25 23:37 v1.3.0-rebuilt-from-tag.tar.gz
drwxr-x--- 2 user user    4096 Aug 25 23:37 .
```

## 3. Integrity verification

```
$ tar -tzf ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz | head -5
v1.3.0/
v1.3.0/.env.example
v1.3.0/.github/
v1.3.0/.github/workflows/
v1.3.0/.github/workflows/verify.yml
```

Archive opens cleanly; prefix `v1.3.0/` present.

## 4. Permissions

```
chmod 750 ops/releases/v1.3.0        → drwxr-x---
chmod 640 ops/releases/v1.3.0/*.tar.gz → -rw-r-----
```

## 5. Manifest written: ops/releases/v1.3.0/MANIFEST.md

Contents (verbatim):

```markdown
# Release Asset Manifest — v1.3.0 (REBUILT)

- **Label:** REBUILT-ARTIFACT matching tag content — NOT the published original.
- **Source tag:** v1.3.0 (annotated tag object 790968b88f7065ec1e72028b43e3e0da58443150)
- **Commit:** c7261823919536463b707ca1906a30db53e82475
- **Tree:** 33d8443c8f52d0c9ff553082f475026012f70b23
- **sha256:** 65f794a7bc1552b5a69d4797d875c98aeecdd7e1831340f35fde66141d4dc775
- **Timestamp:** 2026-08-25T23:37:xxZ (archive mtime Aug 25 23:37 local)
- **Generator command:**
  `git archive --format=tar.gz --prefix=v1.3.0/ -o ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz v1.3.0`

## DIFFERENCE-FROM-PUBLISHED WARNING

The published release asset sha256 begins `da72bde4` (per phase36/38 records).
This rebuilt archive's sha256 (`65f794a7…`) **WILL NOT and CANNOT be claimed to
match** the published hash — gzip stream bytes differ by timestamp/compression
parameters even with identical tree content. That difference is EXPECTED,
DISCLOSED, and LABELED here.
```

## 6. Non-claim statement

This record does **not** assert hash equality with the published asset.
Equality claim is bounded to: *content derived from tree* `33d8443…` *(tag v1.3.0)*.
