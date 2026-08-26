# Release Asset Manifest — v1.3.0 (REBUILT)

- **Label:** REBUILT-ARTIFACT matching tag content — NOT the published original.
- **Source tag:** v1.3.0 (annotated tag object `790968b88f7065ec1e72028b43e3e0da58443150`)
- **Commit:** `c7261823919536463b707ca1906a30db53e82475`
- **Tree:** `33d8443c8f52d0c9ff553082f475026012f70b23`
- **sha256:** `65f794a7bc1552b5a69d4797d875c98aeecdd7e1831340f35fde66141d4dc775`
- **Timestamp:** 2026-08-25T23:37Z (archive mtime Aug 25 23:37)
- **Generator command:**
  `git archive --format=tar.gz --prefix=v1.3.0/ -o ops/releases/v1.3.0/v1.3.0-rebuilt-from-tag.tar.gz v1.3.0`

## DIFFERENCE-FROM-PUBLISHED WARNING

The published release asset sha256 begins `da72bde4` (per phase36/38 evidence:
`canonical/phases/phase30/phase30-20-v130-asset-hash.md`,
`canonical/current/final-phase30-operator-report-20260824-220404.md`).
This rebuilt archive's sha256 (`65f794a7…`) **WILL NOT and CANNOT be claimed to
match** the published hash — gzip stream bytes differ by timestamp/compression
parameters even with identical tree content. That difference is EXPECTED,
DISCLOSED, and LABELED here.
