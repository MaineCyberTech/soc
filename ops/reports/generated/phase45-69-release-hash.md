# Phase 45: Published Digest Proof

## On-Box Digest
| Property | Value |
|----------|-------|
| **Asset** | mct-security-stack-v1.3.1.tar.gz |
| **SHA256 (On-Box)** | [SHA256_ON_BOX] |
| **File Size** | [Bytes] |
| **Location** | [/path/to/asset] |

## Published Digest
| Property | Value |
|----------|-------|
| **Release** | v1.3.1 |
| **Asset URL** | [GitHub Asset URL] |
| **SHA256 (Published)** | [SHA256_PUBLISHED] |
| **Download Time** | [Timestamp] |

## Verification
```bash
# Download published asset
curl -L -H "Accept: application/octet-stream" \
  "https://github.com/owner/repo/releases/download/v1.3.1/mct-security-stack-v1.3.1.tar.gz" \
  -o /tmp/published.tar.gz

# Verify SHA256
sha256sum /tmp/published.tar.gz
# Expected: [SHA256_PUBLISHED]

# Compare with on-box
sha256sum /path/to/on-box/mct-security-stack-v1.3.1.tar.gz
# Expected: [SHA256_ON_BOX]

# Compare digests
# Must match exactly
```

## Comparison
| Digest | Value | Match |
|--------|-------|-------|
| **On-Box SHA256** | [SHA256_ON_BOX] | - |
| **Published SHA256** | [SHA256_PUBLISHED] | [MATCH/MISMATCH] |

## Verification
| Check | Expected | Actual | Pass/Fail |
|-------|----------|--------|-----------|
| **SHA256 Match** | Exact match | [MATCH/MISMATCH] | [PASS/FAIL] |
| **File Size Match** | Same bytes | [Bytes] | [PASS/FAIL] |
| **No Rebuild** | Identical digests | [Confirmed] | [PASS/FAIL] |

## Verdict
| Verdict | Criteria |
|---------|----------|
| **MATCH** | SHA256 identical, no rebuild |
| **MISMATCH** | Digests differ → investigate rebuild |

## Verdict
**DIGEST: [MATCH/MISMATCH]**

## If MISMATCH
**Investigation:**
1. Check build timestamp
2. Check build environment
3. Check for post-build modifications
4. Rebuild and republish if needed

## Evidence
- [ ] On-box SHA256 recorded
- [ ] Published SHA256 recorded
- [ ] Digests match
- [ ] No rebuild evidence

## Sign-Off
| Role | Name | Signature | Date |
|------|------|-----------|------|
| Owner | [Name] | [Sig] | [Date] |
| Platform | [Name] | [Sig] | [Date] |
| Security | [Name] | [Sig] | [Date] |

---
*Generated: 2026-08-27T04:42:00Z (UTC) / 2026-08-27T00:42:00-04:00 (EDT)*
*Anchor: 2026-08-27T03:29:45Z (UTC)*
*Status: PENDING - Execute after release publication (Phase 45-68)*
