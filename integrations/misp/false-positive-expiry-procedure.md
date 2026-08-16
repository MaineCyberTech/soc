# False Positive / Expiry Procedure (MISP)

## False positive flow

1. Wazuh CDB rule (1211xx) fires on an IOC match.
2. Analyst triages: value matches but is benign (shared IP, internal host, mis-tag).
3. MISP: tag event `action:false-positive` (and optionally add comment).
4. Re-run CDB export -> entry excluded by tag filter:

```bash
python3 /opt/mct-security-stack/ops/scripts/misp-to-wazuh-cdb.py --push
```

5. Remove stale value from current CDB if the export doesn't regenerate it
   (e.g. value manually added earlier):

```bash
docker exec multi-node-wazuh.master-1 sh -c 'sed -i "/<value>:/d" /var/ossec/etc/lists/malicious-ioc/misp-iocs'
# then restart analysisd (auto-reload unreliable)
```

6. Log the FP reason in IRIS case notes + MISP event comment.

## Expiry flow

| Type | Suggested expiry | Action |
|---|---|---|
| scanner IP | 30 days | remove action:block after window |
| confirmed C2 | 90 days | review before removing; renew if active |
| client-specific | case-dependent | remove at case closeout |
| false positive | immediate | suppress + exclude |

1. MISP: remove `action:block`/`action:monitor` tag or add `action:expire`.
2. Re-run export.
3. Verify CDB line count decreased:

```bash
docker exec multi-node-wazuh.master-1 sh -c 'wc -l /var/ossec/etc/lists/malicious-ioc/misp-iocs'
/opt/mct-security-stack/ops/scripts/misp-cdb-diff-report.sh
```

## Safety

- Expired/FP IOCs never block traffic (CDB match only routes to IRIS workflow).
- No automated blocking - actions remain manual approval.
