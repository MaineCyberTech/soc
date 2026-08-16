# MISP IOC State Model

## States

| State | Trigger | Behavior |
|---|---|---|
| candidate | feed event ingested | enrichment only; not in CDB |
| analyst-reviewed | analyst accepts value | eligible for CDB |
| active-monitor | tag `action:monitor` + confidence:medium | CDB match -> Class B alert |
| active-block | tag `action:block` + confidence:medium/high | CDB match -> Class A route / level 12 |
| expired | past expiry window | removed from CDB |
| false-positive | analyst rejects | excluded from CDB + feeds |

## Confidence model

- `confidence:low` - enrichment only (IRIS case lookups)
- `confidence:medium` - alert if matched (Class B)
- `confidence:high` - Class A route / level 12 style workflow

## Tag conventions (MISP)

Required tags on events eligible for CDB export:

```
action:block | action:monitor | action:false-positive | action:expire
confidence:low | confidence:medium | confidence:high
tlp:clear | tlp:green | tlp:amber | tlp:red
```

The CDB export (`ops/scripts/misp-to-wazuh-cdb.py`) includes only
`action:block` + confidence medium/high, non-expired, non-false-positive.

## Expiry windows (policy suggestions)

| Type | Suggested expiry | Notes |
|---|---|---|
| scanner IP | 30 days | short-lived |
| confirmed C2 | 90 days | longer-lived; renew while active |
| client-specific IOC | case-dependent | link to IRIS case |
| false positive | immediate | suppress; do not re-add unless revalidated |

These are suggestions; set local policy in `ops/runbooks/ioc-lifecycle.md`.

## False positive handling

1. Tag event `action:false-positive` in MISP.
2. CDB export excludes it automatically (tag filter).
3. Remove stale value from current CDB (`misp-iocs` regenerated on next run).
4. Log the FP reason in the IRIS case notes and MISP event comment.

## Wazuh side

- CDB list: `etc/lists/malicious-ioc/misp-iocs` (master + worker)
- Rules: 121100+ fire on match (Class A/B by confidence)
- CDB auto-reloads on file change (analysisd)
- No automated blocking; workflow routes to IRIS only
