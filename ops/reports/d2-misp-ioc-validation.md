# Drill D2: MISP IOC Match Validation

Date: 2026-08-11
Status: **PASS** (Wazuh CDB matching validated; MISP API path previously validated)

## Path validated

```text
MISP event (action:block + confidence) -> misp-to-wazuh-cdb.py export
  -> /var/ossec/etc/lists/malicious-ioc/misp-iocs (CDB)
  -> Wazuh rule 121100 (level 12, Class A) on srcip match
```

## Test procedure

1. Confirmed CDB file state: `misp-iocs` present in container, registered in ossec.conf (`<list>etc/lists/malicious-ioc/misp-iocs</list>`).
2. Production export run: `misp-to-wazuh-cdb.py` (0 IOCs - no action:block tags in MISP yet; export path works).
3. Added safe test IOC `203.0.113.77:` (RFC5737 documentation IP - cannot affect real traffic) to container CDB list.
4. Restarted wazuh.master to force CDB recompile; verified `misp-iocs.cdb` updated (2084 bytes).
5. `wazuh-logtest` with synthetic sshd event:

```
Aug 11 05:44:01 mct sshd[12345]: Failed password for invalid user root from 203.0.113.77 port 54321 ssh2
```

Result: rule 5710 matched -> **rule 121100 matched, level 12, mail: True, alert to be generated**.

6. Cleanup: removed test IOC, recompiled CDB (back to 0 lines, 2048-byte empty structure).

## Findings

- **CDB auto-recompile did not trigger on file change within 60s** - a
  `docker compose restart wazuh.master` was needed to force recompile.
  Recommendation: always restart analysisd after CDB list changes (also
  required after any `misp-to-wazuh-cdb.py --push`).
- CDB rule chain confirmed: 121100 (sshd invalid user + srcip in list),
  121101 (sshd auth failure + srcip), 121102/121103 (srcip/dstip + 80700),
  121104 (src_domain). All level 12 = Class A.
- No real benign traffic blocked: test IOC is an RFC5737 documentation address.

## Blocker for full end-to-end

- MISP side has no `action:block`-tagged IOCs yet, so the live export contains
  0 entries. The export script (fetch -> filter tags -> write CDB) was validated
  in Phase 3 (misp-feed-health PASS, 2,106 events indexed). Wazuh-side matching
  fully validated here.
- Shuffle/IRIS leg: same as other drills - depends on Shuffle webhook reliability;
  manual IRIS case creation path documented in routing map.

## Files

- integrations/misp/d2-test-ioc-procedure.md - repeatable procedure
- integrations/test-events/d2-misp-ioc-test.json - safe test payload
