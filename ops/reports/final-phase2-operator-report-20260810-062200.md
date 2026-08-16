# Final Phase 2 Operator Report — 2026-08-10 06:22 UTC

## Executive summary

The phase 2 build-out plan is complete as a fully documented, deployable, additive stack at `/opt/mct-security-stack`. The existing Wazuh multi-node stack was verified healthy before and after (cluster green, all 13 containers up, API/indexer still localhost-only, backups running). No existing volumes were touched. Seven service families are planned with compose files, runbooks, health checks, acceptance tests, and rollback paths; none were started on this pass due to the host's limited free RAM (~1.6 GB) — deployment of the heavy services (MISP, Greenbone) requires a dedicated VM per the runbooks.

## Baseline state before changes

- Debian 13 (trixie) KVM host "docker", Docker 29.7.2, Compose v5.4.0
- Wazuh 4.14.7 multi-node: master, worker, 3 indexers, dashboard, nginx LB, cloudflared — cluster green (3/3 nodes, 139 shards)
- Elastiflow indexing (~900k flow docs), flow-relay active
- Security Onion reachable at 192.168.222.116
- Custom UniFi/flow/app rules (100001+) and decoders in local_rules.xml / local_decoder.xml
- 13 containers running; indexer 9200 and Wazuh API 55000 localhost-only (unchanged)
- Pre-existing public ports noted: 22, 514, 1515, 19999, 8000/9443 (Portainer), 5355
- Backups: /opt/wazuh-backups config tarballs (daily), S3 snapshot + DR crons running

## Components added

| Component | Compose | Runbook | Status |
|---|---|---|---|
| Base layout + network + health-check framework | docker-compose.phase2.yml | README, phase2-* | READY (network defined, no services started) |
| DFIR-IRIS case management | docker-compose.dfir-iris.yml | dfir-iris.md, incident-triage.md | PLANNED (compose validated) |
| Velociraptor endpoint DFIR | docker-compose.velociraptor.yml | velociraptor.md + 2 rollout runbooks | PLANNED (compose validated) |
| MISP threat intel | docker-compose.misp.yml | misp.md | PLANNED — recommend dedicated VM |
| Shuffle SOAR | docker-compose.shuffle.yml | shuffle.md | PLANNED (compose validated) |
| Sysmon Windows endpoint pack | — (config pack) | windows-endpoint-onboarding.md | DOCUMENTED (additive XML, rule/dashboard plans, test events) |
| Greenbone/OpenVAS | docker-compose.greenbone.yml | greenbone-openvas.md | PLANNED — recommend dedicated VM |
| OpenCanary deception | docker-compose.opencanary.yml | opencanary.md | PLANNED (compose validated) |
| Alert routing A-D | — | alert-routing.md | DOCUMENTED (5 existing monitors routed) |
| Client reporting | — | client-reporting.md | WORKING (sample scorecard generated) |
| Backup/DR/rollback | — | phase2-backup/restore/rollback + DR addendum | READY (config backup tested) |

## Components deferred

- Service activation (any `docker compose up`) — deferred for RAM headroom; see "Exact next operator actions".
- Wazuh-side changes (opencanary decoder/rules, MISP CDB list, Sysmon rules) — planned XML files exist but are NOT deployed (additive and tested-first policy).
- Credential rotation — checklist delivered, rotations PENDING (below).
- Canarytokens self-hosted deployment — documented, not deployed.
- OpenSearch Alerting destinations — documented placeholders; webhook/email destinations not yet configured (need service URLs + secret-store values).
- Greenbone/GSA + MISP on-host install — deferred to dedicated VMs (memory).

## Ports and exposure

- No new ports are open yet (no services started).
- Planned: 3001 Shuffle, 8000 IRIS, 8089/8889 Velociraptor, 8443 MISP, 9392 Greenbone — all 127.0.0.1 only; remote via Cloudflare Access.
- Verified unchanged: indexer 9200 and Wazuh API 55000 localhost-only. Port audit script passes.
- Pre-existing exposure noted for review: Portainer 8000/9443, netdata 19999, LLMNR 5355.

## Secrets and credentials needing rotation

Names only (see `ops/runbooks/credential-rotation-checklist.md` for full procedure):

