# Phase 19 Zeek Rule Tuning Decision

Date: 2026-08-18
Based on: `ops/reports/phase19-zeek-24h-noise-recheck.md`

## Summary

Zeek rules v1 (122000-122006) are too loud because of **multicast/broadcast discovery
traffic** that the v1 exclusions did not cover:

- mDNS (UDP 5353 to 224.0.0.251 / ff02::fb) drives 122000 + 122005 (~147K/24h).
- UDP broadcast (255.255.255.255) and multicast (233.89.188.1) on ports 10001 (Sonos) and
  56700 (LIFX) drives 122006 (~270K/24h).

These are benign LAN discovery protocols. The correct fix is to exclude
broadcast/multicast destinations at the base rule and add destination guards to 122006,
rather than disable detection for unicast traffic.

## Tuning decision per rule

| Rule | Action | v2 change |
|---|---|---|
| 122000 (base) | TUNE | Add dst guard: only unicast destinations (negate broadcast 255.255.255.255, IPv4 multicast 224.0.0.0/4, IPv6 multicast ff00::/8). mDNS/multicast no longer anchors children. |
| 122001/122002/122003/122004 | KEEP | No change (0 alerts, high value). |
| 122005 (internal subnets) | TUNE | Add same unicast-dst guard so it reports unicast internal subnet traffic only. |
| 122006 (UDP) | TUNE | Keep protocol/port exclusions from v1 + add dst guard (unicast only) + exclude ports 10001/56700. |

## Why not just disable 122006?

- The UDP detection intent (non-multicast UDP to non-standard ports = possible exfil/scan)
  is valid; the v1 rule was simply too broad. A unicast-only guard preserves the signal
  while removing the 270K broadcast noise.

## Guard expression (used in v2 XML)

```xml
<!-- unicast-only destination guard for base rule -->
<field name="zeek.resp_h" type="pcre2" negate="yes">^(255\.255\.255\.255|224\.|239\.|233\.|ff[0-9a-fA-F]{2}:)</field>
```

Rationale: `255.255.255.255` = IPv4 limited broadcast; `224./239./233.` = IPv4 multicast
(233 = GLOP/multicast-in-use); `ffXX:` = IPv6 multicast. Guarding the base rule inherits
to all children, so Class A/B detections will not fire for multicast/LLMNR-style noise.

## Deployment

- **APPROVAL-GATED.** v2 XML prepared (`integrations/security-onion/phase19-zeek-custom-rules-v2.xml`).
- Deploy steps (owner: SOC operator): validate with logtest samples -> install to
  `/var/ossec/etc/rules/` on master+worker -> `wazuh-control restart` on manager -> reload
  agents -> re-measure 24h.
- Re-measure targets: 122000/122005/122006 each < 1K/24h; total Zeek alerts < 2K/24h.
- If 122006 still > 5K/24h after v2, disable 122006 and keep TCP-only Class A/B.

## IRIS routing

Remains DISABLED until post-v2 24h re-measure passes. Class A (122001-122003) keep
routing plan unchanged (`integrations/shuffle/phase18-zeek-suricata-routing-map.md`).

## No secrets