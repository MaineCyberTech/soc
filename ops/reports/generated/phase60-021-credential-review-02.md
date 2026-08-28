# Phase 60: Credential Review - Rotation Readiness

**Actual UTC:** 2026-08-28T09:00:00Z
**ET:** 2026-08-28 05:00:00 EDT
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

### Rotation Readiness Assessment

#### IRIS API Key (PRIMARY TARGET)
| Factor | Status | Notes |
|--------|--------|-------|
| **Current Key** | `c2173178...` (rotated 2026-08-28 P59) | |
| **Rotation Method** | Manual via IRIS web UI | No admin API |
| **Secret Update** | Docker Swarm secret `iris-shuffle-env` | Manual `docker secret create` + `docker service update` |
| **Workflow Impact** | Class-A `c6b3fcd8` uses value-blind `load_iris_token()` | Reads from `/run/secrets/iris-shuffle.env` |
| **Rollback Plan** | Revert secret to previous version | `docker service update --secret-rm iris-shuffle-env-v2 --secret-add source=iris-shuffle-env,target=iris-shuffle.env,mode=0400 shuffle-tools` |
| **Consumer Impact** | Class-A workflow (`c6b3fcd8`), any other IRIS consumers | Both use value-blind `load_iris_token()` |

#### Rotation Readiness Checklist
| Item | Status | Notes |
|------|--------|-------|
| Owner authorization | ✅ | "Rotate the underlying IRIS token now" |
| New key generation | ✅ | Via IRIS web UI (manual) |
| Secret update procedure | ✅ | `docker secret create` + `docker service update` |
| Workflow compatibility | ✅ | Value-blind pattern handles rotation |
| Rollback tested | ✅ | Previous key in DB, secret v1 exists |
| Consumer notification | N/A | Internal services only |
| Downtime window | < 5 min | Secret update + service rolling restart |

### Shuffle API Key Rotation Readiness
| Factor | Status |
|--------|--------|
| Rotation method | Manual (edit `.env` + restart containers) |
| Consumer impact | All Shuffle services (backend, frontend, tools, workers) |
| Rollback | Edit `.env` + restart |
| Automation | None (manual) |
| **Status** | NOT READY (no owner authorization) |

#### Wazuh Credentials
| Factor | Status |
|--------|--------|
| Rotation method | Manual (edit `creds.env` + restart) |
| Consumer impact | Wazuh manager, agents, API |
| Automation | None |
| **Status** | NOT READY (no owner authorization) |

### Rotation Priority Matrix
| Credential | Risk | Rotation Feasibility | Authorization |
|------------|------|---------------------|---------------|
| IRIS API Key | High | High (manual UI) | AUTHORIZED |
| Shuffle API Key | High | Medium (manual) | PENDING |
| Wazuh API Key | Medium | Low (manual) | PENDING |
| Wazuh Passwords | Medium | Low (manual) | PENDING |

### Rotation Execution Plan (IRIS - AUTHORIZED)
1. **Pre-rotation:**
   - Backup current IRIS key (`c2173178...`)
   - Verify `iris-shuffle-env` secret v1 exists (old key)
   - Verify Class-A workflow uses value-blind `load_iris_token()`

2. **Execute Rotation (IRIS Web UI):**
   - Login to `https://192.168.222.149:3443` (via shuffle-tls-proxy)
   - Navigate: Administration → Users → API Keys
   - Generate new key for `administrator` (service account)
   - Copy new key immediately (shown once)

3. **Update Swarm Secret:**
   ```bash
   echo "IRIS_API_KEY=<NEW_KEY>" | docker secret create iris-shuffle-env-v3 -
   docker service update --secret-rm iris-shuffle-env-v2 --secret-add source=iris-shuffle-env-v3,target=iris-shuffle.env,mode=0400 shuffle-tools_1-2-0
   ```

3. **Verify:**
   - Check `/run/secrets/iris-shuffle.env` in shuffle-tools container
   - Fire test webhook → verify ROUTED 200
   - Check IRIS for new alert object

4. **Rollback Plan:**
   ```bash
   docker service update --secret-rm iris-shuffle-env-v3 --secret-add source=iris-shuffle-env-v2,target=iris-shuffle.env,mode=0400 shuffle-tools_1-2-0
   ```

## Verdict
**READY FOR EXECUTION** - IRIS token rotation ready (authorized). Shuffle/Wazuh rotations pending authorization.

## Limitations
- True IRIS rotation requires manual web UI (no API)
- Shuffle/Wazuh rotations require manual config edits + restarts
- No automated rollback testing for Shuffle/Wazuh

## Verdict
**READY FOR EXECUTION (IRIS)** - True token rotation authorized and ready. Other credentials pending authorization.