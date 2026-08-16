# Phase 2 Services Deployment Report — 2026-08-10 17:05 UTC

All planned services are now DEPLOYED and verified.

## Deployment summary

| Service | Host | Endpoint | Status |
|---|---|---|---|
| OpenCanary | Wazuh host (172.18.0.10) | canary ports 21/23/3306/1433/9100/8008 | RUNNING — syslog → Wazuh verified |
| Shuffle SOAR | Wazuh host | http://127.0.0.1:3001 (UI), :5001 (API) | RUNNING + CONFIGURED — org/admin registered 2026-08-10 (users + environments indices present) |
| DFIR-IRIS | Wazuh host | https://127.0.0.1:8443 | RUNNING — admin pw saved (600) |
| Velociraptor | Wazuh host (systemd) | https://127.0.0.1:8889 | RUNNING — admin user created |
| MISP | mct-soc-scan (192.168.222.154) | https://127.0.0.1:8443 (VM) | RUNNING — orgs + 17 tags + API key created |
| Greenbone | mct-soc-scan (192.168.222.154) | https://127.0.0.1:443 / http://:9392 (VM) | RUNNING — feed synced (184,646 NVTs), test scan DONE |

## Key facts per service

### OpenCanary
- thinkst/opencanary:latest, config in data/opencanary/opencanary.conf (syslog JSON → master)
- FIX: joined container to `multi-node_default` network + added `172.18.0.0/24` to the master's syslog `allowed-ips` (backup: ops/backups/wazuh_manager.conf-*.bak); the container's own 127.0.0.1 is not the host
- Verified: telnet hit → event in master's archives.log (location 172.18.0.10)

### Shuffle
- Official 4-container stack (ghcr.io/shuffle/shuffle-{frontend,backend,orborus} + opensearch 3.2.0)
- FIX: `frikky/shuffle` image gone; sqlite mode removed in current version → added OpenSearch with heap tuned 768m (official default 3G), security plugin disabled (internal-only)
- Workers auto-spawn (shuffle-workers, shuffle-tools, etc.)
- PENDING: first-login org/user creation via UI at :3001

### DFIR-IRIS
- v2.4.29 from iris-web repo (no prebuilt docker hub image; ghcr images used, no build needed)
- Port adapted to 127.0.0.1:8443 (loopback); services: app, worker, nginx, db, rabbitmq
- Admin password saved to ops/backups/iris-admin-pw.txt (mode 600)

### Velociraptor
- No official docker image anymore → binary v0.77.2 at /usr/local/bin/velociraptor, systemd unit (enabled, MemoryMax 1G)
- Config: data/velociraptor/server.config.yaml (GUI 127.0.0.1:8889, frontend 0.0.0.0:8000)
- admin user created (VELOCIRAPTOR_ADMIN_PASSWORD from .env)

### MISP
- Official ghcr misp-core/misp-modules images; DB+valkey; BASE_URL https://192.168.222.154:8443
- Organizations created: Maine Cyber Tech Internal (existing), Client North Parish, Client Long Beach Marina, Client Generic MSP
- 17 tags created (source:*, confidence:*, action:*, client:*, type:*)
- API key generated + stored: ops/backups/misp-api-key.txt (mode 600, 40-char)
- FIX: VM CPU → host (AVX2 needed by numpy in misp-modules)

### Greenbone
- Official 20-container stack, feed synced (Full and fast = 184,646 NVTs)
- Test scan PASSED: target MCT-Wazuh-host-149 (192.168.222.149), task MCT-Test-Discovery-149 (Discovery config), 25 min runtime, informational results only (severity 0.0)
- gvm-cli usage documented in greenbone-openvas.md

## Memory status

- Wazuh host: 864M available + 8G swap (4.8G free) — tight; Shuffle OpenSearch + workers are the main consumers
- mct-soc-scan VM: 2.3G available of 3.8G (balloon can grow to 6G)

## Remaining items (next session)

1. OpenSearch Alerting webhook destinations → Shuffle (create webhook triggers in Shuffle, wire the 5 monitors)
2. Wazuh-side additive files (opencanary decoder/rules) — operator approval still required
3. OpenCanary test event → IRIS case path (via Shuffle workflow `opencanary-hit-to-case`)
4. Sysmon pilot on a Windows endpoint
5. Schedule Greenbone weekly scans + credentialed configs
6. Credential rotation (checklist delivered)
7. Shuffle note: frontend nginx caches the backend IP — if the backend container ever restarts, `docker restart shuffle-frontend` (documented fix for the "Waiting for the Shuffle database" screen)
