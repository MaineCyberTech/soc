# Phase 31v2 Pending-Packets Memory

Date: 2026-08-24
- max-pending-packets=1024 (low) trades throughput for memory (research-notes).
- Measured cgroup memory ~32MB - dominated by flows/app-layer, not pending packets at this
  volume. Headroom to 2GiB ceiling is ~60x. Scaling note: raising pending-packets for higher
  rates increases memory; re-benchmark if SPAN volume grows materially.

## No secrets
