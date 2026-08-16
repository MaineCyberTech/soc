# Phase 7 Blocker Status

Date: 2026-08-12

| # | Blocker | Owner | Status | Next action | Manual bypass |
|---|---|---|---|---|---|
| B1 | PVE API 401 | host operator | OPEN | Refresh PVE password/API token/SSH key in creds.env | pve-api-repair.md (3 paths) |
| B2 | VM101 RAM (9 GiB, swap 4.8G) | host operator | OPEN | qm set 101 --memory 16384 (needs B1 or console) | PVE console manually |
| B3 | P1 credential rotation | host operator | DEFERRED | Supply new values in protected files | one-at-a-time rotation runbook |
| B4 | Greenbone GMP CLI on VM103 | VM103 operator | OPEN | Install greenbone-common-tools or use GSA UI | GSA web UI (admin pw in .env) |
| B5 | Canarytokens service | host operator | OPEN | Choose hosted vs self-hosted | canarytokens.org account |
| B6 | Windows endpoint availability | host operator | OPEN | Provision Win11 VM (needs B1) or provide endpoint | existing Windows device |
| B7 | macOS endpoint availability | host operator | OPEN | Provide test Mac (Intel/ARM) | n/a |
| B8 | Linux pilot target | host operator | PARTIAL | This host (docker-host) can serve as pilot target | local install simulation |
| B9 | Velociraptor GUI admin password | host operator | OPEN | velociraptor user set_password admin | CLI (root) |
| B10 | DR scratch execution | host operator | DEFERRED | Needs RAM headroom (B2) | run on other host |

## Resolved (verified this phase)

- Velociraptor 8002 client path: WORKING (2 clients enrolled)
- Endpoint kit: complete + audited (10 files)
- Registration password: enforced (public enrollment secure)
- Backup cron: installed (scheduled-run proof pending 04:30 UTC)

## Note

- creds.env mtime updated 2026-08-12 (registration password added Phase 6) -
  no new P1 rotation values.
