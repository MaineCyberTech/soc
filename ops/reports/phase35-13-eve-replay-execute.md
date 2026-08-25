# Phase 35: Downstream EVE Replay Execution

Date: 2026-08-25 (18:10Z-18:15Z)

## Injection record

Second injection (P35-EVE-REPLAY-002) written to `/var/log/suricata/eve-alert.json` on mct-soc-scan after agent 016 was already running logcollector on that file.

```json
{"timestamp":"2026-08-25T18:15:00.000000+0000","flow_id":888888888,"pcap_cnt":2,"event_type":"alert","src_ip":"192.168.222.200","src_port":55556,"dest_ip":"192.168.222.1","dest_port":80,"proto":"TCP","alert":{"action":"allowed","gid":1,"signature_id":2027967,"rev":4,"signature":"ET MALWARE HTTP Request for Possible ELF/LiLocked Ransomware Note [MCT-CANARY-P35-TEST-002]","category":"A Network Trojan was detected","severity":1},"http":{"hostname":"192.168.222.1","url":"/README.lilocked","http_user_agent":"MCT-CANARY-P35-TEST-USER-AGENT-002","http_method":"GET","protocol":"HTTP/1.1"},"MCT_SYNTHETIC":true,"MCT_TEST_ID":"P35-EVE-REPLAY-002","MCT_TEST_ONLY":true}
```

## Execution sequence

| Step | Time (UTC) | Action | Result |
|---|---|---|---|
| 1 | 18:09 | First injection (record-001) into eve-alert.json | File created, 658 bytes |
| 2 | 18:11 | Agent 016 restarted | Logcollector found file but tracked from EOF — only saw new data |
| 3 | 18:14 | Second injection (record-002) appended | File now 1324 bytes (2 records) |
| 4 | 18:14 | Logcollector picked up record-002 | State: events=1, bytes=666 |
| 5 | 18:14:27 | Alert indexed in OpenSearch | Rule 86601, location /var/log/suricata/eve-alert.json |

## Logcollector state (after injection)

| File | Events | Bytes |
|---|---|---|
| /var/log/suricata/eve.json | 14 | 109802 |
| /var/log/suricata/eve-alert.json | 1 | 666 |
| journald | 385 | 37933 |

## Notes

- First injection (record-001) was NOT forwarded because agent 016 logcollector started monitoring from file end-of-position on restart. Only new data appended after monitor start was captured.
- Second injection (record-002) was captured and forwarded immediately.
- JSON format confirmed in ossec.conf for both eve.json and eve-alert.json localfile entries.

## No secrets
