# UniFi Daily Digest

Date: {{ date }}
Window: last 24h

## Summary

- UniFi family alerts: {{ unifi_total }}
- Unknown devices (120527): {{ unknown_devices }}
- WAN drops (120501): {{ wan_drops }}
- Link down (120518): {{ link_down }}
- WPA replay (120521): {{ wpa_replay }}
- Memory pressure (120513): {{ memory_pressure }}

## Unknown devices (120527) - action list

| MAC | Site | First seen | Count | Action |
|---|---|---|---|---|
| {{ mac }} | {{ site }} | {{ first_seen }} | {{ count }} | add to known-devices / investigate |

## Notable events

- {{ event }}

## Digest rules

- Routine churn rules (120505/120506/120509/120510/120512/120517/120520/
  120531/120532) are Class D archive-only - not listed here.
- Escalate to IRIS only on confirmed patterns (repeat offender, MISP IOC match,
  flood trigger).

## Actions

- [ ] Review unknown devices; update known-devices list
- [ ] Investigate any WAN drop flood (rule 120524 storm)
- [ ] {{ action }}
