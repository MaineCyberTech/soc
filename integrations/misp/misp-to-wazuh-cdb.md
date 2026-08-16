# MISP -> Wazuh CDB Malicious IOC Export

Purpose: publish MISP IOCs tagged `action:block` (or `action:monitor`) into a Wazuh CDB list for real-time matching.

## STATUS: DEPLOYED & VERIFIED (2026-08-10)

- Production script: `ops/scripts/misp-to-wazuh-cdb.py` (stdlib only, no deps)
- Cron (root): `15 3 * * *` → generates `/opt/mct-security-stack/ops/cdb/misp-iocs` and pushes to master+worker containers at `/var/ossec/etc/lists/malicious-ioc/misp-iocs`
- analysisd auto-reloads the list on change (verified: new IOC matched without restart)
- Rules (local_rules.xml, backed up): 121100 (sshd 5710 parent), 121101 (sshd 5716), 121102-121104 (generic 80700 for srcip/dstip/src_domain) — all level 12
- Config: `<list>etc/lists/malicious-ioc/misp-iocs</list>` added to master+worker ossec.conf ruleset
- Secrets: MISP API key at `ops/backups/misp-api-key.txt` (600, same file synced from mct-soc-scan VM)

## Verification performed

- Test IOC 203.0.113.77 (action:block + confidence:high) → exported → logtest matched rule 121100 (level 12)
- Second IOC 203.0.113.99 → auto-reload verified without restart
- Cleanup: test events deleted, list emptied, rule no longer fires

## Filtering rules

- Only events tagged `action:block` AND (`confidence:medium` or `confidence:high`) are exported
- ip-src/ip-dst/domain/hostname/sha256/md5 attributes; subnets (`/`) skipped (exact-match CDB)
- Config overrides: `ops/cdb/misp-cdb.conf` (MISP_BASEURL, MIN_CONFIDENCE, BLOCK_TAGS)

## Failure modes

- MISP API down → script exits non-zero; cron logs to `ops/reports/misp-cdb-cron.log`; last list stays active
- Bad list syntax → analysisd rejects at compile; validate with logtest before trusting (see history: XML corruption incidents)
- Expiry: script currently exports all matching (no expiry check) — add event date filtering when expiry tags are used

## Pipeline

```text
MISP events (tagged action:block / action:monitor, confidence >= medium)
  -> ops/scripts/misp-to-wazuh-cdb.example.py (API pull, JSON export)
  -> generate /tmp/malicious-iocs.cdb (key=ip|domain|hash, value=tags)
  -> copy to Wazuh manager(s): /var/ossec/etc/lists/malicious-iocs.cdb
  -> add <list> entry in ossec.conf + rules referencing this list
  -> restart analysisd (rolling restart across manager/worker)
```

## CDB format

```text
<REDACTED_HOST_IP>:1,source:misp,type:scanner
<REDACTED_DOMAIN>:1,source:misp,type:c2
<REDACTED_HASH>:1,source:misp,type:malware
```

Key per IOC type: IP `a.b.c.d`, domain `example.com`, file hash (sha256). The value field is a CSV of attributes used by the rule.

## Wazuh side (additive, in local_rules.xml or a new rules file)

```xml
<rule id="100900" level="12">
  <if_sid>80700</if_sid>  <!-- adjust: srcip match -->
  <list field="srcip" lookup="address_match_key">etc/lists/malicious-iocs.cdb</list>
  <description>MISP: known malicious IOC srcip</description>
  <group>misp,ioc,</group>
</rule>
```

Adjust rule IDs to avoid collisions with existing local rules (existing range starts at 100001).

## Safe update procedure

1. Generate CDB on the Wazuh host with the example script (never commit real CDB to git).
2. Validate: `ossec-test` or `wazuh-logtest` with a sample event.
3. Copy to managers: master + worker (`/var/ossec/etc/lists/`).
4. Restart `wazuh-modulesd`/analysisd per Wazuh docs (use rolling restart to avoid agent disconnects).
5. Confirm no rule engine errors in `/var/ossec/logs/ossec.log`.

## Failure modes

- API key revoked: script fails with 401; CDB not regenerated; existing CDB stays until expiry.
- CDB syntax error: analysisd rejects the list on restart — validate before restart, keep previous list as backup.
- MISP down: keep last generated CDB; set cron alerting (systemd timer failure mail).

## Retention/expiry

- Only include events with `expiry` in the future and confidence >= medium.
- Script drops expired entries each run. Document FPs in MISP event description; script excludes tagged `action:monitor` from `block` export unless configured.
