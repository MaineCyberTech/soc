# MISP + Greenbone Deployment — mct-soc-scan (2026-08-10)

## MISP — DEPLOYED, OPERATIONAL

- URL: https://192.168.222.154:8443 (loopback on VM; SSH tunnel from Wazuh host: `ssh -L 8443:127.0.0.1:8443 mct-soc-scan`)
- Login: admin@mct.local / MISP_ADMIN_PASSWD (VM .env, mode 600)
- Containers (4): misp-core, misp-modules, misp-db (mariadb 10.11), misp-redis (valkey 7.2)
- Verified: login page 200, heartbeat 200, all containers healthy
- Images: ghcr.io/misp/misp-docker/misp-core|modules:latest (Docker Hub `misp/misp-docker` no longer exists)

## Greenbone — DEPLOYED, FEED SYNC IN PROGRESS

- URL: https://127.0.0.1:443 / http://127.0.0.1:9392 on the VM (loopback; SSH tunnel for admin)
- Login: admin / GREENBONE_ADMIN_PASSWORD (VM .env)
- Containers (20): official registry.community.greenbone.net stack (gvmd, gsa, gsad, nginx, openvasd, ospd-openvas, pg-gvm, redis, gvm-tools, feed containers)
- Verified: nginx 200 on both ports; admin user exists with new password
- Feed sync: CERT succeeded; SCAP/VT import still running (expected 30-60 min)

## Issues fixed during deployment

1. `misp/misp-docker` image gone → official ghcr.io images + valkey instead of redis image
2. misp-db/redis missing healthchecks → added (misp-core depends on service_healthy)
3. misp-modules crash: NumPy built for X86_V2 (AVX) — VM had default `kvm64` CPU → `qm set 103 --cpu host` (PVE host has avx2) + VM reboot
4. Redis healthcheck needed the password as a container env var
5. `greenbone/greenbone-community-container` image gone → official 20-container compose from greenbone docs
6. Official compose's 9392 listener 301-redirects to https://443 → re-added `127.0.0.1:443:443` loopback mapping
7. MISP_BASEURL must include `:8443` (was https://192.168.222.154 without port)

## VM state

- 24 containers total (4 MISP + 20 Greenbone), ~1.9G used of 3.8G (balloon can grow to 6G)
- PVE node: 30.2G/31.9G used, 1.6G free + 8G swap — tight but stable; monitor before adding more
- SSH: root@192.168.222.154 via ~/.ssh/mct_soc_scan key

## Next steps

1. Wait for Greenbone feed sync to finish, then run the non-invasive scan config creation + first test scan
2. Create MISP organizations/tags per phase 06 spec, generate API key for integrations
3. Wire integrations: MISP API key + Greenbone webhook → Shuffle (on Wazuh host, next deployment wave)
