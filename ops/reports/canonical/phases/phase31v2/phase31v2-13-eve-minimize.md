# Phase 31v2 EVE Minimization

Date: 2026-08-24
- Disabled: pcap-log, file-store, fileinfo, payload logging, broad app-layer parsers
  (smtp/imap/pop3/ikev2/nfs/smb). eve.json ~0.02MB (no alerts) / bounded.
- Config gate (p31-suricata-config-gate.sh) confirms no pcap-log:/file-store:/payload:.

## No secrets
