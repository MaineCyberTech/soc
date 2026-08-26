# Phase 33 Sensor Alert Architecture

Date: 2026-08-25
- Layers: sensor (mct-soc-scan) systemd timer -> p33-alert-runner (suricata-service,
  eve-fresh); core host cron -> p33-core-alert.sh (agent016, backup, disk, tmp, release).
- Alert payload standard (phase33-status-model): state/component/observed/threshold/impact/
  owner/runbook/ack/maintenance/recovery. State-based dedup via STATE_DIR.

## No secrets
