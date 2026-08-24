# Phase 28 Canonical Source Map

Date: 2026-08-24

## Canonical sources (one source of truth each)

| Component | Canonical source | Runtime target | Owner | Version | Deprecation |
|---|---|---|---|---|---|
| Wazuh multi-node | /opt/wazuh-docker/multi-node (gitignored) | running compose | SOC | wazuh 4.14.7 / indexer 4.14.7 | - |
| MCT stack repo | github.com/MaineCyberTech/soc | bundle v1.2.0/v1.3.0 | SOC | tags | - |
| IRIS | upstream dfir-iris/iris-web v2.4.29 | data/dfir-iris (nested git, gitignored) | SOC | v2.4.29 | vendored copy |
| Scorecard generators | reporting/generators/ | reporting/output/ | SOC | - | ops/scripts copies |
| Sysmon policies | integrations/sysmon/ | endpoints | SOC | 4.91 (BCA0EB) | endpoint-deploy copy |
| Shuffle workflow | integrations/shuffle/backups/ (export) | Shuffle org | SOC | phase27 export | UI edits gated |
| Zeek guardrail | ops/scripts/zeek-classa-guardrail.sh | cron */15 | SOC | - | - |
| DR bundles | /opt/mct-security-stack-backups | S3 nyc3 | SOC | daily 04:00 | - |
| Elasticsearch data | snapshots /snapshots | 42 snapshots | SOC | rolling 7d | - |
| NetFlow config | multi-node compose | elastiflow | SOC | 7.26.2 | - |

## Decision rules

- Every deployable has ONE canonical source (above); generated/runtime paths derived.
- Duplicates redirected (32) not silently deleted; removal gated on evidence + rollback.
- Nested git (data/dfir-iris) is a vendored deployable, NOT a repo component: keep gitignored,
  pin upstream version, record in dependency lock (34).

## No secrets