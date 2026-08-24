# Phase 31 Performance and Efficiency

Date: 2026-08-24

- Core host: 12/15GiB, PSI 0.00 (avg10), swap stale (swappiness 10). Sensor target: PSI 0.
- Suricata-minimal: ~31MB / ~1.1% CPU / 0 drops (efficient; avoids full PCAP/file-store).
- Avoidable work: no broad protocol logging; EVE alert+stats only; focused ruleset (4).
- Retention rolling (daily growth ~100MB).

## No secrets
