# Phase 37 — Security Audit

**Timestamp:** 2026-08-25T19:30Z
**Report ID:** P37-68
**Classification:** Internal

---

## Identities

| Identity | Platform | Role |
|----------|----------|------|
| soc@mainecybertech.com | Shuffle | Admin |
| admin | Wazuh | Admin |
| admin | OpenSearch | Admin |

## Privileges

| Identity | Wazuh | OpenSearch | Shuffle |
|----------|-------|------------|---------|
| admin | Full | Full | Full |

## Credentials

| System | Credential Source | Rotation Status |
|--------|------------------|-----------------|
| Shuffle | creds.env | Rotated |
| Wazuh | creds.env | Managed |
| OpenSearch | creds.env | Managed |

## Listeners

| Listener | Bind | TLS | Auth | Risk |
|----------|------|-----|------|------|
| Shuffle Frontend | 0.0.0.0:3001 | No | Bearer token | HIGH — plaintext on all interfaces |
| Wazuh Dashboard | 127.0.0.1:443 | Yes | Session | Low — localhost only |

## TLS Coverage

- Wazuh Dashboard: TLS enabled
- Shuffle: No TLS — plaintext HTTP

## Rules and Licenses

| Rule Set | Active Rules | Status |
|----------|-------------|--------|
| ET Open | 549 | Active |

## Image Digests

- All container image pins verified
- No unverified images in use

## Cache

- Standard caching behavior
- No custom cache configuration

## Provenance

- Release v1.3.0 published
- Tag: 790968b8
- Deployability: PARTIAL
- SO: RETIRED

## Workflow Authentication

- Bearer token authentication on Shuffle backend
- Token managed via creds.env

## Datastore Access

- Shuffle OpenSearch: no authentication plugin enabled
- OpenSearch accessible without auth from Shuffle backend

## State Files

- /tmp: 1.6GB/7.6GB (21%)
- Cron cleanup at 03:00 UTC active
- No stale state files detected

## Synthetic Isolation

- Packet workflow isolation: design only
- No production synthetic isolation implemented

## Secrets

- No secrets committed to repository
- Credentials stored outside version control

## Assessment

| Area | Status |
|------|--------|
| TLS Coverage | PARTIAL — dashboard only |
| Shuffle Exposure | NEEDS HARDENING |
| Credential Rotation | OK |
| Image Verification | PASS |
| OpenSearch Auth | NOT CONFIGURED |

## No secrets
