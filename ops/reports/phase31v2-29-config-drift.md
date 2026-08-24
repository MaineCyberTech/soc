# Phase 31v2 Sensor Config Drift

Date: 2026-08-24
- Repo integrations/suricata-minimal/suricata.yaml = deployed /etc/suricata/suricata.yaml
  (scp'd, gate PASS). Systemd unit documented (mct-suricata). Drift monitoring: sha256 of
  config/rules in packet-evidence pack (p31v2-packet-evidence.sh). No drift.

## No secrets
