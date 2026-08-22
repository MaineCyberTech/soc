> **HISTORICAL EVIDENCE (2026-08-16).** This document is a point-in-time record
> and does NOT describe the current MCT Security Stack. For current state, see
> ARCHITECTURE.md / REPO-MAP.md and ops/reports/ (current).

# Phase 4 Routing Changes - Applied

Only changes actually applied, with backup + validation evidence.

## Applied change 1: osquery 24010 -> level 0 (archive only)

**Date:** 2026-08-11 05:28-05:32 UTC
**Rule:** `local_rules.xml` override (appended as new `<group name="osquery,noise-suppressed,">`)

```xml
<rule id="24010" level="0" overwrite="yes">
  <if_sid>24000</if_sid>
  <decoded_as>json</decoded_as>
  <description>osquery: $(osquery.name) query result</description>
  <options>no_full_log</options>
  <group>osquery,noise-suppressed,</group>
</rule>
```

**Backup:** `config/wazuh_cluster/etc/rules/local_rules.xml.bak-20260811`
**Validation:**

1. `wazuh-logtest` with real open_sockets event (location osquery): rule 24010 matched, **level 0**, groups `['osquery','noise-suppressed']`, mail: False.
2. Child rule test (low_disk_space): **24013 matched level 4** - children still alert.
3. analysisd restarted on master + worker (containers restarted; PIDs changed 513->511, 501->500).
4. `Total rules enabled: 8508` - no load errors in ossec.log.
5. Cluster health: green, 3 nodes.
6. Last 24010 alert: 2026-08-11T05:31:20Z (restart moment) - no 24010 alerts since.

**Files synced:** docker cp local_rules.xml to multi-node-wazuh.master-1 and worker-1; host file updated (bind mount source).

**Expected effect:** ~263k/24h reduction (50.6%).

## Rollback

```bash
sudo cp /opt/wazuh-docker/multi-node/config/wazuh_cluster/etc/rules/local_rules.xml.bak-20260811 \
       /opt/wazuh-docker/multi-node/config/wazuh_cluster/etc/rules/local_rules.xml
docker cp <file> multi-node-wazuh.master-1:/var/ossec/etc/rules/local_rules.xml
docker cp <file> multi-node-wazuh.worker-1:/var/ossec/etc/rules/local_rules.xml
docker compose -f /opt/wazuh-docker/multi-node/docker-compose.yml restart wazuh.master wazuh.worker
```

## Not applied (proposed only)

- UniFi Class C digest routing - monitor/workflow changes not executed.
- mctportal Sentry/ACME suppression - rule changes not executed.
- Any rule level change for UniFi/mctportal/auditd - none.
