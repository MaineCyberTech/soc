# D2 Test IOC Procedure (MISP -> CDB -> Wazuh)

Safe, repeatable validation. Never uses real malicious IOCs.

## 1. Choose a safe test IOC

Use an RFC5737 documentation IP (never routable, cannot affect real traffic):

```text
203.0.113.77  (TEST ONLY)
```

## 2. Add to CDB list (container)

```bash
docker exec multi-node-wazuh.master-1 sh -c 'printf "203.0.113.77:\n" > /var/ossec/etc/lists/malicious-ioc/misp-iocs; chown wazuh:wazuh /var/ossec/etc/lists/malicious-ioc/misp-iocs'
```

## 3. Force CDB recompile

CDB recompile does NOT trigger automatically on file change (observed 2026-08-11).
Restart analysisd:

```bash
cd /opt/wazuh-docker/multi-node
docker compose restart wazuh.master wazuh.worker
sleep 30
docker exec multi-node-wazuh.master-1 sh -c 'ls -la /var/ossec/etc/lists/malicious-ioc/misp-iocs.cdb'
```

Expected: .cdb mtime updates, size grows.

## 4. Validate matching with logtest

```bash
docker exec multi-node-wazuh.master-1 sh -c 'printf "Aug 11 05:44:01 mct sshd[12345]: Failed password for invalid user root from 203.0.113.77 port 54321 ssh2\n" | timeout 120 /var/ossec/bin/wazuh-logtest -v -l /var/log/auth.log 2>&1' | grep -E "121100|level"
```

Expected: `*Rule 121100 matched`, `level: '12'`.

## 5. Cleanup

```bash
docker exec multi-node-wazuh.master-1 sh -c 'printf "" > /var/ossec/etc/lists/malicious-ioc/misp-iocs'
cd /opt/wazuh-docker/multi-node && docker compose restart wazuh.master
```

## 6. Live path (production export)

```bash
python3 /opt/mct-security-stack/ops/scripts/misp-to-wazuh-cdb.py --push
```

Requires an event tagged `action:block` + `confidence:medium|high` in MISP.
Follows the same CDB rules once pushed.

## Safety

- RFC5737 IPs only. Never insert real attacker IPs as "test".
- Remove test IOC immediately after validation.
- Never test-block client production IPs.
