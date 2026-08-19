# Phase 20 Suricata Severity Map (staged - ingest proven, network quiet)

Date: 2026-08-19
Status: **STAGED - ingest PROVEN (1 event), network QUIET.** Rules/routing stay gated until sustained volume measured + operator approval (see phase20-suricata-ingest-proof.md).

## Purpose

Map Suricata `alert.severity` (1-4) to Wazuh rule levels so that severity 1-2 events get
real attention without relying on the loud default signature rules.

## Suricata severity semantics

| Suricata severity | Meaning | Wazuh level target |
|---|---|---|
| 1 | Critical / immediate response | **10** (high alert) |
| 2 | High / potential compromise | **8** |
| 3 | Informational / suspicious | **5** (monitor) |
| 4 | Noise / benign signatures | **3** (informational, archives only) |

## Wazuh rule mapping (proposed local_rules, IDs in 122010 range)

```xml
<group name="mct,suricata,network,">
  <!-- Base: any decoded suricata alert (anchors children) -->
  <rule id="122010" level="5">
    <decoded_as>json</decoded_as>
    <field name="alert.signature" type="pcre2">.+</field>
    <description>Suricata: alert $(alert.signature) from $(src_ip) to $(dest_ip)</description>
    <group>mct,suricata,</group>
  </rule>
  <!-- Severity 2 -> level 8 -->
  <rule id="122011" level="8">
    <if_sid>122010</if_sid>
    <field name="alert.severity" type="pcre2">^2$</field>
    <description>Suricata HIGH: $(alert.signature) from $(src_ip) to $(dest_ip)</description>
    <group>mct,suricata,high,</group>
  </rule>
  <!-- Severity 1 -> level 10 -->
  <rule id="122012" level="10">
    <if_sid>122010</if_sid>
    <field name="alert.severity" type="pcre2">^1$</field>
    <description>Suricata CRITICAL: $(alert.signature) from $(src_ip) to $(dest_ip)</description>
    <group>mct,suricata,critical,</group>
  </rule>
</group>
```

Severity 3/4 fall through to the base 122010 (level 5) and can be suppressed/level-dropped
after volume measurement.

## Class A/B/C map

| Class | Definition | Suricata criteria | Wazuh level | IRIS |
|---|---|---|---|---|
| A | Critical/High | severity 1-2 | 10 / 8 | route when validated |
| B | Suspicious | severity 3 (non-broadcast, non-benign sigs) | 5 | monitor |
| C | Noise/benign | severity 3-4 common sigs (ICMP ping, portscan sweeps) | 3 | none |

## Data-flow contract (from P18 localfile)

eve.json -> agent 008 logcollector (json) -> Wazuh json decoder -> `alert.*`, `src_ip`,
`dest_ip`, `proto`, `event_type` fields. Validate field extraction with logtest on a real
sample before enabling rules (the P18 ICMP alert is a good test: severity 3 -> should land
at base/Class B, not Class A).

## Gating

- No local_rules or IRIS routing enabled until: (1) eve events confirmed ingested,
  (2) 7-day volume measured, (3) severity distribution reviewed.
- Revisit after Phase 19 ingest validation completes.

## No secrets