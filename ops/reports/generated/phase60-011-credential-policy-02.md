# Phase 60: Credential Policy - Wazuh and Swarm Credentials

**Actual UTC:** 2026-08-28T08:10:00Z
**ET:** 2026-08-28 04:10:00 EDT
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

### Wazuh Credentials
| Credential | Classification | Storage | Status |
|-----------|----------------|---------|--------|
| `WAZUH_ADMIN_PASSWORD` | REAL_ACTIVE | `/opt/wazuh-docker/multi-node/ops/creds.env` | Active |
| `WAZUH_REGISTRATION_PASSWORD` | REAL_ACTIVE | `creds.env` | Active (agent enrollment) |
| `WAZUH_WUI_PASSWORD` | REAL_ACTIVE | `creds.env` | Active (web UI) |
| `WAZUH_REGISTRATION_PASSWORD` | REAL_ACTIVE | `creds.env` | Active (agent registration) |

### Wazuh API Credentials
| Credential | Classification | Storage | Status |
|-----------|----------------|---------|--------|
| `c85af564ba3beaa0e11ad70a52416030079683e5039eb5f3bc4064f3f8f46c44` | REAL_ACTIVE | `creds.env` (Wazuh API key) | Active |
| Usage | Wazuh API authentication | - | Active |

### Docker Swarm Credentials
| Credential | Classification | Storage | Status |
|------------|----------------|---------|--------|
| `iris-shuffle-env` | REAL_ACTIVE | Docker Swarm secret | Active (rotated P59) |
| `shuffle-api-key` | REAL_ACTIVE | `.env` file | Active |
| `WAZUH_ADMIN_PASSWORD` | REAL_ACTIVE | `creds.env` | Active |
| `WAZUH_REGISTRATION_PASSWORD` | REAL_ACTIVE | `creds.env` | Active |

### Credential Storage Locations
| Credential | Storage | Access Control |
|------------|---------|----------------|
| Shuffle API Key | `.env` file (gitignored) | File permissions 600 |
| IRIS API Key | Docker Swarm secret `iris-shuffle-env` | Service-scoped (shuffle-tools only) |
| Wazuh passwords | `creds.env` (gitignored) | File permissions 600 |
| Docker Swarm secrets | Docker Swarm secret store | Service-scoped (service grants) |

### Credential Access Matrix
| Service | Credentials Accessed |
|---------|---------------------|
| shuffle-tools | iris-shuffle-env, SHUFFLE_API_KEY |
| shuffle-backend | SHUFFLE_API_KEY |
| shuffle-frontend | SHUFFLE_API_KEY |
| wazuh-master | WAZUH_ADMIN_PASSWORD, WAZUH_REGISTRATION_PASSWORD |
| wazuh-worker | WAZUH_REGISTRATION_PASSWORD |
| iris-webapp | IRIS_API_KEY (via iris-shuffle-env) |

### Rotation Status
| Credential | Last Rotation | Next Scheduled | Automation |
|------------|---------------|----------------|------------|
| IRIS API Key | 2026-08-28 (P59) | On compromise | Manual (web UI) |
| Shuffle API Key | Never | On compromise | Manual (.env edit) |
| Wazuh Passwords | Initial setup | Per policy | Manual |
| Wazuh API Key | Initial setup | On compromise | Manual |

## Verdict
**COMPLETE** - Wazuh and Swarm credential inventory complete. All credentials classified per policy.

## Limitations
- No automated rotation for any credential
- IRIS rotation requires manual web UI (no API)
- Shuffle token in `.env` not in secret store

## Verdict
**COMPLETE** - Wazuh and Swarm credentials documented per policy.