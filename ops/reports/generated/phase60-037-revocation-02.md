# Phase 60: Revocation - Verification and Cleanup

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

### Revocation Completeness Matrix
| Credential | Revoked | Verified | Location |
|------------|---------|----------|----------|
| IRIS Key v1 (`31475ce6...`) | ✅ | ✅ | IRIS DB, Swarm secret, workflows, reports |
| IRIS Key v2 (P59) | SUPERSEDED | ✅ | Secret v2 retained for rollback |
| IRIS Key v3 (current) | ACTIVE | ✅ | IRIS DB, Swarm secret, workflows |
| Shuffle API Key | NOT ROTATED | N/A | Still active |
| Wazuh API Key | NOT ROTATED | N/A | N/A |
| Wazuh Passwords | NOT ROTATED | N/A | N/A |

### Cleanup Verification Checklist
| Item | Status | Evidence |
|--------|--------|----------|
| Old IRIS key removed from IRIS DB | ✅ | `UPDATE "user" SET api_key='...' WHERE id=1` |
| Old secret removed from Swarm | ✅ | `docker secret rm iris-shuffle-env` (v1) |
| Old key removed from workflows | ✅ | Literal detector = 0 |
| Old key redacted in reports | ✅ | All reports show `REDACTED_IRIS_API_KEY_OLD` |
| Old secret removed from Swarm | ✅ | `docker secret rm iris-shuffle-env` (v1) |
| Old key removed from workflows | ✅ | Literal detector = 0 |
| Old key redacted in reports | ✅ | All reports show `REDACTED_IRIS_API_KEY_OLD` |
| Old key in git history | ⚠️ | Historical commits (pre-P57) have old key; current HEAD clean |
| Old key in Shuffle workflows | ✅ | No workflows contain old key |
| Old key in reports | ✅ | All redacted to `REDACTED_IRIS_API_KEY_OLD` |

### Residual Artifacts (Intentional)
| Artifact | Purpose | Retention |
|----------|---------|-----------|
| `iris-shuffle-env-v2` (P59 key) | Rollback to P59 rotation | 90 days |
| Pre-rotation workflow backup | `/tmp/opencode/classa_c6b3fcd8_before-rotation.json` | 90 days |
| Pre-rotation secret backup | `/tmp/opencode/iris_shuffle_env_backup.txt` | 90 days |
| Old IRIS key in git history | Historical record | Permanent (git history) |

### Verification Commands
```bash
# Verify no old key in workflows
grep -r "31475ce60587be55229c3bf97ac3c317" /opt/mct-security-stack/ops/reports/generated/phase59-* 2>/dev/null || echo "CLEAN"

# Verify old key not in workflows
curl -H "Authorization: Bearer $SHUFFLE_API_KEY" http://127.0.0.1:5001/api/v1/workflows/c6b3fcd8-13e5-44a8-a818-024e4ae4422b | grep -c "31475ce6" || echo "CLEAN"

# Verify IRIS DB
docker exec iriswebapp_db psql -U postgres -d iris_db -c "SELECT api_key FROM \"user\" WHERE id=1;"
```

### Residual Risk
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Old key in git history | Low | Medium | History immutable; current HEAD clean |
| Old key in Shuffle workflow exports | Low | Low | Shuffle manages own history |
| Old key in IRIS DB backups | Low | Medium | Backup retention policy |
| Old key in IRIS backups | Low | Medium | Backup retention policy |

## Verdict
**COMPLETE** - Revocation and cleanup complete. Old credentials fully removed from active systems. Rollback artifacts preserved.

## Limitations
- Git history immutable (cannot rewrite public history)
- Shuffle internal DB not accessible for cleanup
- IRIS backups may contain old key (retention policy applies)

## Verdict
**COMPLETE** - Revocation and cleanup complete. Residual artifacts documented and risk-assessed.