# CDB Reload and analysisd Restart

## Issue

Wazuh does NOT reliably auto-recompile `.cdb` list files on change within a
reasonable window (observed repeatedly: file updated but .cdb mtime unchanged).

## Procedure (after any CDB list change)

```bash
# 1. Push the list to both managers
docker cp /opt/mct-security-stack/ops/cdb/misp-iocs multi-node-wazuh.master-1:/var/ossec/etc/lists/malicious-ioc/misp-iocs
docker cp /opt/mct-security-stack/ops/cdb/misp-iocs multi-node-wazuh.worker-1:/var/ossec/etc/lists/malicious-ioc/misp-iocs

# 2. Restart analysisd (container restart re-syncs + recompiles)
cd /opt/wazuh-docker/multi-node
docker compose restart wazuh.master wazuh.worker
sleep 30

# 3. Verify recompile
docker exec multi-node-wazuh.master-1 sh -c 'ls -la /var/ossec/etc/lists/malicious-ioc/misp-iocs.cdb'
# expect fresh mtime + size > 2048 (non-empty list)

# 4. Validate match
# (see real-ioc-promotion-procedure.md step 5)
```

## Verification of loaded rules

```bash
docker exec multi-node-wazuh.master-1 sh -c 'grep -iE "Total rules" /var/ossec/logs/ossec.log | tail -1'
# expect no errors after restart; cluster green
```

## Safety

- Restart is quick (~20s per node); agents reconnect automatically.
- Always keep a backup of local_rules.xml before any rule change.
