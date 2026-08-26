# mct-canary01 Validation

Date: 2026-08-11
Status: **NOT EXECUTED - VM not built (PVE API 401 blocker)**

## Planned validation path

```text
canary VM port 9100 -> opencanary-mct-canary01 syslog -> Wazuh master 514
  -> rule 121012 level 12 -> Shuffle -> IRIS (opencanary-hit template)
```

## Reference validation (local canary, D1 - already PASS)

- Local OpenCanary path verified end-to-end in Phase 3/4/5:
  soc-smoke-test.sh --opencanary -> rule 121012 level 12 alert.
- The mct-canary01 path is identical except node_id and VM host.

## When VM is built

1. Run validation: soc-smoke-test.sh --opencanary from the canary.
2. Confirm archives contain opencanary-mct-canary01 (distinct from opencanary-mct-01).
3. Confirm IRIS case created.
4. Record result here.
