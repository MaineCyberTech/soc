# Phase 31 Suricata Rule / Output Minimization

Date: 2026-08-24

## Ruleset (focused, high-value)

- integrations/suricata-minimal/mct-alerts.rules: 4 alert-only rules (DNS sinkhole indicator,
  HTTP suspicious UA placeholder, TCP scan/syn threshold, ICMP tunnelling) - sid 4100001-4.
- No broad ET PRO download (not licensed/needed); no fileinfo/file-store/payload rules.

## Outputs

- EVE JSON: **alert + stats only** (metadata yes, tagged-packets no, deltas no).
- fast.log enabled (minimal). pcap-log, file-store, payload, fileinfo all **disabled**
  (config gate grep confirms no pcap-log:/file-store:/payload:).
- Disabled app-layer parsers (smtp/imap/pop3/ikev2/nfs/smb) reduce memory + noise.

## Result

- Measured: 70 alerts / 1.3MB eve.json over ~102K packets (light profile) - bounded.

## No secrets