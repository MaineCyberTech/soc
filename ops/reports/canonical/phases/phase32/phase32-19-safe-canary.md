# Phase 32 Safe Canary

Date: 2026-08-25
- Canary = controlled suricata-alert routing to a test group (no IRIS case creation).
- Trigger: real alert fires on live SPAN OR offline pcap replay (sid 2027967) injected via
  agent logtest -> validate the full alert path (eve-alert -> agent 016 -> Wazuh -> rule).

## No secrets
