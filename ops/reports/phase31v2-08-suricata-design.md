# Phase 31v2 Suricata Minimal Design

Date: 2026-08-24
- Standalone sensor (mct-soc-scan, Debian 13), capture ens19 (SPAN), EVE JSON, Wazuh agent 016,
  systemd bounded (MemoryMax 1536M), no PCAP/file-store/payload.
- Repo: integrations/suricata-minimal/{suricata.yaml,mct-alerts.rules}.

## No secrets
