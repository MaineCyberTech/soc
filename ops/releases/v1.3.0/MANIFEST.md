# Release Asset Manifest — v1.3.0

Two artifacts are retained in this directory (see sections below):

| # | Artifact | sha256 | Status |
|---|----------|--------|--------|
| 1 | `v1.3.0-published-original.tar.gz` | `da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c` | **PRIMARY — byte-exact published original** (CUSTODY-41-01 CLOSED) |
| 2 | `v1.3.0-rebuilt-from-tag.tar.gz` | `65f794a7bc1552b5a69d4797d875c98aeecdd7e1831340f35fde66141d4dc775` | Retained as provenance-comparison artifact only |

---

## 1. PUBLISHED ORIGINAL ASSET (retrieved 2026-08-26)

- **Label:** PUBLISHED ORIGINAL — retrieved from GitHub release `v1.3.0`, BYTE-EXACT to the published identity recorded since P36.
- **Asset filename:** `mct-security-stack-release-20260824-203124.tar.gz`
- **Size:** 10,348,557 bytes
- **sha256:** `da72bde45db379c5417970224c11caf5305b281e47b302b07e45d823411b589c`
- **Match evidence:** identical to the published-asset hash recorded in
  `canonical/phases/phase30/phase30-20-v130-asset-hash.md` and the P30 final operator report —
  BYTE-EXACT match, custody gap BCK-40-007 formally CLOSED (record:
  `ops/reports/generated/phase41-75-published-asset-retrieval.md`;
  decision: `ops/reports/generated/phase41-76-asset-custody-decision.md`).
- **Retrieval URL (discovery):**
  `https://api.github.com/repos/MaineCyberTech/soc/releases/tags/v1.3.0` (unauthenticated GitHub REST API — `gh` CLI absent on box)
- **Download source:** asset `browser_download_url` from the same API response
- **Retrieval timestamp:** 2026-08-26T04:39:08Z (on-box file mtime)
- **Retrieval method:** REST API discovery via `curl` → direct download of `browser_download_url` → sha256 verification against P36 record → PASS
- **On-box path:** `ops/releases/v1.3.0/v1.3.0-published-original.tar.gz`

## 2. REBUILT ARTIFACT (provenance comparison only)
- **Label:** REBUILT-ARTIFACT matching tag content — superseded as primary by the published original (section 1); retained for provenance comparison.
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
DISCLOSED, and LABELED here. (Resolution 2026-08-26: the published original is
now on-box — section 1 — so this rebuilt archive no longer serves any custody
function; retained solely to demonstrate tag-content equivalence.)

## Custody note

`*.tar.gz` artifacts are gitignored (repo hygiene): on-box custody only. The
hashes, URLs, timestamps, and retrieval methods recorded in this file are what
carry asset identity into git. Host-backup coverage for this directory remains
a flagged gap in the owner backup policy.
