# Phase 32 Wazuh JSON Decode Test

Date: 2026-08-25
Status: **PROVEN** (wazuh-logtest on manager).

- Sample Suricata alert EVE JSON fed to wazuh-logtest -> decoded:
  level 3, description "Suricata: Alert - ET MALWARE Win32/Trojan Downloader Checkin",
  groups [ids, suricata]. (p32-wazuh-suricata-logtest.sh)
- Confirms the Suricata alert -> Wazuh rule path end-to-end.

## No secrets
