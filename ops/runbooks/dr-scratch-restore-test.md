# DR Scratch Restore Test

Purpose: validate restore procedures WITHOUT touching production data.
Scratch environment only - no production restore, no destructive actions.

## Architecture (scratch)

```text
Scratch OpenSearch instance (docker, separate compose, separate ports 19200/19300)
  <- restore wazuh-backup snapshot repo (point repo at a COPY of /opt/wazuh-backups/elasticsearch)
Scratch Wazuh config dir (extract wazuh-config-*.tar.gz to /tmp)
Scratch phase stack config (extract phase2-config-*.tar.gz to /tmp)
VM103 scratch: stop-and-copy approach for IRIS/MISP/Greenbone DB restore validation (dry-run dump/restore to temp schema)
```

## Required resources

| Resource | Where | Size |
|---|---|---|
| Scratch OpenSearch container | docker on Wazuh host (ports 19200) | ~4 GiB RAM, 10 GiB disk |
| Snapshot copy | /tmp/opencode/dr-scratch/snapshots | copy of latest snap dir |
| Config extracts | /tmp/opencode/dr-scratch/config | small |
| IRIS/MISP/Greenbone dump copies | ops/backups | as-is (already local) |

## Restore order

1. **OpenSearch snapshot**: register scratch repo -> restore latest snapshot
   -> verify index count + doc counts match source.
2. **Wazuh config**: extract wazuh-config tar -> diff against current config
   (no apply).
3. **Phase stack config**: extract phase2-config tar -> verify compose files
   parse (docker compose config -q).
4. **IRIS DB**: gunzip iris-db dump -> pg_restore into scratch postgres
   (temp container) -> verify case tables present.
5. **MISP DB**: gunzip misp-db dump -> import to scratch mariadb -> verify
   events count.
6. **Greenbone DB**: gunzip gvmd dump -> import to scratch postgres -> verify
   gvmd schema (limited - large dump, may subset).

## Validation checks

| Check | Pass criteria |
|---|---|
| Snapshot restore | indices == source count; sample doc timestamps match |
| Config extract | file count + key files present (docker-compose.yml, ossec.conf) |
| Compose parse | `docker compose config -q` exit 0 |
| IRIS restore | pg_restore exit 0; cases table row count > 0 |
| MISP restore | import exit 0; events table count > 0 |
| Greenbone restore | import exit 0 (or documented subset) |

## Cleanup

- Stop + remove scratch containers (scratch only - never production).
- rm -rf /tmp/opencode/dr-scratch.
- Confirm no production volumes touched (docker volume ls unchanged).

## Safety

- Scratch uses COPIED snapshots and dumps only.
- No production index/schema is modified.
- All scratch ports distinct (19200+) to avoid collisions.
- Requires operator approval to execute (this phase: plan only).

## Execution status

- Plan: COMPLETE (this file + checklist + report)
- Execution: NOT RUN (operator approval + resources required)
