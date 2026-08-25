# Phase 37 — Release Assurance (v1.3.0)

**Timestamp:** 2026-08-25T19:30Z
**Report ID:** P37-79
**Classification:** Internal

---

## Release

| Property | Value |
|----------|-------|
| Version | v1.3.0 |
| Tag | 790968b8 |
| Status | Published |
| Deployability | PARTIAL |
| SO | RETIRED |

## Image Pins

| Image | Pin | Verified |
|-------|-----|----------|
| Wazuh manager | Verified | Yes |
| Wazuh indexer | Verified | Yes |
| Wazuh dashboard | Verified | Yes |
| Shuffle frontend | Verified | Yes |
| Shuffle backend | Verified | Yes |
| Shuffle opensearch | Verified | Yes |
| IRIS | Verified | Yes |
| Portainer | Verified | Yes |
| Cloudflared | Verified | Yes |

All image digests verified against expected pins.

## Manifests

| Manifest | Status |
|----------|--------|
| Docker Compose | Consistent |
| Workflow exports | Available |
| Config files | Consistent |

No manifest drift detected.

## Configurations

| Config | Status | Notes |
|--------|--------|-------|
| local_internal_options.conf | Staged | decoder_order_size=512, not in release |
| ossec.conf | Active | In release |
| creds.env | Managed | Outside repo |

## Rules

| Rule Set | Active | Status |
|----------|--------|--------|
| ET Open | 549 | Active and functional |

## Workflow Exports

- Reference: P37-10
- 2 workflows exported
- Exports available in ops/evidence/

## Alerts

- Alert flow: ACTIVE
- Agent 016: 1,095 Suricata alerts today
- Field errors: ~100/min (known issue)

## Routes

- Production routes: 0
- Routing: NOT CONFIGURED

## Dashboards

- Custom dashboards: None
- Default Wazuh dashboards: Present

## Documentation

- All Phase 37 reports current
- Exports indexed
- Client-safe summary available (P37-62)

## Sensitive Files

| Check | Result |
|-------|--------|
| Secrets in source | None |
| API keys committed | None |
| Credentials in repo | None |
| .env files committed | None |

No sensitive files committed to repository.

## Release Assurance Summary

| Criterion | Status |
|-----------|--------|
| Image pins verified | PASS |
| Manifests consistent | PASS |
| Configs correct | PASS |
| Rules active | PASS |
| Alerts flowing | PASS |
| Docs current | PASS |
| No secrets | PASS |
| Field errors | KNOWN ISSUE |
| Routing | NOT CONFIGURED |

## Recommendation

v1.3.0 release is assured for detection and indexing services. Routing and automation features are not included in this release. Field cardinality errors are a known issue to be resolved in Phase 38.

## No secrets
