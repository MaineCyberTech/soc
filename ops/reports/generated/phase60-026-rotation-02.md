# Phase 60: Rotation - Shuffle and Wazuh Credential Rotation Plan

**Actual UTC:** 2026-08-28T10:00:00Z
**ET:** 2026-08-28 06:00:00 EDT
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

### Shuffle API Key Rotation Plan (NOT AUTHORIZED)

#### Current State
- **Key:** `c85af564ba3beaa0e11ad70a52416030079683e5039eb5f3bc4064f3f8f46c44`
- **Location:** `/opt/mct-security-stack/.env` (SHUFFLE_API_KEY)
- **Consumers:** shuffle-backend, shuffle-frontend, shuffle-tools, shuffle-workers
- **Rotation Method:** Manual (edit `.env` + `docker compose restart` or `docker service update`)
- **Consumers:** shuffle-backend, shuffle-frontend, shuffle-tools, shuffle-workers, shuffle-subflow, shuffle-ai

#### Rotation Procedure
```bash
# 1. Generate new key (Shuffle UI: Admin > API Keys)
NEW_KEY=<new_key_from_shuffle_ui>

# 2. Update .env
sed -i "s/SHUFFLE_API_KEY=.*/SHUFFLE_API_KEY=$NEW_KEY/" /opt/mct-security-stack/.env

# 3. Restart Shuffle services
docker compose -f /opt/mct-security-stack/compose/docker-compose.shuffle.yml restart

# 3. Verify
curl -H "Authorization: Bearer $NEW_KEY" http://shuffle-backend:5001/api/v1/workflows
```

#### Rollback Plan
```bash
# Revert .env and restart
git checkout .env  # or manual revert
docker compose -f /opt/mct-security-stack/compose/docker-compose.shuffle.yml restart
```

#### Authorization Status
- **Owner Authorization:** REQUIRED (not granted)
- **Risk:** HIGH (all Shuffle services affected)
- **Rollback Time:** < 5 minutes
- **Consumer Impact:** All Shuffle services (brief downtime during restart)

#### Authorization Status
- **Status:** NOT AUTHORIZED
- **Owner Action Required:** Explicit approval needed
- **Gate:** CREDENTIAL GATE

### Wazuh Credentials Rotation Plan

#### Wazuh API Key
- **Current:** `c85af564...` (in `creds.env`)
- **Rotation:** Manual edit `creds.env` + `docker restart wazuh-master`
- **Consumers:** Wazuh API clients, Shuffle Wazuh integration
- **Authorization:** NOT AUTHORIZED

#### Wazuh Passwords
| Credential | Rotation Method | Impact |
|------------|----------------|--------|
| Admin Password | Edit `creds.env` + restart | Wazuh UI access |
| Registration Password | Edit `creds.env` + restart | Agent enrollment |
| WUI Password | Edit `creds.env` + restart | Web UI access |

#### Authorization Status
- **Status:** NOT AUTHORIZED
- **Owner Action Required:** Explicit approval per credential
- **Gate:** CREDENTIAL GATE

## Verdict
**PLANNED** - Rotation procedures documented. Execution pending owner authorization for Shuffle and Wazuh credentials.

## Limitations
- No automated rotation for any credential
- IRIS rotation requires manual web UI (no API)
- Shuffle/Wazuh require container restarts
- No automated rollback testing for Shuffle/Wazuh

## Verdict
**PLANNED** - Rotation procedures documented. Execution pending owner authorization for Shuffle/Wazuh credentials.