- SUDO_PASSWORD (host) — PENDING
- WAZUH_ADMIN_PASSWORD — PENDING
- Indexer/dashboard service creds (wazuh-local.env) — PENDING
- Wazuh API users — PENDING
- DO_SPACES_ACCESS_KEY / DO_SPACES_SECRET_KEY — PENDING
- VIRUSTOTAL_API_KEY — PENDING
- PVE_USERNAME / PVE_PASSWORD — PENDING
- SO_SSH_USERNAME / SO_SSH_PASSWORD — PENDING
- Cloudflare tunnel token — PENDING if it appears outside host secret store
- All phase 2 secrets (IRIS/MISP/Shuffle/Velociraptor/Greenbone/API keys) — NOT YET CREATED; generate on deployment into the secret store, never into git

## New runbooks (ops/runbooks/)

alert-routing, client-reporting, credential-rotation-checklist, dfir-iris, disaster-recovery-addendum, greenbone-openvas, incident-triage, misp, opencanary, phase2-backup, phase2-restore, phase2-rollback, phase2-validation, redaction-standard, secret-hygiene, shuffle, velociraptor, velociraptor-client-rollout-linux, velociraptor-client-rollout-windows, windows-endpoint-onboarding

## New backups

- `ops/scripts/backup-phase2-config.sh` — tested 2026-08-10 (128 files, mode 600)
- Backup categories + cron examples in `phase2-backup.md`; restore order in `phase2-restore.md`; DR addendum for S3 integration
- Existing Wazuh backups verified still running (config tarball 20260810, snapshot/DR crons)

## New integrations (integrations/)

- integration-matrix.md (11 routes), failure-modes.md, test-events.md
- payload-contracts: wazuh-to-iris, misp-to-wazuh-cdb, so-suricata-alert, velociraptor-evidence, canarytokens-hit, wazuh-to-misp + webhook contracts (wazuh-high-severity, opencanary-hit, greenbone-critical, flow-unknown-exporter)
- Shuffle: 10 workflow specs, approval-gates
- DFIR-IRIS: wazuh-to-iris, case-template-map, 11 case templates
- Velociraptor: wazuh-alert-to-hunt-map (17 hunt categories), dfir-iris-evidence-workflow
- MISP: misp-to-wazuh-cdb, wazuh-to-misp-candidate-ioc, dfir-iris-observable-enrichment + example export script
- OpenCanary: decoder-plan.xml, rules-plan.xml, canarytokens, iris-case-template
- Greenbone: scan-targets, wazuh-vuln-vs-openvas, critical-finding-to-iris
- OpenSearch Alerting: notification-channels, monitor-routing-map (all 5 existing monitors routed A/B/C)
- Sysmon: deployment guide, collection XML (additive), rule plan, dashboard plan, test events
- Wazuh: alert-taxonomy (A-D)

## New alert routes

- Class A: IRIS case + immediate notify (canary hit, unknown exporter, lateral movement, critical internet-facing vuln, C2 signature)
- Class B: IRIS alert + same-day queue (unusual ports, high outbound, ICMP flood, repeated auth failures)
- Class C: daily digest (wan drops, uniFi noise, SCA failures, flow anomaly)
- Class D: archive only
- OpenSearch Alerting webhook/email destinations: documented, configuration pending service deployment

## New reporting outputs

- `reporting/queries/` — 5 valid JSON queries (wazuh-alerts, agent-health, elastiflow-summary, vulnerabilities, sca-failures)
- `reporting/templates/` — client-scorecard, internal-weekly-security-review, vulnerability-summary
- Generator `ops/scripts/generate-scorecard.example.py` — sample mode verified; sample scorecard generated for Client North Parish + MCT Internal

## Validation results

- phase2-healthcheck.sh: PASSED (13 checks, incl. cluster green, API/indexer localhost-only, elastiflow, SO reachable, backups)
- phase2-port-audit.sh: PASSED (all listening ports registered; no unexpected public ports)
- phase2-integration-smoke-test.sh: PASS=3 SKIP=6 FAIL=0 (services not deployed — expected)
- Redaction scan: clean (no real secret values in any phase 2 file)
- Compose validation: base + each service compose config-valid (with placeholder env)

## Known issues

