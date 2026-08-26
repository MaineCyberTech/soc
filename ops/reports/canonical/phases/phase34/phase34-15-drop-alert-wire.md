# Phase 34 Capture Drop Alert Wiring

Date: 2026-08-25

## Implementation
- Source: Suricata eve.json stats -> capture.kernel_drops
- Check: extract drops from latest stats event, alert if > 0 for 3 consecutive samples
- Threshold: sustained > 0.1% drop rate
- Dedup: state-based (transition from HEALTHY to FAILED only)
- Recovery: auto-recover when drops return to 0

## Evidence
- Current: 0 drops (8,328,441 packets processed)
- NIC pre-existing drops: 9 (historical, before sensor)
- Alert wired into sensor-side p33-alert-runner.sh (drops check)

## Runbook
- Investigate NIC/driver issues
- Check AF_PACKET buffer sizes
- Verify SPAN port health

## No secrets
