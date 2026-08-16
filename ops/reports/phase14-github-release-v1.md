# Phase 14 GitHub Release v1.0.0

Date: 2026-08-16

## Status: RELEASE CREATED

| Item | Value |
|---|---|
| Tag | v1.0.0 (pushed, points to cc4e389) |
| Release | https://github.com/MaineCyberTech/soc/releases/tag/v1.0.0 |
| Release name | MCT Security Stack v1.0.0 |
| Asset | mct-security-stack-release-20260816-014828.tar.gz (532K, 544811 bytes) |
| Asset URL | https://github.com/MaineCyberTech/soc/releases/download/v1.0.0/mct-security-stack-release-20260816-014828.tar.gz |
| CI on tag commit | PASS (cc4e389) |
| CI badge | Added to README (shields.io Actions badge) |
| RELEASE-NOTES.md | Updated with v1.0.0 notes |

## Process

1. CI confirmed green on latest commits.
2. Operator approved release creation.
3. README badge added, RELEASE-NOTES.md updated, committed (cc4e389).
4. Tag v1.0.0 created + pushed.
5. Release object created via API (operator-provided PAT, used in-memory only,
   never stored/committed).
6. Portable bundle uploaded as release asset.

## Notes

- PAT used transiently for the API call; not persisted anywhere.
- Bundle asset sha256 8d4dc40291a6d1906540bf774da4b44f8380a3050050273bda10a89c2b45ca7d
  (documented in release body + RELEASE-NOTES).

## No secrets

No secret values printed. Token not stored.