1. Memory: ~1.6 GB free RAM; heavy services (MISP, Greenbone) must run on dedicated VMs.
2. OpenSearch Alerting destinations are documented placeholders — must be configured when Shuffle is deployed.
3. Wazuh-side additive files (opencanary rules/decoder, Sysmon rules, CDB list) are planned only; deployment requires operator approval + validation.
4. Pre-existing exposure (Portainer 8000/9443, netdata 19999, LLMNR 5355) outside phase 2 scope — flagged for remediation decision.
5. Do not print `ops/creds.env` values; rotation checklist is private.

## Rollback plan

- `ops/runbooks/phase2-rollback.md` — stop phase 2 compose services, restore Wazuh-side additive files from backups, re-test. Never `down -v` on Wazuh volumes.

## Next recommended phase

1. **Immediate**: rotate credentials per checklist (start with SUDO_PASSWORD + WAZUH_ADMIN_PASSWORD + DO Spaces keys).
2. **Add RAM or dedicated VMs** for MISP + Greenbone (order of operations in runbooks).
3. Deploy in order: OpenCanary (lightest, quickest win) -> Shuffle -> DFIR-IRIS -> Velociraptor -> MISP (VM) -> Greenbone (VM); Sysmon pilot after IRIS exists for case handling.
4. After first services are up: configure OpenSearch Alerting destinations, run integration test events (`integrations/test-events.md`), then deploy Wazuh-side additive files (opencanary decoder/rules) with validation.
5. Monthly reporting from `reporting/queries/` once live data flows.

## Exact next operator actions

1. `sudo passwd` (rotate host sudo) + update `ops/creds.env`.
2. Rotate Wazuh admin/indexer/API creds (existing `password-rotation.md` runbook).
3. Regenerate DO Spaces keys + VirusTotal key; update creds.env; verify `elastic-snapshot-s3.sh` + DR cron.
4. Decide deployment hosts for MISP + Greenbone (PVE VM, 4-8 GB each).
5. Create `/opt/mct-security-stack/.env` from `.env.example` with generated secrets (mode 600).
6. Deploy OpenCanary first: `docker network create mct-security; docker compose -f compose/docker-compose.phase2.yml -f compose/docker-compose.opencanary.yml --profile opencanary up -d`, then test canary -> Wazuh syslog path.
7. Configure OpenSearch Alerting destinations once Shuffle is up; run `integrations/test-events.md` tests.
8. Add weekly cron for `phase2-healthcheck.sh` and daily cron for `backup-phase2-config.sh`.

## UPDATE 2026-08-10 (21:55 UTC) — ALL SERVICES DEPLOYED

This report supersedes the "planned" status above. Everything is now RUNNING and verified:

| Service | Host | Status (final) |
|---|---|---|
| OpenCanary | Wazuh host | RUNNING — 16 rules deployed, syslog→Wazuh→IRIS verified |
| Shuffle | Wazuh host | RUNNING + CONFIGURED — 2 workflows (Class A + Class B), 2 webhooks, OpenSearch DB |
| DFIR-IRIS | Wazuh host | RUNNING — 5 clients created, API key issued, alerts auto-created from monitors |
| Velociraptor | Wazuh host (systemd) | RUNNING — admin user, binary v0.77.2 |
| MISP | mct-soc-scan VM | RUNNING — 4 orgs, 17 tags, API key, feeds enabled (CIRCL + Botvrij), CDB export LIVE |
| Greenbone | mct-soc-scan VM | RUNNING — feed synced (184,646 NVTs), weekly schedule, test scan done |

### Alert routing (all verified end-to-end)
- 5 flow monitors + opencanary monitor → Shuffle webhooks → workflows → IRIS alerts (Class A=Critical, Class B=High)
- MISP → Wazuh CDB: rules 121100-121104 (level 12), daily cron, auto-reload verified
- OpenCanary → Wazuh rules 121000-121099 → monitor → IRIS (5s latency verified)

### Crons
- 03:15 daily MISP→CDB export; 04:00 daily phase 2 backup; Mon 06:30 healthcheck

### Known limitations (documented)
- Shuffle variable substitution (${body:...} / execution vars) does not resolve in this build — static alert titles; alert→case escalation manual
- Shuffle worker/app replicas need `docker network connect mct-security` after restarts
- MISP/Greenbone admin creds in VM .env (600); IRIS admin pw + API keys in ops/backups (600)

### Remaining operator items
- Credential rotation (checklist), Sysmon pilot, Greenbone credentialed scans, case templates import
