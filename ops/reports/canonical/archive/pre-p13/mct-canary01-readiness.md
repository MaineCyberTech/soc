# mct-canary01 Readiness

Date: 2026-08-11

## Status: READY TO BUILD (VM creation requires operator approval - not executed)

## Deliverables

- `ops/runbooks/mct-canary01-build.md` - design, PVE provision commands (prepare only), post-boot setup, Wazuh side, validation.
- `integrations/opencanary/mct-canary01-config.md` - OpenCanary config draft (node_id, services, syslog to Wazuh master).
- `integrations/opencanary/canarytokens-inventory.md` - 5-token starter set with placement rules.

## Validation path documented

```text
canary VM port 9100 connect -> opencanary-mct-canary01 syslog
  -> Wazuh master 514 -> rule 121012 level 12 -> Shuffle -> IRIS
```

## Checks

| Item | Status |
|---|---|
| Canary VM plan exists | YES (build runbook) |
| OpenCanary config plan | YES (mct-canary01-config.md) |
| Syslog forwarding plan | YES (192.168.222.149:514, covered by allowed-ips) |
| Wazuh/Shuffle/IRIS validation path | YES (rule 121012 -> template opencanary-hit) |
| Canarytokens inventory | YES (5 tokens planned) |
| No real credentials in fake artifacts | CONFIRMED (placeholder-only policy) |
| VM actually created | NO - operator approval required |

## Next action

Operator approves VM build on PVE 192.168.222.187; run provision commands in
build runbook; then validate per mct-canary01-config.md.
