# Phase 32 Offline PCAP Detection Proof

Date: 2026-08-25
Status: **PASS - DETECTION CAPABILITY PROVEN**.

- Crafted malicious HTTP GET /README.lilocked (ET sid 2027967 match) with scapy; replayed
  offline: `suricata -r lilocked-test.pcap -S suricata.rules`.
- **1 alert fired**: "ET MALWARE HTTP Request for Possible ELF/LiLocked Ransomware Note"
  (sid 2027967, severity 1). 4 packets, 257 bytes.
- Proves the curated ruleset detects malicious traffic (detection value evidence).

## No secrets
