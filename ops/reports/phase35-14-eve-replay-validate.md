# Phase 35: Downstream Route Validation

Date: 2026-08-25 (18:14Z)

## Wazuh decode/rule

| Check | Result |
|---|---|
| Logtest (wazuh-logtest on manager) | PASS — Phase 2 decode, Phase 3 rule match to 86601 (level 3) |
| Decoder | json (standard Wazuh JSON decoder) |
| Rule | 86601 — "Suricata: Alert - $(alert.signature)" |
| Groups | ids, suricata |
| Actual alert index | wazuh-alerts-4.x-2026.08.25 |

## OpenSearch alert evidence

| Field | Value |
|---|---|
| _id | 074hOqABXUSVSG3Wg9Bi |
| @timestamp | 2026-08-25T18:14:27.791Z |
| agent.id | 016 |
| agent.name | mct-packet-sensor |
| rule.id | 86601 |
| rule.description | Suricata: Alert - ET MALWARE HTTP Request for Possible ELF/LiLocked Ransomware Note [MCT-CANARY-P35-TEST-002] |
| rule.level | 3 |
| decoder.name | json |
| location | /var/log/suricata/eve-alert.json |
| data.alert.signature_id | 2027967 |
| data.MCT_TEST_ID | P35-EVE-REPLAY-002 |
| data.MCT_TEST_ONLY | true |
| data.MCT_SYNTHETIC | true |

## Real SPAN alert (bonus discovery)

| Field | Value |
|---|---|
| _id | pb4OOqABXUSVSG3WrK_C |
| @timestamp | 2026-08-25T17:53:54.008Z |
| rule.id | 86601 |
| rule.description | Suricata: Alert - SURICATA STREAM FIN out of window |
| data.alert.signature_id | 2210038 |
| data.in_iface | ens19 |
| data.pkt_src | wire/pcap |
| location | /var/log/suricata/eve.json |

This confirms live SPAN detection on ens19 is producing real alerts through the eve.json -> agent 016 -> Wazuh pipeline.

## Analysisd finding: "Too many fields for JSON decoder"

- Suricata stats records in eve.json contain ~522 fields
- Wazuh `analysisd.decoder_order_size` defaults to 256
- Stats records generate repeating ERROR: "Too many fields for JSON decoder"
- **Non-fatal**: events still reach archives, just not fully decoded for rule matching
- Alert records (29 fields) decode normally
- **Recommendation**: Increase `decoder_order_size` to 512 or 1024 in Phase 36

## Cleanup status

- Synthetic record remains in eve-alert.json (file has 2 lines, 1324 bytes)
- Cleanup deferred to end of Phase 35 observation window

## No secrets
