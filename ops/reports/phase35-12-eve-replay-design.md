# Phase 35 Marked Downstream EVE Replay Design

Date: 2026-08-25

## Record design
```json
{
  "timestamp": "2026-08-25T18:10:00.000000+0000",
  "flow_id": 999999999,
  "pcap_cnt": 1,
  "event_type": "alert",
  "src_ip": "192.168.222.200",
  "src_port": 55555,
  "dest_ip": "192.168.222.1",
  "dest_port": 80,
  "proto": "TCP",
  "alert": {
    "action": "allowed",
    "gid": 1,
    "signature_id": 2027967,
    "rev": 4,
    "signature": "ET MALWARE HTTP Request for Possible ELF/LiLocked Ransomware Note [MCT-CANARY-P35-TEST]",
    "category": "A Network Trojan was detected",
    "severity": 1
  },
  "http": {
    "hostname": "192.168.222.1",
    "url": "/README.lilocked",
    "http_user_agent": "MCT-CANARY-P35-TEST-USER-AGENT",
    "http_method": "GET",
    "protocol": "HTTP/1.1"
  },
  "MCT_SYNTHETIC": true,
  "MCT_TEST_ID": "P35-EVE-REPLAY-001",
  "MCT_TEST_ONLY": true
}
```

## Key markers
- MCT_SYNTHETIC: true
- MCT_TEST_ID: P35-EVE-REPLAY-001
- MCT_TEST_ONLY: true
- Signature includes [MCT-CANARY-P35-TEST]
- Unique src_ip 192.168.222.200 (test-only)

## Injection path
- Write marked EVE JSON line to /var/log/suricata/eve-alert.json on sensor
- Agent 016 monitors eve-alert.json -> forwards to Wazuh
- Wazuh decodes (SID 2027967 -> "Suricata: Alert" rule, level 3)
- Test group receives alert

## What this proves
- Agent 016 eve-alert.json forwarding works end-to-end
- Wazuh decode for SID 2027967 works
- Downstream routing (to test group) works

## What this does NOT prove
- Live SPAN capture (packet layer)
- Suricata detection engine (proven separately via local run)

## Cleanup
- Remove injected record from eve-alert.json
- Remove test events from Wazuh (if possible)

## No secrets
