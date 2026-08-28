# Phase 45: v1.3.1 GitHub Publication

## Pre-conditions
- [ ] GitHub PAT approved (Phase 45-63)
- [ ] Tag v1.3.1 exists locally
- [ ] Asset built and on-box
- [ ] No silent rebuild

## Release Details
| Property | Value |
|----------|-------|
| **Version** | v1.3.1 |
| **Tag** | v1.3.1 |
| **Target Branch** | main |
| **Release Name** | MCT Security Stack v1.3.1 |

## Asset
| Property | Value |
|----------|-------|
| **Asset Path** | [/path/to/asset] |
| **Asset Name** | mct-security-stack-v1.3.1.tar.gz |
| **Asset Size** | [MB] |
| **Checksum (SHA256)** | [SHA256] |
| **Built On** | [Timestamp] |
| **Built By** | [User/System] |

## Publication
```bash
# 1. Verify tag exists
git tag -l v1.3.1

# 2. Create release from existing tag (no rebuild)
gh release create v1.3.1 \
  --title "MCT Security Stack v1.3.1" \
  --notes-file RELEASE_NOTES_v1.3.1.md \
  --target main \
  ./mct-security-stack-v1.3.1.tar.gz

# 3. Verify release
gh release view v1.3.1 --json name,tagName,assets,createdAt
```

## Metadata Capture
| Metadata | Value |
|----------|-------|
| **Release ID** | [GitHub Release ID] |
| **HTML URL** | [GitHub Release URL] |
| **Created At** | [Timestamp] |
| **Author** | [GitHub User] |
| **Asset Count** | 1 |
| **Asset SHA256** | [SHA256] |

## Verification
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| Release created | Yes | [Y/N] | [PASS/FAIL] |
| Tag matches | v1.3.1 | [Tag] | [PASS/FAIL] |
| Asset uploaded | 1 asset | [Count] | [PASS/FAIL] |
| Asset checksum | [SHA256] | [SHA256] | [PASS/FAIL] |
| No rebuild | No rebuild triggered | [Confirmed] | [PASS/FAIL] |
| Release notes | Present | [Y/N] | [PASS/FAIL] |

## Attestations
| Attestation | Enabled | Verified |
|-------------|---------|----------|
| **Provenance** | [Y/N] | [Y/N] |
| **SBOM** | [Y/N] | [Y/N] |
| **SLSA** | [Y/N] | [Y/N] |

## Verification
```bash
# Verify release
gh release view v1.3.1 --json id,tagName,name,assets,createdAt,author

# Verify asset
gh release download v1.3.1 --pattern "*.tar.gz" --output /tmp/verify.tar.gz
sha256sum /tmp/verify.tar.gz
```

## Rollback
```bash
# Delete release if needed
gh release delete v1.3.1 --yes
# Tag remains, only release deleted
```

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Owner | [Name] | [Sig] | [Date] |
| Platform | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

## If Not Approved
**Reason:** [Reason]
**Keep:** Tag v1.3.1 locally, asset on-box, no publication
**Re-evaluation:** [Date]

---
*Generated: 2026-08-27T04:41:00Z (UTC) / 2026-08-27T00:41:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after GitHub auth (Phase 45-63)*
