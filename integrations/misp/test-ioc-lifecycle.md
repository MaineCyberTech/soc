# Test IOC Lifecycle (MISP)

Safe end-to-end walkthrough of an IOC through all lifecycle states.

## Step 1 - candidate

Feed events arrive in MISP untagged. Confirm presence:

```bash
/opt/mct-security-stack/ops/scripts/misp-feed-health.sh   # shows event count
```

## Step 2 - analyst-reviewed (MISP UI)

1. MISP -> Events -> select a test event (or create one tagged test).
2. Review attributes; mark reviewed.
3. Add tag `action:block` (or `action:monitor`) + `confidence:high|medium`.
4. Recommended: tag `tlp:green` for internal test IOCs.

## Step 3 - export to CDB

```bash
python3 /opt/mct-security-stack/ops/scripts/misp-to-wazuh-cdb.py --push
```

- Export includes only action:block + confidence medium/high, non-expired.
- Push copies to master + worker containers.

## Step 4 - Wazuh match

Follow d2-test-ioc-procedure.md (logtest with the IOC value; expect rule
121100/121101/121102 level 12).

## Step 5 - expire / remove

1. MISP: remove `action:block` tag or add `action:expire`.
2. Re-run export (IOC dropped from CDB).
3. Restart analysisd if the CDB file changed (auto-reload unreliable - observed).

## Safety

- Use RFC5737 test values (203.0.113.0/24) or a domain you control.
- Never promote a real attacker IOC as "test".
- Clean up after validation.
