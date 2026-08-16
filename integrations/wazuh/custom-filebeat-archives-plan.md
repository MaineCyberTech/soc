# Custom Filebeat Archives Plan (Option A - prepared, not applied)

## Why custom filebeat.yml

Wazuh 4.14.7 image seeds /etc/filebeat/filebeat.yml with `archives: enabled: false`
on every container start (PERMANENT_DATA_EXCP). Manual edits are overwritten.

## Plan

1. Create /opt/wazuh-docker/multi-node/config/wazuh_cluster/filebeat-archives.yml:
   ```yaml
   filebeat.modules:
     - module: wazuh
       alerts: { enabled: true }
       archives: { enabled: true }
   setup.template.json.enabled: true
   setup.template.overwrite: true
   setup.template.json.path: '/etc/filebeat/wazuh-template.json'
   setup.template.json.name: 'wazuh'
   setup.ilm.enabled: false
   output.elasticsearch:
     hosts: ["https://wazuh1.indexer:9200", ...]
     username: 'admin'
     password: '...'   # from env, never commit
   ```
2. Bind-mount in docker-compose.yml (both managers):
   `./config/wazuh_cluster/filebeat-archives.yml:/etc/filebeat/filebeat.yml:ro`
3. Recreate managers: docker compose up -d.
4. Verify: wazuh-archives-<date> index created; filebeat log clean.
5. Add retention policy for archives index (ISM).

## NOT APPLIED (Option B decided; storage insufficient)

## Storage prereq

+40 GB free disk (or move snapshots to S3-only, freeing ~9 GB) before applying.
