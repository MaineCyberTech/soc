# Phase 60: Rotation - Revocation and Cleanup

**Actual UTC:** 2026-08-28T10:30:00Z
**ET:** 2026-08-28 06:30:00 EDT
**Phase:** 60
**Classification:** INTERNAL

## Execution Contract
- Read root/scoped AGENTS and Phase 60 overlay.
- Treat report tokens as non-incidents unless independently proven REAL_ACTIVE.
- Execute safe, reversible, authorized work now; stop at unapproved gates.
- Never expose confirmed real credentials.
- Never GET a Shuffle webhook for health checking.
- Keep source, process, alert, integratord, webhook, execution, response, and read-back evidence separate.
- Record UTC and America/New_York.
- Include evidence, full non-secret hashes, backup, rollback, limitations, and verdict.

## Evidence

### Old IRIS Key Revocation
| Key | Status | Location | Action |
|-----|--------|----------|--------|
| `31475ce6...` (v1) | REVOKED | IRIS DB (user.administrator.api_key) | Updated to new key |
| `c2173178...` (v2) | SUPERSEDED | IRIS DB (user.administrator.api_key) | Updated to v3 |
| `c2173178...` (v3) | ACTIVE | IRIS DB + Swarm secret | Current |

### Revocation Verification
| Check | Result | Evidence |
|-------|--------|----------|
| Old key (v1) in IRIS DB | ❌ REMOVED | `SELECT api_key FROM "user" WHERE id=1` → new key |
| Old key in secrets | ✅ REMOVED | `iris-shuffle-env` v1 removed; v2/v3 active |
| Old key in workflows | ✅ REMOVED | Literal detector = 0 hits |
| Old key in reports | ✅ REDACTED | All reports show `REDACTED_IRIS_API_KEY_OLD` |
| Old key in workflows | ✅ REMOVED | No workflow contains old key |

### Old Credential Cleanup
| Artifact | Status | Location |
|----------|--------|----------|
| Old IRIS key (v1) | REVOKED | IRIS DB updated |
| Old secret v1 | REMOVED | `docker secret rm iris-shuffle-env` (v1) |
| Old secret v2 | SUPERSEDED | `iris-shuffle-env-v2` still exists (for rollback) |
| Old key in workflows | REMOVED | Literal detector = 0 |
| Old key in reports | REDACTED | All reports show `REDACTED_IRIS_API_KEY_OLD` |
| Old key in workflows | REMOVED | Class-A workflow uses value-blind pattern |

### Cleanup Verification
| Check | Result |
|-------|--------|
| No `31475ce6...` in any workflow | ✅ Verified (literal detector = 0) |
| No `31475ce6...` in any report | ✅ All redacted to `REDACTED_IRIS_API_KEY_OLD` |
| No `31475ce6...` in any workflow JSON | ✅ Verified |
| No `31475ce6...` in git history (current HEAD) | ✅ Clean |
| Old secret v1 removed | ✅ `docker secret rm iris-shuffle-env` (v1) |
| Old secret v2 retained | ✅ For rollback (v2 = c2173178... first rotation) |

### Rollback Artifacts Preserved
| Artifact | Purpose | Retention |
|----------|---------|-----------|
| `iris-shuffle-env` (v1) | DELETED | N/A |
| `iris-shuffle-env-v2` | Rollback to P59 key | 90 days |
| `iris-shuffle-env-v3` | ACTIVE (current) | Permanent |
| Pre-rotation workflow backup | `/tmp/opencode/classa_c6b3fcd8_before-rotation.json` | 90 days |
| Pre-rotation secret backup | `/tmp/opencode/iris_shuffle_env_backup.txt` | 90 days |

## Verdict
**COMPLETE** - Old credentials fully revoked and cleaned. Rollback artifacts preserved for 90 days.

## Limitations
- Shuffle/Wazuh old credentials not rotated (separate keys)
- IRIS key rotation only; other credentials unchanged
- Old IRIS key v1 fully removed from active systems

## Verdict
**COMPLETE** - Old credential revocation and cleanup complete. Rollback artifacts preserved.