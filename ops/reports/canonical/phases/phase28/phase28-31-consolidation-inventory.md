# Phase 28 Consolidation Inventory

Date: 2026-08-24
Tooling: p28-consolidation-candidates.sh, p28-deployability-inventory.sh, p28-dependency-graph.py.

## Running compose projects (5)

| Project | Config source | Status |
|---|---|---|
| multi-node (Wazuh) | /opt/wazuh-docker/multi-node/docker-compose{,.override,.cloudflare}.yml | running(11) |
| mct-security-stack | repo compose/docker-compose.{phase2,shuffle,opencanary}.yml | running(5) |
| iris-web | repo data/dfir-iris/iris-web/docker-compose.yml (nested git, gitignored) | running(5) |
| portainer | /opt/portainer/compose.yaml | running(1) |
| shuffle (swarm) | swarm services (shuffle-workers/orborus/healthcheck/email/http/etc.) | running (~20) |

## Containers (notable)

- Wazuh: multi-node-wazuh.{master,worker}-1, multi-node-wazuh{1,2,3}.indexer-1 (OpenSearch 2.19.5.0)
- IRIS: iriswebapp_{app,worker,db,rabbitmq,nginx}
- Shuffle: shuffle-{backend,frontend,opensearch,orborus}, shuffle-workers, healthchecks, tools, ai, subflow, http, email
- Observability/flow: elastiflow (flow-collector 7.26.2), tenzir-node (tenzir:main), flow-relay
- Deception: mct-security-stack-opencanary-1 (thinkst/opencanary:latest)
- Logging: security-onion (syslog-ng:latest)

## Volumes (~40)

- Indexer data: multi-node_wazuh-indexer-data-{1,2,3}
- IRIS: iris-web_{db_data,iris-downloads,server_data,user_templates}
- Shuffle: mct-security-stack_shuffle-database
- Wazuh config/log: multi-node_master-wazuh-{etc,logs,queue,...}, worker equivalents
- Elastiflow: multi-node_elastiflow-data; Deception: mct-security-stack_opencanary-logs; Portainer: portainer_data

## Scripts / configs (repo)

- ~70 shell scripts (ops/scripts, scripts/endpoint-deploy), ~10 python (ops/scripts, reporting/generators), 3 PS1 (integrations/sysmon) + 2 endpoint installers.
- Compose templates: 7 (phase2, shuffle, opencanary, dfir-iris, greenbone, misp, velociraptor).
- Rules: integrations/sysmon/phase23-eventid7-policy.xml, sysmon-mct.xml; security-onion phase19 rules; zeek rules.
- Crons: guardrail (*/15), backup bundle (04:00), scorecard, health (audit-cron).
- Dashboards/reports: reporting/{templates,generators,output}; ops/runbooks; checklists.

## Indices (data stores)

- 65 indices / ~21GB (alerts, archives 14d, states-inventory 14, vulnerabilities, elastiflow rollover, .kibana, opendistro history).
- 42 snapshots (FS /snapshots volume) + S3 DR bundle (nyc3).

## Network (host listeners)

- 1514/1515/15140 (Wazuh), 9200/9300 (indexers), 443/9443 (dashboard/IRIS), 8000 (elastiflow API), 8002/8080 (flow-relay/tenzir), 2377/7946 (swarm), 33333-33339 (shuffle), 21/22/3306/8008/9100/19999 (host services incl. opencanary listeners).

## Dependency graph (p28-dependency-graph.py)

- 5 auto-detected nodes (compose: data/dfir-iris/iris-web; installers: install/uninstall-wazuh-{macos,linux}, p28 tooling). Manual service DAG in 39.

## No secrets