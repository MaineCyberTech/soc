# Phase 32 Capture Drop Alert

Date: 2026-08-25
- Monitor capture.kernel_drops (stats.log / eve stats) + NIC rx_dropped (ethtool). Alert on
  sustained drops > threshold (e.g., > 0.1% over window). Currently 0 drops. Design complete.

## No secrets
