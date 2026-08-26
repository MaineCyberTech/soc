# Phase 39 Release Asset Locate — v1.3.0 Identity, Provenance Pointer, and On-Box Absence

**Report ID:** phase39-68-release-asset-locate
**Phase:** 39
**Title:** Locate Record for v1.3.0 Release Asset — Authoritative Identity = Git Tag (Commit c726182), Published sha256 da72bde4… Cited from Prior Evidence, On-Box Location NONE; Decision REBUILD-WITH-LABEL
**Date:** 2026-08-25
**Timestamp:** 2026-08-25T23:42:29Z
**Classification:** INTERNAL
**Status:** COMPLETE
**Author:** opencode/ox-alpha
**Owner:** MCT SOC (automation: opencode/ox-alpha)
**Source Path:** `/opt/mct-security-stack/ops/reports/generated/phase39-68-release-asset-locate.md`

---

## 1. Authoritative identity — verified live today

```
$ git tag -l v1.3.0 && git rev-parse v1.3.0^{commit}
v1.3.0
c7261823919536463b707ca1906a30db53e82475
```

Tag object dereference:

```
$ git rev-parse v1.3.0        # annotated tag object itself
790968b88f7065ec1e72028b43e3e0da58443150
$ git cat-file -p v1.3.0 | head -3
object c7261823919536463b707ca1906a30db53e82475
type commit
tag v1.3.0
```

Tree at tag:

```
v1.3.0^{tree} = 33d8443c8f52d0c9ff553082f475026012f70b23
```

The tag → commit → tree chain is the **authoritative identity** of release v1.3.0.
Any byte-exact archive claim must be anchored to this chain.

## 2. Published asset hash — prior evidence only

Published sha256 begins `da72bde4` per prior phase records. Located via:

```
$ grep -rl "da72bde4" ops/reports | head -1
ops/reports/canonical/current/final-phase30-operator-report-20260824-220404.md
```

Corroborating canonical citations found in the same sweep include:
`canonical/phases/phase30/phase30-20-v130-asset-hash.md`,
`canonical/releases/phase38-95-release-assurance.md`, and commit message of
`bbe14c8` ("v1.3.0 bundle built (sha256 da72bde4)").
**No on-box copy of the published artifact exists to re-hash against these records.**

## 3. On-box location — NONE

```
$ find ops/releases ops/backups -name "*.tar*" 2>/dev/null | grep -i v1.3.0
(no results)
```

`find` over `ops/backups` returns only `phase2-config-*.tar.gz` dated bundles;
`ops/releases/` **did not exist on disk** prior to Phase 39 (created by phase39-69).
Conclusion: the published GitHub asset was **never archived on-box**, and `gh`
CLI is not available for retrieval.

## 4. Decision

| Option | Feasible? | Notes |
|---|---|---|
| Retrieve original asset | ❌ blocked | `gh` unavailable; no network gate credential path recorded |
| Rebuild from tag + explicit label | ✅ chosen | Content provably matches tree `33d8443…`; hash will differ from `da72bde4` and MUST be labeled rebuilt |

**DECISION: REBUILD-WITH-LABEL.** Executed as ARCH-39-01 (see phase39-69).
Provenance rule: the rebuilt artifact is a *rebuilt-artifact matching tag content*,
never claimed as the published original.

## 5. Residual

Retrieval of the original `da72bde4` asset remains an owner action item if
byte-equality with the published release is ever required (audit/legal).
