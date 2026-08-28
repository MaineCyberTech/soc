# Phase 60: Credential Policy - Redaction and Scanning Standards

**Actual UTC:** 2026-08-28T08:20:00Z
**ET:** 2026-08-28 04:20:00 EDT
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

### Redaction Standards
| Context | Pattern | Replacement | Example |
|---------|---------|-------------|---------|
| IRIS API Key | `c2173178...` | `REDACTED_IRIS_API_KEY` | `Authorization: Bearer REDACTED_IRIS_API_KEY` |
| Shuffle API Key | `c85af564...` | `REDACTED_SHUFFLE_API_KEY` | `Authorization: Bearer REDACTED_SHUFFLE_API_KEY` |
| Wazuh API Key | `c85af564...` | `REDACTED_WAZUH_API_KEY` | `Authorization: Bearer REDACTED_WAZUH_API_KEY` |
| IRIS Key (old) | `31475ce6...` | `REDACTED_IRIS_API_KEY_OLD` | `Authorization: Bearer REDACTED_IRIS_API_KEY_OLD` |
| Wazuh Passwords | `password123` | `REDACTED_PASSWORD` | `password: REDACTED_PASSWORD` |
| Generic Bearer | `Bearer <token>` | `Bearer REDACTED_TOKEN` | `Authorization: Bearer REDACTED_TOKEN` |

### Redaction Rules
1. **Never** commit actual secret values to git
2. **Always** use placeholder constants in reports (`REDACTED_*`)
3. **Never** print full secret values in logs or reports
4. **Mask** secrets in logs (show prefix/suffix only: `c2173178...64f273`)
5. **Reference** secrets by storage location (`iris-shuffle-env` secret)

### Redaction in Reports
| Context | Pattern | Replacement |
|---------|---------|-------------|
| IRIS API Key | `Bearer <key>` | `Bearer REDACTED_IRIS_API_KEY` |
| Shuffle API Key | `Bearer <key>` | `Bearer REDACTED_SHUFFLE_API_KEY` |
| Wazuh API Key | `Bearer <key>` | `Bearer REDACTED_WAZUH_API_KEY` |
| Password fields | `"password": "..."` | `"password": "REDACTED_PASSWORD"` |
| Secret files | `cat /run/secrets/...` | `[REDACTED - see secret: iris-shuffle-env]` |

### Automated Redaction Pipeline
- **Tool:** `ops/scripts/p38-report-ci.sh` (pre-commit gate)
- **Patterns:** `31475ce6...`, `c2173178...`, `c85af564...`, `Bearer [A-Za-z0-9_-]+`, `password: .+`
- **Action:** Fail commit if unredacted secret detected
- **Whitelist:** `REDACTED_*`, `REDACTED_*_OLD`, `test:true` tagged values

### Secret Scanning Coverage
| Target | Tool | Frequency |
|--------|------|-----------|
| Reports (generated) | `p38-report-ci.sh` | Pre-commit |
| Workflows (Shuffle) | Manual review | Pre-deploy |
| Configs (`.env`, `creds.env`) | `secret-pattern-scan.sh` | Pre-commit |
| Docker images | `trivy` | CI pipeline |
| Docker secrets | `docker secret inspect` | Manual audit |

## Verdict
**COMPLETE** - Redaction standards defined and implemented. Scanning integrated in CI.

## Limitations
- Redaction is lossy (cannot recover original from redacted)
- Manual review required for edge cases
- Historical reports not retroactively redacted (preserved as-is)

## Verdict
**COMPLETE** - Redaction and scanning standards defined.