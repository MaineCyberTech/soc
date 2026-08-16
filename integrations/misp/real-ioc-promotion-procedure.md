# Real IOC Promotion Procedure (MISP -> CDB -> Wazuh)

## For real IOCs

1. **Analyst review** in MISP UI: confirm IOC value + type + confidence.
2. **Tag**: `action:block` (or action:monitor) + `confidence:high|medium` + tlp.
3. **Export** (allow 15 min for large MISP):

```bash
timeout 1200 python3 /opt/mct-security-stack/ops/scripts/misp-to-wazuh-cdb.py --push
```

Note: `--push` copies to master + worker automatically. If run without --push:

```bash
docker cp /opt/mct-security-stack/ops/cdb/misp-iocs multi-node-wazuh.master-1:/var/ossec/etc/lists/malicious-ioc/misp-iocs
docker cp /opt/mct-security-stack/ops/cdb/misp-iocs multi-node-wazuh.worker-1:/var/ossec/etc/lists/malicious-ioc/misp-iocs
```

4. **Reload CDB** (auto-reload unreliable - documented):

```bash
cd /opt/wazuh-docker/multi-node && docker compose restart wazuh.master wazuh.worker
```

5. **Validate**: wazuh-logtest with a synthetic event carrying the IOC
   (expect rule 121100/121101/121102 level 12).

## Expiry

- Remove `action:block` tag (or add `action:expire`); next export drops the IOC.
- False positive: add `action:false-positive`; excluded by export filter.

## Safety

- Never promote IOCs that could block client production traffic without review.
- Test with RFC5737 values first (documented in this phase).
- Analyst sign-off required for real (non-test) IOCs.
