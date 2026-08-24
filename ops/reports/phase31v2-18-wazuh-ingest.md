# Phase 31v2 Wazuh Ingest (EVE -> Wazuh)

Date: 2026-08-24
Status: **PROVEN WORKING**.

- Installed Wazuh agent (4.14.7) on the sensor host; enrolled as **agent 016 mct-packet-sensor**
  (registration via WAZUH_REGISTRATION_PASSWORD).
- localfile added: json /var/log/suricata/eve.json; agent active; **224 events shipped to the
  manager** in first 10m (mostly CIS SCA baseline from the fresh agent - expected).
- Suricata decoder path validated: no misclassification (stats events not routed as alerts).
- Note: 0 suricata alerts route because the focused ruleset produces none on this profile
  (17). Ingest pipe proven; detection value gated on broader ruleset.

## No secrets
