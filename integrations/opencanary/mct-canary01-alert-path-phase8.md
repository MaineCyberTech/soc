# mct-canary01 Alert Path (Phase 8)

canary VM port touch -> opencanary-mct-canary01 JSON syslog
  -> Wazuh master 15140/udp (allowed-ips 192.168.222.0/24)
  -> decoder json -> rule 121012 level 12 (Class A)
  -> Shuffle webhook (wazuh-high-severity trigger) -> IRIS opencanary-hit case

## Validation

soc-smoke-test.sh --opencanary (or grep archives for opencanary-mct-canary01)

## Status

BLOCKED on VM build (Proxmox access).
