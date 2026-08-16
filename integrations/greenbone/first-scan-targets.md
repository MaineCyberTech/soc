# First Scan Targets

## Group: core-infrastructure (first scheduled scan)

| Target | IP | Profile | Note |
|---|---|---|---|
| Wazuh host | 192.168.222.149 | safe discovery | OpenCanary ports (21/23/3306/1433/9100/8008) will appear - mark FP in review |
| Security Onion | 192.168.222.116 | safe discovery | NSM host |
| PVE | 192.168.222.187 | safe discovery | hypervisor - discovery only |

## Explicit exclusions

- mct-soc-scan VM (192.168.222.154) - the scanner host itself.
- Gateways (192.168.222.1, 23.150.201.36, 23.150.201.165) - network-appliances
  group, separate quarterly window, non-invasive only.
- mct-portal droplet (138.197.105.82) - cloud group, client authorization + off-peak.

## Authorization

- MCT internal assets: authorized by default.
- Internet-facing/client-owned: authorization on record required first.
