# Phase 15 Container Image Inventory

Date: 2026-08-16

## Running images by stack (count)

| Stack | Running containers | Notes |
|---|---|---|
| Wazuh (master/worker/indexers/dashboard) | 8 | versions pinned by wazuh-docker |
| Shuffle | 13 | includes workers/subflows/ai |
| DFIR-IRIS | 5 | app/db/nginx/worker |
| ElastiFlow | 1 | flow-collector |
| OpenCanary | 1 | thinkst/opencanary |
| Greenbone (VM103) | 19 | community registry |
| MISP (VM103) | 2 | misp-core + nginx |
| Cloudflared | 1 | tunnel |

## Tag status

- Pinned/versioned: opensearch 3.2.0, mariadb 10.11, postgres 16-alpine,
  redis 7-alpine, valkey 7.2, alpine 3.20, wazuh images.
- `latest` (needs pin): IRIS, MISP, Shuffle, OpenCanary, velociraptor.
- stable-slim/stable (greenbone): semi-pinned.

## No secrets
