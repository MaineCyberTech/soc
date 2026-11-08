# Raven S3 integration (SOC)

Raven bucket `mct-soc` and key `mct-soc` are provisioned. This runbook adds a
second OpenSearch snapshot repository and moves the config DR bundle to Raven
(or dual-writes it) without disturbing the existing DO Spaces repository.

Status 2026-11-05: the old SOC Wazuh host `192.168.222.149` is unreachable.
The live Wazuh cluster runs on the Falcon host as
`multi-node-wazuh{1,2,3}.indexer-1`; the SOC data path is therefore implemented
on Falcon:

- rclone remote `raven-soc` → `mct-soc/wazuh-indexer`
- `falcon-raven-wazuh-copy.timer` daily at 04:20
- first copy: 11,300 files, 0 differences (2026-11-05)
- SeaweedFS cutover run `20261107-231819`: 11,300 files, 0 differences
  (2026-11-07)
- DR bundle dual-write live 2026-11-08: `/opt/wazuh-backups/run-dr-bundle.sh`
  stages the bundle, keeps the DO Spaces copy, and syncs to
  `s3://mct-soc/dr/current` plus `dr/history`; the Raven check reported 12
  matching files and 0 differences. The daily cron is
  `/etc/cron.d/wazuh-raven-dr` at 04:00.

The OpenSearch repository registration below remains the procedure for a
separate SOC cluster if `.149` returns. The DR config bundle move is still
pending.

## Preconditions

- Wazuh cluster healthy; existing `do-spaces` snapshots successful.
- Change window / rollback approval.
- Raven reachable: `nc -z 192.168.222.120 8333`.
- Scoped credentials available in the root-only secret store.
- The `soc` identity includes `WriteAcp:mct-soc`; rclone sends a canned ACL
  header on PUT and SeaweedFS treats it as the separate `WriteAcp` action.

## Repository registration

Add the same settings to each indexer keystore:

```bash
docker exec -it <indexer> bin/opensearch-keystore add -x -f s3.client.raven.access_key
docker exec -it <indexer> bin/opensearch-keystore add -x -f s3.client.raven.secret_key
```

Identity permissions: `Read`/`Write`/`List`/`Tagging`/`WriteAcp` on
`mct-soc`. Without `WriteAcp`, uploads fail with `403 AccessDenied` even
though a plain `PutObject` succeeds.

Reload:

```text
POST /_nodes/reload_secure_settings
```

Register:

```json
PUT _snapshot/raven
{
  "type": "s3",
  "settings": {
    "bucket": "mct-soc",
    "client": "raven",
    "base_path": "snapshots",
    "endpoint": "192.168.222.120:8333",
    "protocol": "http",
    "path_style_access": true,
    "region": "us-east-1"
  }
}
```

## DR bundle

The live wrapper now dual-writes: `run-dr-bundle.sh` keeps the original
`s3://wazuh/dr` copy and uses rclone to sync the same stage to
`s3://mct-soc/dr/current` and `dr/history`. This fixes the stale DR-bundle
defect without waiting for new DO Spaces keys.

## Validation

1. Snapshot a small index to `raven`; require `state=SUCCESS`.
2. Restore to a scratch index; verify count and one query.
3. Delete the scratch index and test snapshot.
4. Confirm the DR bundle object exists and its checksum matches the local stage.
5. Confirm `do-spaces` snapshots and retention are unchanged.

## Rollback

- `DELETE /_snapshot/raven` removes the repository definition.
- Remove `s3.client.raven.*` from the keystore if required.
- Restore the previous `dr-s3-bundle.sh` target.
- Do not delete existing DO Spaces snapshots.

## Capacity

Raven SeaweedFS is 558.8 GiB usable on a single data01 node. SOC's local snapshots are
around 15–20 GB; keep the existing 30-day S3 retention only after measuring the
Raven bucket growth. The DO Spaces copy remains authoritative.
