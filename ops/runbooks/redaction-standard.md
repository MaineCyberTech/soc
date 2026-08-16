# Redaction Standard

Applies to any doc, report, screenshot, or artifact leaving the host or shared via chat.

## Placeholders

| Original | Replace with |
|---|---|
| Any password / API key / token | `<REDACTED_PASSWORD>` / `<REDACTED_TOKEN>` / `<REDACTED_API_KEY>` |
| Wazuh/IRIS/MISP admin passwords | `<REDACTED_PASSWORD>` |
| Cloudflare tunnel token | `<REDACTED_TOKEN>` |
| DO Spaces keys | `<REDACTED_ACCESS_KEY>` / `<REDACTED_SECRET_KEY>` |
| Internal hostnames/IPs that reveal infrastructure | `<REDACTED_HOST>` (keep site/network labels) |
| SSH/API usernames when combined with passwords | `<REDACTED_USERNAME>` |
| Auth URLs containing credentials | `<REDACTED_URL>` |

## Rules

1. When showing a config value, replace the value, keep the key name: `WAZUH_ADMIN_PASSWORD=<REDACTED_PASSWORD>`.
2. Do not redact plain hostnames used as public references (e.g., 192.168.x.x site addresses in inventory docs) unless the doc is client-facing; for client docs use `<REDACTED_HOST>`.
3. Keep operational usefulness: rule IDs, index names, port numbers, and service names stay.
4. `.env.example` files must contain only `<REDACTED_*>` or clearly non-secret defaults.

## Pre-share checklist

- [ ] grep for `[Pp]assword\s*=`, `[Kk]ey\s*=`, `[Tt]oken\s*=`, `api[_-]?key` and verify values are placeholders
- [ ] No base64 blobs that could be credentials remain
- [ ] `.env` and `creds.env` are not in the shared bundle
- [ ] Screenshots do not show URL query strings with auth params

## Safe command wrapper rule

Never `echo` variables from sourced env files (`creds.env`, `.env`) - shell history and logs may persist.

```bash
set -a; source /opt/wazuh-docker/multi-node/ops/creds.env; set +a
curl -sk -u "admin:${WAZUH_ADMIN_PASSWORD}" https://127.0.0.1:9200/_cluster/health
# never: echo "${WAZUH_ADMIN_PASSWORD}"  or  printenv | grep WAZUH
```

Pass values by environment or file descriptor, never as an argument visible in `ps` or history.

## Public-safe redacted operations document (template)

Any doc that may leave the host (client packet, support ticket, demo) must follow this shape:

```markdown
# MCT Security Operations - [SITE/CLIENT]
## Overview
- Wazuh 4.14.7 multi-node (indexer x3, master + worker, dashboard)
- Deception: OpenCanary + Canarytokens
- SOAR: Shuffle (alert routing to IRIS, manual approval only)
- IR: DFIR-IRIS case management
- Intel: MISP (CDB export to Wazuh)
- Vuln: Greenbone OpenVAS scanning
- EDR: Velociraptor (deployed clients only)
- Network: ElastiFlow flow analysis

## Credential inventory (status only - NO VALUES)
| Service | User/role | Status | Location |
|---|---|---|---|
| Wazuh | admin | ROTATED | <REDACTED_PATH> |
| IRIS | admin | NEEDS_ROTATION | <REDACTED_PATH> |
| MISP | admin | NEEDS_ROTATION | <REDACTED_PATH> |

## Access summary
| Service | Bind/URL | Auth model |
|---|---|---|
| Wazuh dashboard | Cloudflare Access | SSO + admin |
| Wazuh API | 127.0.0.1:55000 | user/pass |
| IRIS | 127.0.0.1:8443 | user/pass + API key |
| Shuffle | 127.0.0.1:3001 | admin/API |

## Controls
- Secrets stored only in 0600 files (creds.env / .env), never in docs.
- No destructive SOAR actions without manual approval.
- Wazuh 9200/55000 never exposed publicly.
```

Full values live ONLY in 0600 secret files; the public-safe doc keeps key names and status.

## Automated check

```bash
grep -rniE '(password|secret|token|api[_-]?key)\s*[:=]\s*[^<\s<]' /opt/mct-security-stack --include='*.md' --include='*.yml' --include='*.json' | grep -v '<REDACTED'
```

Any hit must be fixed before sharing. For a deeper scan use:

```bash
/opt/mct-security-stack/ops/scripts/scan-docs-for-secret-patterns.sh
```
