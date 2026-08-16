# DR Scratch Restore Execution

## Feasibility (2026-08-11)

- Disk: 17 GB free (scratch OpenSearch ~10 GB = OK)
- RAM: ~1 GiB free (scratch OpenSearch with 2G heap - TIGHT, run with 1.5G heap + swap)
- Snapshot: snap-20260811-2017 SUCCESS (latest of 20)

## Execution steps (scratch only - NEVER production)

### 1. Stage snapshot copy

```bash
mkdir -p /tmp/opencode/dr-scratch/snapshots
# copy repo dir (NOT move) - use hardlinks to save space
cp -al /opt/wazuh-backups/elasticsearch /tmp/opencode/dr-scratch/snapshots/elasticsearch
```

### 2. Scratch OpenSearch (ports 19200/19300)

```bash
docker run -d --name dr-scratch-es --network host \
  -e discovery.type=single-node -e ES_JAVA_OPTS='-Xms1g -Xmx1g' \
  -v /tmp/opencode/dr-scratch/esdata:/usr/share/opensearch/data \
  -v /tmp/opencode/dr-scratch/snapshots:/snapshots \
  opensearchproject/opensearch:3.2.0 \
  -p 19200:9200
```

### 3. Register repo + restore

```bash
curl -sk -u admin:admin https://127.0.0.1:19200/_snapshot/scratch-repo -X PUT \
  -H 'Content-Type: application/json' \
  -d '{"type":"fs","settings":{"location":"/snapshots"}}'
# list snapshots
curl -sk -u admin:admin https://127.0.0.1:19200/_snapshot/scratch-repo/_all
# restore latest (or subset index)
curl -sk -u admin:admin https://127.0.0.1:19200/_snapshot/scratch-repo/snap-20260811-2017/_restore \
  -X POST -H 'Content-Type: application/json' \
  -d '{"indices":"wazuh-alerts-4.x-2026.08.10","rename_pattern":"(.+)","rename_replacement":"restored_$1"}'
```

### 4. Validation

| Check | Pass |
|---|---|
| Restore completes | state SUCCESS |
| Index count | restored index exists |
| Doc count | matches source (compare _cat/indices) |
| Sample timestamps | match source docs |

### 5. Config restore validation

```bash
tar tzf /opt/wazuh-backups/wazuh-config-*.tar.gz | head   # key files present
cd /tmp/opencode/dr-scratch && tar xzf <phase2-config>.tar.gz
docker compose -f compose/docker-compose.yml config -q && echo "compose parses"
```

### 6. DB restore validation (dry-run into scratch containers)

- IRIS: gunzip -> pg_restore --schema-only into scratch postgres (iriswebapp_db image)
- MISP: gunzip -> mariadb --execute="source" into scratch mariadb (verify events count)
- Greenbone: gzip -t only (full restore impractical; subset or schema-only)

### 7. Cleanup

```bash
docker rm -f dr-scratch-es
rm -rf /tmp/opencode/dr-scratch
# verify production volumes unchanged
docker volume ls | grep -c multi-node   # count unchanged
```

## Safety

- COPY/links only; production repo never deleted.
- Scratch ports 19200+ (no collision).
- No production index/schema touched.

## Status

PLAN EXECUTABLE. Execution requires operator approval + RAM headroom
(recommend after VM101 RAM increase).
